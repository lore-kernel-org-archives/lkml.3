Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773AbaHMWyq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 18:54:46 -0400
Received: from mail.kernel.org ([198.145.19.201]:56026 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753100AbaHMWyo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 18:54:44 -0400
Date: Wed, 13 Aug 2014 19:54:38 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Static build of libtraceevent failing on ubuntu13 x86_64
Message-ID: <20140813225438.GM2718@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

	Have you ever stumbled on this?

	It is the only target breaking when I do a test build of perf + libtraceevent
on several distros/arches, the command is:

$ make -C tools/perf build-test

Distro is ubuntu12

acme@ubuntu13:~/git/linux$ cat /etc/debian_version 
wheezy/sid
acme@ubuntu13:~/git/linux$ uname -a
Linux ubuntu13 3.11.0-26-generic #45-Ubuntu SMP Tue Jul 15 04:02:06 UTC 2014 x86_64 x86_64 x86_64 GNU/Linux

- Arnaldo

- make_static: cd . && make -f Makefile DESTDIR=/tmp/tmp.18qUa2nzwd LDFLAGS=-static
cd . && make -f Makefile DESTDIR=/tmp/tmp.18qUa2nzwd LDFLAGS=-static
  BUILD:   Doing 'make -j4' parallel build
config/Makefile:345: No libdw DWARF unwind found, Please install elfutils-devel/libdw-dev >= 0.158 and/or set LIBDW_DIR
config/Makefile:349: No libdw.h found or old libdw.h found or elfutils is older than 0.138, disables dwarf support. Please install new elfutils-devel/libdw-dev
config/Makefile:383: No libunwind found. Please install libunwind-dev[el] >= 1.1 and/or set LIBUNWIND_DIR
config/Makefile:394: Disabling post unwind, no support found.
config/Makefile:459: GTK2 not found, disables GTK2 support. Please install gtk2-devel or libgtk2.0-dev
config/Makefile:487: Missing perl devel files. Disabling perl scripting support, consider installing perl-ExtUtils-Embed
config/Makefile:530: No Python.h (for Python 2.x) was found
config/Makefile:530: Python support will not be built

Auto-detecting system features:
...                         dwarf: [ OFF ]
...                         glibc: [ on  ]
...                          gtk2: [ OFF ]
...                      libaudit: [ on  ]
...                        libbfd: [ on  ]
...                        libelf: [ on  ]
...                       libnuma: [ on  ]
...                       libperl: [ OFF ]
...                     libpython: [ OFF ]
...                      libslang: [ on  ]
...                     libunwind: [ OFF ]
...            libdw-dwarf-unwind: [ OFF ]

  GEN      common-cmds.h
  FLAGS:   * new build flags or prefix
  BISON    util/pmu-bison.c
  CC       util/environment.o
  CC       util/event.o
  CC       util/evlist.o
  CC       util/evsel.o
  PERF_VERSION = 3.16.g1c6505
  CC       util/exec_cmd.o
  CC       util/help.o
  CC       util/kallsyms.o
  CC       util/levenshtein.o
  CC       util/parse-options.o
  BISON    util/parse-events-bison.c
  CC       util/path.o
  CC       util/rbtree.o
  CC       util/bitmap.o
  CC       util/hweight.o
  CC       util/run-command.o
  CC       util/quote.o
  CC       util/strbuf.o
  CC       util/string.o
  CC       util/strlist.o
  CC       util/strfilter.o
  CC       util/top.o
  CC       util/usage.o
  CC       util/wrapper.o
  CC       util/sigchain.o
  CC       util/dso.o
  CC       util/symbol.o
  CC       util/symbol-elf.o
  CC       util/color.o
  CC       util/pager.o
  CC       util/header.o
  CC       util/callchain.o
  CC       util/values.o
  CC       util/debug.o
  CC       util/machine.o
  CC       util/map.o
  CC       util/pstack.o
  CC       util/session.o
  CC       util/ordered-events.o
  CC       util/comm.o
  CC       util/thread.o
  CC       util/thread_map.o
  CC       util/trace-event-parse.o
  CC       util/parse-events-bison.o
  CC       util/pmu-bison.o
  CC       util/trace-event-read.o
  CC       util/trace-event-info.o
  CC       util/trace-event-scripting.o
  CC       util/trace-event.o
  CC       util/svghelper.o
  CC       util/sort.o
  CC       util/hist.o
  CC       util/probe-event.o
  CC       util/util.o
  CC       util/xyarray.o
  CC       util/cpumap.o
  CC       util/cgroup.o
  CC       util/target.o
  CC       util/rblist.o
  CC       util/intlist.o
  CC       util/vdso.o
  CC       util/stat.o
  CC       util/record.o
  CC       util/srcline.o
  CC       util/data.o
  CC       util/tsc.o
  CC       util/cloexec.o
  CC       ui/setup.o
  CC       ui/helpline.o
  CC       ui/progress.o
  CC       ui/util.o
  CC       ui/hist.o
  CC       ui/stdio/hist.o
  CC       arch/common.o
  CC       tests/parse-events.o
  CC       tests/dso-data.o
  CC       tests/attr.o
  CC       tests/vmlinux-kallsyms.o
  CC       tests/open-syscall.o
  CC       tests/open-syscall-all-cpus.o
  CC       tests/open-syscall-tp-fields.o
  CC       tests/mmap-basic.o
  CC       tests/perf-record.o
  CC       tests/rdpmc.o
  CC       tests/evsel-roundtrip-name.o
  CC       tests/evsel-tp-sched.o
  CC       tests/pmu.o
  CC       tests/hists_common.o
  CC       tests/hists_link.o
  CC       tests/hists_filter.o
  CC       tests/hists_output.o
  CC       tests/hists_cumulate.o
  CC       tests/python-use.o
  CC       tests/bp_signal.o
  CC       tests/bp_signal_overflow.o
  CC       tests/task-exit.o
  CC       tests/sw-clock.o
  CC       tests/perf-time-to-tsc.o
  CC       tests/code-reading.o
  CC       tests/sample-parsing.o
  CC       tests/parse-no-sample-id-all.o
  CC       tests/mmap-thread-lookup.o
  CC       tests/thread-mg-share.o
  CC       arch/x86/util/header.o
  CC       arch/x86/util/tsc.o
  CC       arch/x86/util/kvm-stat.o
  CC       tests/keep-tracking.o
  CC       ui/browser.o
  CC       ui/browsers/annotate.o
  CC       ui/browsers/hists.o
  CC       ui/browsers/map.o
  CC       ui/browsers/scripts.o
  CC       ui/browsers/header.o
  CC       ui/tui/setup.o
  CC       ui/tui/util.o
  CC       ui/tui/helpline.o
  CC       ui/tui/progress.o
  CC       util/perf_regs.o
  SUBDIR   /home/acme/git/linux/tools/lib/api/
  MKDIR    libapi_dirs
  CC       fs/debugfs.o
  SUBDIR   /home/acme/git/linux/tools/lib/traceevent/
  GEN      perf-archive
  FLAGS:   * new build flags or cross compiler
  CC       perf.o
  CC       builtin-annotate.o
  CC       fs/fs.o
  AR       libapikfs.a
  CC       builtin-bench.o
  CC       bench/sched-messaging.o
  CC FPIC  event-parse.o
  CC       bench/sched-pipe.o
  CC       bench/mem-memcpy.o
  CC       bench/mem-memset.o
  CC       bench/futex-hash.o
  CC       bench/futex-wake.o
  CC       bench/futex-requeue.o
  CC FPIC  event-plugin.o
  CC       builtin-diff.o
  CC       builtin-evlist.o
  CC FPIC  trace-seq.o
  CC       builtin-help.o
  CC FPIC  parse-filter.o
  CC       builtin-sched.o
  CC FPIC  parse-utils.o
  CC FPIC  kbuffer-parse.o
  CC       builtin-buildid-list.o
  CC FPIC  plugin_jbd2.o
  CC FPIC  plugin_hrtimer.o
  CC FPIC  plugin_kmem.o
  CC FPIC  plugin_kvm.o
  CC       builtin-buildid-cache.o
  CC FPIC  plugin_mac80211.o
  CC       builtin-list.o
  CC FPIC  plugin_sched_switch.o
  CC FPIC  plugin_function.o
  CC FPIC  plugin_xen.o
  CC       builtin-record.o
  CC FPIC  plugin_scsi.o
  CC FPIC  plugin_cfg80211.o
  CC       builtin-report.o
  LINK     libtraceevent.a
  LINK     plugin_jbd2.so
  LINK     plugin_hrtimer.so
  LINK     plugin_kmem.so
  LINK     plugin_kvm.so
  LINK     plugin_mac80211.so
  LINK     plugin_sched_switch.so
  LINK     plugin_function.so
  LINK     plugin_xen.so
  CC       builtin-stat.o
  CC       builtin-timechart.o
  LINK     plugin_scsi.so
  LINK     plugin_cfg80211.so
  CC       builtin-top.o
  CC       builtin-script.o
  CC       builtin-probe.o
  CC       builtin-kmem.o
  CC       builtin-lock.o
  CC       builtin-kvm.o
  CC       builtin-inject.o
  CC       tests/builtin-test.o
  CC       builtin-mem.o
  CC       builtin-trace.o
  CC       bench/numa.o
  CC       util/abspath.o
  CC       util/alias.o
  CC       util/annotate.o
  CC       util/build-id.o
  CC       util/config.o
  CC       util/ctype.o
  FLEX     util/pmu-flex.c
  FLEX     util/parse-events-flex.c
  CC       util/pmu.o
  CC       util/pmu-flex.o
  CC       util/parse-events.o
  CC       util/parse-events-flex.o
  AR       libperf.a
  LINK     perf
/home/acme/git/linux/tools/lib/traceevent/libtraceevent.a(event-plugin.o): In function `load_plugin':
/home/acme/git/linux/tools/lib/traceevent/event-plugin.c:256: warning: Using 'dlopen' in statically linked applications requires at runtime the shared libraries from the glibc version used for linking
/usr/lib/gcc/x86_64-linux-gnu/4.8/../../../x86_64-linux-gnu/libaudit.a(libaudit.o): In function `audit_rule_fieldpair_data':
(.text+0x191b): warning: Using 'getgrnam' in statically linked applications requires at runtime the shared libraries from the glibc version used for linking
/usr/lib/gcc/x86_64-linux-gnu/4.8/../../../x86_64-linux-gnu/libaudit.a(libaudit.o): In function `audit_rule_fieldpair_data':
(.text+0x1978): warning: Using 'getpwnam' in statically linked applications requires at runtime the shared libraries from the glibc version used for linking
libperf.a(target.o): In function `target__parse_uid':
/home/acme/git/linux/tools/perf/util/target.c:79: warning: Using 'getpwnam_r' in statically linked applications requires at runtime the shared libraries from the glibc version used for linking
/home/acme/git/linux/tools/perf/util/target.c:91: warning: Using 'getpwuid_r' in statically linked applications requires at runtime the shared libraries from the glibc version used for linking
/usr/lib/gcc/x86_64-linux-gnu/4.8/../../../../lib/libnuma.a(affinity.o): In function `affinity_ip':
(.text+0x765): warning: Using 'getaddrinfo' in statically linked applications requires at runtime the shared libraries from the glibc version used for linking
/usr/lib/gcc/x86_64-linux-gnu/4.8/../../../../lib/libbfd.a(compress.o): In function `bfd_compress_section_contents':
/build/buildd/binutils-2.23.52.20130913/builddir-single/bfd/../../bfd/compress.c:100: undefined reference to `compressBound'
/build/buildd/binutils-2.23.52.20130913/builddir-single/bfd/../../bfd/compress.c:106: undefined reference to `compress'
/usr/lib/gcc/x86_64-linux-gnu/4.8/../../../../lib/libbfd.a(compress.o): In function `decompress_contents':
/build/buildd/binutils-2.23.52.20130913/builddir-single/bfd/../../bfd/compress.c:49: undefined reference to `inflateInit_'
/build/buildd/binutils-2.23.52.20130913/builddir-single/bfd/../../bfd/compress.c:56: undefined reference to `inflate'
/build/buildd/binutils-2.23.52.20130913/builddir-single/bfd/../../bfd/compress.c:59: undefined reference to `inflateReset'
/build/buildd/binutils-2.23.52.20130913/builddir-single/bfd/../../bfd/compress.c:61: undefined reference to `inflateEnd'
collect2: error: ld returned 1 exit status
make[3]: *** [perf] Error 1
make[2]: *** [all] Error 2
  test: test -x ./perf
make[1]: *** [make_static] Error 1
make: *** [build-test] Error 2
make: Leaving directory `/home/acme/git/linux/tools/perf'

real	14m52.077s
user	39m36.668s
sys	6m27.970s
acme@ubuntu13:~/git/linux$ 

