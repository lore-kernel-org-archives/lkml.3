Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639Ab3JOFIZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:08:25 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:53237 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398Ab3JOFIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:08:23 -0400
Date: Tue, 15 Oct 2013 07:08:19 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Davidlohr Bueso <davidlohr@hp.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
        Jiri Olsa <jolsa@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ramkumar Ramachandra <artagnon@gmail.com>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Roberto Agostino Vitillo <ravitillo@lbl.gov>,
        Stephane Eranian <eranian@google.com>,
        Waiman Long <Waiman.Long@hp.com>, Willy Tarreau <w@1wt.eu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 000/161] perf/core improvements and fixes
Message-ID: <20131015050819.GA32518@gmail.com>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> 
> Hi Ingo,
> 
> 	This was 'make -C tools/perf -f tests/make' tested on Fedora 12 and 18,
> RHEL6.4 and Ubuntu 13.04.
> 
> 	Please consider pulling,
> 
> - Arnaldo
> 
> The following changes since commit 429eb051011a580beae2dc9f8caed5dade9591dc:
> 
>   Merge branch 'perf/urgent' into tools/perf/build (2013-10-08 11:51:31 +0200)
> 
> are available in the git repository at:
> 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-core-for-mingo
> 
> for you to fetch changes up to 784f3390f9bd900adfb3b0373615e105a0d9749a:
> 
>   perf symbols: Fix a mmap and munmap mismatched bug (2013-10-14 12:21:23 -0300)
> 
> ----------------------------------------------------------------
> perf/core improvements and fixes
> 
> . kcore annotation improvements, including build-id cache support,
>   multi map 'call' instruction navigation fixes, kcore address
>   validation, objdump workarounds. From Adrian Hunter.
> 
> . 'trace' beautifiers for lots of syscall arguments.
> 
> . More compact 'trace' output by suppressing zeroed args.
> 
> . Show thread COMM by default in 'trace'.
> 
> . Show path associated with fd in live sessions, using a 'vfs_getname'
>   'perf probe' created dynamic tracepoint or by looking at /proc/pid/fd.
> 
> . Memory and mmap leak fixes from Chenggang Qin.
> 
> . Add option to show full timestamp in 'trace', from David Ahern.
> 
> . Add 'record' command in 'trace', to record raw_syscalls:*, from David Ahern.
> 
> . Add summary option to dump syscall statistics in 'trace', from David Ahern.
> 
> . Fix comm resolution in 'trace' when reading events from file, from David Ahern.
> 
> . Improved messages when doing profiling in all or a subset of CPUs
>   using a workload as the session delimitator, as in:
> 
>    'perf stat --cpu 0,2 sleep 10s'
> 
> . Add units to nanosec-based counters in 'perf stat', from David Ahern.
> 
> . Assorted build fixes for from David Ahern and Jiri Olsa.
> 
> . 'perf lock' fixes and cleanups, from Davidlohr Bueso.
> 
> . Memory leak fixes in 'perf test', from Felipe Pena.
> 
> . Build system super speedups, from Ingo Molnar.
> 
> . Fix mmap_read event overflow, from Jiri Olsa.
> 
> . Code cleanups from Jiri Olsa.
> 
> . Allow specifying B/K/M/G unit to the --mmap-pages arguments, from Jiri Olsa.
> 
> . Separate the GTK support in a separate libperf-gtk.so DSO, that is
>   only loaded when --gtk is specified, from Namhyung Kim.
> 
> . Fixes for some memory leaks, from Namhyumg Kim.
> 
> . Fix srcline sort key behavior, from Namhyung Kim.
> 
> . Fix failing assertions in numa bench, from Petr Holasek.
> 
> . perf bash completion fixes and improvements from Ramkumar Ramachandra.
> 
> . Improve error messages in 'trace', providing hints about system configuration
>   steps needed for using it, from Ramkumar Ramachandra.
> 
> . Remove bogus info when using 'perf stat' -e cycles/instructions, from
>   Ramkumar Ramachandra .
> 
> . Support for Openembedded/Yocto -dbg packages, from Ricardo Ribalda Delgado.
> 
> . Implement addr2line directly using libbfd, from Roberto Vitillo.
> 
> . Add new option --ignore-vmlinux for perf top, from Willy Tarreau.
> 
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> ----------------------------------------------------------------
> Adrian Hunter (10):
>       perf machine: Use snprintf instead of sprintf
>       perf symbols: Make a separate function to parse /proc/modules
>       perf symbols: Validate kcore module addresses
>       perf symbols: Workaround objdump difficulties with kcore
>       perf annotate: Find kcore symbols on other maps
>       perf tools: Add copyfile_mode()
>       perf symbols: Add ability to find kcore in build-id cache
>       perf annotate: Fix annotate_browser__callq()
>       perf buildid-cache: Add ability to add kcore to the cache
>       perf annotate: Another fix for annotate_browser__callq()
> 
> Arnaldo Carvalho de Melo (27):
>       perf trace: Put syscall formatter parms into struct
>       perf trace: Allow passing parms to arg formatters
>       perf trace: Use strarray for ltrace's whence arg
>       perf trace: Beautify fcntl 'cmd' arg
>       perf trace: Beautify rt_sigprocmask 'how' arg
>       perf trace: Beautify signal number arg in several syscalls
>       perf trace: Beautify socket 'family' arg
>       perf trace: Beautify socket 'type' arg
>       perf trace: Beautify access 'mode' arg
>       perf trace: Beautify rlmimit resources
>       perf trace: Don't print zeroed args
>       perf trace: Beautify send/recv syscall 'flags' arg
>       perf trace: Beautify eventfd2 'flags' arg
>       perf trace: Add option to show process COMM
>       perf trace: Beautify epoll_ctl 'op' arg
>       perf trace: Beautify flock 'cmd' arg
>       perf trace: Add helper for syscalls with a single strarray arg
>       perf trace: Don't supress zeroed args when there is an strarray entry for it
>       perf trace: Use socket's beautifiers in socketpair
>       perf trace: Beautify pipe2 'flags' arg
>       perf trace: Beautify mlock & friends 'addr' arg
>       perf trace: Show path associated with fd in live sessions
>       perf trace: Add 'trace' alias to 'perf trace'
>       perf trace: Allow specifying index offset in strarrays
>       perf trace: Prepare the strarray scnprintf method for reuse
>       perf trace: Initial beautifier for ioctl's 'cmd' arg
>       perf symbols: Add map_groups__find_ams()
> 
> Chenggang Qin (2):
>       perf symbols: Fix a memory leak due to symbol__delete not being used
>       perf symbols: Fix a mmap and munmap mismatched bug
> 
> David Ahern (15):
>       perf trace: Add option to show full timestamp
>       perf trace: Remove duplicate mmap entry in syscall_fmts array
>       perf trace: Add beautifier for clock_gettime's clk_id argument
>       perf trace: Handle MSG_WAITFORONE not defined
>       perf stat: Fix misleading message when specifying cpu list or system wide
>       perf stat: Don't require a workload when using system wide or CPU options
>       perf stat: Add units to nanosec-based counters
>       perf trace: Fix comm resolution when reading events from file
>       perf trace: Add record option
>       perf machine: Add method to loop over threads and invoke handler
>       perf trace: Use new machine method to loop over threads
>       perf intlist: Add priv member
>       perf util: Add findnew method to intlist
>       perf trace: Add summary option to dump syscall statistics
>       perf tools: Fix old GCC build error in 'get_srcline'
> 
> Davidlohr Bueso (6):
>       perf lock: Remove dead code
>       perf lock: Return proper code in report_lock_*_event
>       perf lock: Plug some memleaks
>       perf lock: Redo __cmd_report
>       perf lock: Limit bad rate precision
>       perf lock: Account for lock average wait time
> 
> Felipe Pena (1):
>       perf tests: Fix memory leak in dso-data.c
> 
> Ingo Molnar (65):
>       tools/perf: Standardize feature support define names to: HAVE_{FEATURE}_SUPPORT
>       tools/perf/build: Add feature check core code
>       tools/perf/build: Add 'autodep' functionality, generate feature test dependencies automatically
>       tools/perf/build: Split out feature check: 'libnuma'
>       tools/perf/build: Split out feature check: 'stackprotector-all'
>       tools/perf/build: Split out feature check: 'stackprotector'
>       tools/perf/build: Split out feature check: 'volatile-register-var'
>       tools/perf/build: Split out feature check: 'fortify-source'
>       tools/perf/build: Split out feature check: 'bionic'
>       tools/perf/build: Clean up the libelf logic in config/Makefile
>       tools/perf/build: Split out feature check: 'libelf'
>       tools/perf/build: Split out feature check: 'glibc'
>       tools/perf/build: Split out feature check: 'dwarf'
>       tools/perf/build: Clean up the mmap logic in config/Makefile
>       tools/perf/build: Split out feature check: 'libelf-mmap'
>       tools/perf/build: Split out feature check: 'libelf-getphdrnum'
>       tools/perf/build: Clean up the libunwind logic in config/Makefile
>       tools/perf/build: Split out feature check: 'libunwind'
>       tools/perf/build: Split out feature check: 'libaudit'
>       tools/perf/build: Split out feature check: 'libslang'
>       tools/perf/build: Split out feature check: 'gtk2'
>       tools/perf/build: Split out feature check: 'gtk2-infobar'
>       tools/perf/build: Split out feature check: 'libperl'
>       tools/perf/build: Split out feature check: 'libpython'
>       tools/perf/build: Split out feature check: 'libpython-version'
>       tools/perf/build: Split out feature check: 'libbfd'
>       tools/perf/build: Split out feature check: 'strlcpy'
>       tools/perf/build: Split out feature check: 'on-exit'
>       tools/perf/build: Split out feature check: 'backtrace'
>       tools/perf: Clean up util/include/linux/compiler.h
>       tools/perf: Turn strlcpy() into a __weak function
>       tools/perf/build: Speed up auto-detection of features by adding a 'test-all' target
>       tools/perf/build: Speed up git-version test on re-make
>       tools/perf/build: Speed up the final link
>       tools/perf: Fix double/triple-build of the feature detection logic during 'make install' et al
>       tools/perf/build: Invoke feature-checks 'clean' target from the main Makefile
>       tools/perf/build: Speed up auto-detection
>       tools/perf/build: Improve printout-of auto-detected features
>       tools/perf/build: Automatically build in parallel, based on number of CPUs in the system
>       tools/perf/build: Flip Makefile.parallel and Makefile.perf
>       tools/perf/build: Standardize the various messages output by parallel make
>       tools/perf/build: Split out feature checks: 'liberty', 'liberty-z', 'cplus-demangle'
>       tools/perf/build: Remove unused config/feature-tests.mak
>       tools/perf/build: Clean up various testcases
>       tools/perf/build: Collapse the test-all.c testcase
>       tools/perf/build: Pass through all targets to Makefile.perf
>       tools/perf/build: Make sure autodep feature binaries honor the O= setting
>       tools/perf/build: Exclude MAKEFLAGS from nested invocation
>       tools/perf/build: Fix non-canonical directory names in O=
>       tools/perf/build: Fix O=/some/dir perf.o type of targets
>       tools/perf/build: Harmonize the style of the feature testcases
>       tools/perf/build: Pass through LDFLAGS to feature tests
>       perf bench sched: Add --threaded option
>       perf tools: Fix redirection printouts
>       perf tools: Implement summary output for 'make clean'
>       tools: Harmonize the various build messages in perf, lib-traceevent, lib-lk
>       perf tools: Align perf version output to other build messages
>       perf tools: Implement summary output for 'make install'
>       tools/perf/build: Fix non-existent build directory handling
>       tools/perf/build: Pass through DEBUG parameter
>       tools/perf/build: Fix DPACKAGE definitions for the libbfd et al testcases
>       tools/perf/build: Simplify the libelf logic
>       tools/perf/build: Remove the volatile-register-var feature check
>       tools/perf/build: Improve the 'stackprotector' feature test
>       tools/perf/build: Simplify the autodep inclusion rule
> 
> Jiri Olsa (11):
>       tools/perf/build: Clean up feature_print_code()
>       perf tools: Remove unused trace-event-* code
>       perf tools: Unify page_size usage
>       perf tools: Check mmap pages value early
>       perf tools: Add possibility to specify mmap size
>       perf evlist: Introduce perf_evlist__new_default function
>       perf tools: Adding throttle event data struct support
>       perf tools: Add missing -ldl for gtk build
>       perf tools: Move start conditions to start of the flex file
>       perf evlist: Fix perf_evlist__mmap_read event overflow
>       perf tools: Separate lbfd check out of NO_DEMANGLE condition
> 
> Namhyung Kim (9):
>       perf tools: Separate out GTK codes to libperf-gtk.so
>       perf sort: Fix a memory leak on srcline
>       perf annotate: Reuse path from the result of addr2line
>       perf hists: Free srcline when freeing hist_entry
>       perf annotate: Factor out get/free_srcline()
>       perf tools: Do not try to call addr2line on non-binary files
>       perf annotate: Pass dso instead of dso_name to get_srcline()
>       perf tools: Save failed result of get_srcline()
>       perf tools: Fix srcline sort key behavior
> 
> Petr Holasek (1):
>       perf bench: Fix failing assertions in numa bench
> 
> Ramkumar Ramachandra (11):
>       perf completion: Don't dictate perf install location
>       perf completion: Update __ltrim_colon_completions
>       perf completion: Strip dependency on _filedir
>       perf completion: Strip function_exists ()
>       perf completion: Strip dependency on bash-completion
>       perf completion: Use more comp words
>       perf stat: Don't print bogus data on -e cycles
>       perf stat: Don't print bogus data on -e instructions
>       perf tools: Ignore 'perf timechart' output file
>       perf timechart: Add example in the documentation
>       perf trace: Improve the error messages
> 
> Ricardo Ribalda Delgado (1):
>       perf symbols: Support for Openembedded/Yocto -dbg packages
> 
> Roberto Vitillo (1):
>       perf tools: Implement addr2line directly using libbfd
> 
> Willy Tarreau (1):
>       perf symbols: Add new option --ignore-vmlinux for perf top
> 
>  tools/lib/traceevent/Makefile                      |   18 +-
>  tools/perf/.gitignore                              |    1 +
>  tools/perf/Documentation/Makefile                  |   79 +-
>  tools/perf/Documentation/perf-buildid-cache.txt    |   13 +
>  tools/perf/Documentation/perf-kvm.txt              |    4 +-
>  tools/perf/Documentation/perf-lock.txt             |    2 +-
>  tools/perf/Documentation/perf-record.txt           |    4 +-
>  tools/perf/Documentation/perf-timechart.txt        |   15 +-
>  tools/perf/Documentation/perf-top.txt              |    4 +-
>  tools/perf/Documentation/perf-trace.txt            |   27 +-
>  tools/perf/Makefile                                |  848 +--------------
>  tools/perf/Makefile.perf                           |  887 ++++++++++++++++
>  tools/perf/arch/x86/include/perf_regs.h            |    6 +-
>  tools/perf/arch/x86/util/unwind.c                  |    4 +-
>  tools/perf/bash_completion                         |  106 +-
>  tools/perf/bench/mem-memcpy-arch.h                 |    2 +-
>  tools/perf/bench/mem-memcpy.c                      |    2 +-
>  tools/perf/bench/mem-memset-arch.h                 |    2 +-
>  tools/perf/bench/mem-memset.c                      |    2 +-
>  tools/perf/bench/numa.c                            |   34 +-
>  tools/perf/bench/sched-pipe.c                      |  115 +-
>  tools/perf/builtin-annotate.c                      |   26 +-
>  tools/perf/builtin-bench.c                         |    4 +-
>  tools/perf/builtin-buildid-cache.c                 |  148 ++-
>  tools/perf/builtin-inject.c                        |    2 +-
>  tools/perf/builtin-kvm.c                           |    5 +-
>  tools/perf/builtin-lock.c                          |  124 ++-
>  tools/perf/builtin-probe.c                         |   14 +-
>  tools/perf/builtin-record.c                        |   26 +-
>  tools/perf/builtin-report.c                        |   16 +-
>  tools/perf/builtin-stat.c                          |   29 +-
>  tools/perf/builtin-top.c                           |    7 +-
>  tools/perf/builtin-trace.c                         | 1108 +++++++++++++++++---
>  tools/perf/config/Makefile                         |  358 ++++---
>  tools/perf/config/feature-checks/Makefile          |  144 +++
>  tools/perf/config/feature-checks/test-all.c        |  106 ++
>  tools/perf/config/feature-checks/test-backtrace.c  |   13 +
>  tools/perf/config/feature-checks/test-bionic.c     |    6 +
>  .../config/feature-checks/test-cplus-demangle.c    |   14 +
>  tools/perf/config/feature-checks/test-dwarf.c      |   10 +
>  .../config/feature-checks/test-fortify-source.c    |    6 +
>  tools/perf/config/feature-checks/test-glibc.c      |    8 +
>  .../perf/config/feature-checks/test-gtk2-infobar.c |   11 +
>  tools/perf/config/feature-checks/test-gtk2.c       |   10 +
>  tools/perf/config/feature-checks/test-hello.c      |    6 +
>  tools/perf/config/feature-checks/test-libaudit.c   |   10 +
>  tools/perf/config/feature-checks/test-libbfd.c     |   15 +
>  .../config/feature-checks/test-libelf-getphdrnum.c |    8 +
>  .../perf/config/feature-checks/test-libelf-mmap.c  |    8 +
>  tools/perf/config/feature-checks/test-libelf.c     |    8 +
>  tools/perf/config/feature-checks/test-libnuma.c    |    9 +
>  tools/perf/config/feature-checks/test-libperl.c    |    9 +
>  .../config/feature-checks/test-libpython-version.c |   10 +
>  tools/perf/config/feature-checks/test-libpython.c  |    8 +
>  tools/perf/config/feature-checks/test-libslang.c   |    6 +
>  tools/perf/config/feature-checks/test-libunwind.c  |   27 +
>  tools/perf/config/feature-checks/test-on-exit.c    |   15 +
>  .../feature-checks/test-stackprotector-all.c       |    6 +
>  .../config/feature-checks/test-stackprotector.c    |    6 +
>  .../feature-checks/test-volatile-register-var.c    |    6 +
>  tools/perf/config/feature-tests.mak                |  246 -----
>  tools/perf/config/utilities.mak                    |   17 +-
>  tools/perf/perf.c                                  |   14 +-
>  tools/perf/tests/dso-data.c                        |    1 +
>  tools/perf/tests/perf-record.c                     |   12 +-
>  tools/perf/tests/task-exit.c                       |   14 +-
>  tools/perf/ui/browsers/annotate.c                  |   24 +-
>  tools/perf/ui/gtk/annotate.c                       |   13 +-
>  tools/perf/ui/gtk/browser.c                        |    2 +-
>  tools/perf/ui/gtk/gtk.h                            |   20 +-
>  tools/perf/ui/gtk/util.c                           |    4 +-
>  tools/perf/ui/setup.c                              |   61 +-
>  tools/perf/ui/ui.h                                 |   14 +-
>  tools/perf/util/PERF-VERSION-GEN                   |    2 +-
>  tools/perf/util/annotate.c                         |   76 +-
>  tools/perf/util/annotate.h                         |   26 +-
>  tools/perf/util/cache.h                            |    3 +-
>  tools/perf/util/dso.c                              |   50 +-
>  tools/perf/util/dso.h                              |    3 +
>  tools/perf/util/event.h                            |   10 +
>  tools/perf/util/evlist.c                           |   82 +-
>  tools/perf/util/evlist.h                           |    9 +-
>  tools/perf/util/evsel.c                            |    3 +
>  tools/perf/util/generate-cmdlist.sh                |    4 +-
>  tools/perf/util/hist.c                             |    1 +
>  tools/perf/util/hist.h                             |   17 +-
>  tools/perf/util/include/dwarf-regs.h               |    2 +-
>  tools/perf/util/include/linux/compiler.h           |   19 +-
>  tools/perf/util/intlist.c                          |   23 +-
>  tools/perf/util/intlist.h                          |    2 +
>  tools/perf/util/machine.c                          |  113 +-
>  tools/perf/util/machine.h                          |    5 +
>  tools/perf/util/map.c                              |   50 +-
>  tools/perf/util/map.h                              |    7 +
>  tools/perf/util/parse-events.l                     |   63 +-
>  tools/perf/util/path.c                             |   10 +-
>  tools/perf/util/perf_regs.h                        |    4 +-
>  tools/perf/util/probe-event.c                      |    4 +-
>  tools/perf/util/probe-finder.h                     |    4 +-
>  tools/perf/util/python.c                           |    8 +-
>  tools/perf/util/rblist.c                           |   27 +-
>  tools/perf/util/rblist.h                           |    1 +
>  tools/perf/util/session.c                          |   13 +
>  tools/perf/util/sort.c                             |   58 +-
>  tools/perf/util/srcline.c                          |  265 +++++
>  tools/perf/util/symbol-elf.c                       |  607 ++++++++++-
>  tools/perf/util/symbol-minimal.c                   |   15 +
>  tools/perf/util/symbol.c                           |  449 ++++++--
>  tools/perf/util/symbol.h                           |   29 +-
>  tools/perf/util/trace-event-parse.c                |   36 -
>  tools/perf/util/trace-event.h                      |    9 -
>  tools/perf/util/unwind.h                           |    4 +-
>  tools/perf/util/util.c                             |   47 +-
>  tools/perf/util/util.h                             |   24 +
>  tools/scripts/Makefile.include                     |   23 +-
>  115 files changed, 5144 insertions(+), 2032 deletions(-)
>  create mode 100644 tools/perf/Makefile.perf
>  create mode 100644 tools/perf/config/feature-checks/Makefile
>  create mode 100644 tools/perf/config/feature-checks/test-all.c
>  create mode 100644 tools/perf/config/feature-checks/test-backtrace.c
>  create mode 100644 tools/perf/config/feature-checks/test-bionic.c
>  create mode 100644 tools/perf/config/feature-checks/test-cplus-demangle.c
>  create mode 100644 tools/perf/config/feature-checks/test-dwarf.c
>  create mode 100644 tools/perf/config/feature-checks/test-fortify-source.c
>  create mode 100644 tools/perf/config/feature-checks/test-glibc.c
>  create mode 100644 tools/perf/config/feature-checks/test-gtk2-infobar.c
>  create mode 100644 tools/perf/config/feature-checks/test-gtk2.c
>  create mode 100644 tools/perf/config/feature-checks/test-hello.c
>  create mode 100644 tools/perf/config/feature-checks/test-libaudit.c
>  create mode 100644 tools/perf/config/feature-checks/test-libbfd.c
>  create mode 100644 tools/perf/config/feature-checks/test-libelf-getphdrnum.c
>  create mode 100644 tools/perf/config/feature-checks/test-libelf-mmap.c
>  create mode 100644 tools/perf/config/feature-checks/test-libelf.c
>  create mode 100644 tools/perf/config/feature-checks/test-libnuma.c
>  create mode 100644 tools/perf/config/feature-checks/test-libperl.c
>  create mode 100644 tools/perf/config/feature-checks/test-libpython-version.c
>  create mode 100644 tools/perf/config/feature-checks/test-libpython.c
>  create mode 100644 tools/perf/config/feature-checks/test-libslang.c
>  create mode 100644 tools/perf/config/feature-checks/test-libunwind.c
>  create mode 100644 tools/perf/config/feature-checks/test-on-exit.c
>  create mode 100644 tools/perf/config/feature-checks/test-stackprotector-all.c
>  create mode 100644 tools/perf/config/feature-checks/test-stackprotector.c
>  create mode 100644 tools/perf/config/feature-checks/test-volatile-register-var.c
>  delete mode 100644 tools/perf/config/feature-tests.mak
>  create mode 100644 tools/perf/util/srcline.c

Pulled, thanks a lot Arnaldo!

	Ingo
