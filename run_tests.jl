# Run a number of regression tests for RunTests.jl
#
# NOTE: the baseline files can be regenerated by passing the --rebaseline
# argument at the command line
#

module StandardizeRunTestsOutput
  import RunTests

  RunTests.set_show_progress(false)
  RunTests.set_tty_cols(80)
  RunTests.set_show_backtraces(false)
end

module RegressionTest
  import RunTests
  import Base.Test.@test

  export regression_test

  const REBASELINE_DFLT = ("--rebaseline" in ARGS)


  function regression_test(fn::Function, baseline_file::String; rebaseline::Bool=REBASELINE_DFLT)
    result, data, err = RunTests.capture_output() do
      fn()
    end

    if err!=Nothing
       rethrow(err)
    end

    if rebaseline
      open(baseline_file, "w") do f
        serialize(f, result)
        serialize(f, data)
      end
      println("Regenerated baseline file: $baseline_file")
    else
      open(baseline_file, "r") do f
        @test result==deserialize(f)
        @test data==deserialize(f)
      end
    end
  end
end

module EachTestFolderOneAtATime
  using RegressionTest
  using RunTests

  println("test1")
  regression_test("test/test1.out") do
    run_tests("test/test1")
  end

  println("test2")
  regression_test("test/test2.out") do
    run_tests("test/test2")
  end

  println("test3")
  regression_test("test/test3.out") do
    run_tests("test/test3")
  end

  println("test4")
  regression_test("test/test4.out") do
    run_tests("test/test4")
  end

  println("test5")
  regression_test("test/test5.out") do
    run_tests("test/test5")
  end

  println("test6")
  regression_test("test/test6.out") do
    run_tests("test/test6")
  end

  println("test7")
  regression_test("test/test7.out") do
    run_tests("test/test7")
  end
end

module AllTheTestsAtOnce
  using RegressionTest
  using RunTests

  println("testAll")
  regression_test("test/testAll.out") do
    run_tests()
  end
end

