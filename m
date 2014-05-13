Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932160AbaEMWFW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 18:05:22 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:47742 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143AbaEMWFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 18:05:11 -0400
From: Alexis Berlemont <alexis.berlemont@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Alexis Berlemont <alexis.berlemont@gmail.com>, jolsa@redhat.com,
        acme@ghostprotocols.net, dsahern@gmail.com, mingo@kernel.org
Subject: [PATCH 00/34] perf and kconfig / kbuild
Date: Wed, 14 May 2014 00:02:55 +0200
Message-Id: <1400018609-20486-1-git-send-email-alexis.berlemont@gmail.com>
X-Mailer: git-send-email 1.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, 

A few months ago, I tried to make a proposal to introduce Kconfig in
perf's generation procedure.
(cf. https://lkml.org/lkml/2013/12/20/511)

I started from David Ahern's work; I was not aware that Jiri Olsa
pushed further the idea and proposed an alternative which integrated
kbuild too.

So, here is another proposal based on Jiri Olsa work (from April 2013). 
* Most of the NO_* and HAVE_* makefile variables were removed on
  behalf of Kconfig's ones (CONFIG_*); perf source code was modified
  accordingly;
* These changes make the glue files tools/perf/config/Makefile.fix-* useless
* The build test cases now relies on generated configuration files (in
  tools/perf/tests/configs); 

Hope this helps,

Alexis.

Alexis Berlemont (29):
  perf kbuild: fix recursive invocation of config/features-checks
  perf kbuild: store in config-detected missing variables (libdir, ...)
  perf kbuild: remove useless #ifdef directives
  perf kbuild: fix a link issue if BUILTIN_TRACE is disabled
  perf kbuild: add missing files and missing flags in Kbuild files
  perf kbuild: update kbuild files according to last changes
  perf kbuild: remove legacy slang-related build variables
  perf kbuild: remove legacy libaudit-related build variables
  perf kbuild: remove legacy libgtk2-related build variables
  perf kbuild: remove legacy libperl-related build variables
  perf kbuild: remove legacy timerfd-related build variable
  perf kbuild: remove legacy demangle-related build variables
  perf kbuild: remove legacy on_exit-related build variable
  perf kbuild: remove legacy backtrace-related build variable
  perf kbuild: remove legacy numa-related build variable
  perf kbuild: remove legacy bionic-related build variable
  perf kbuild: remove legacy libelf-related build variables (1st part)
  perf kbuild: remove legacy libelf-related build variables (2nd part)
  perf kbuild: remove legacy libdwarf-related build variables
  perf kbuild: remove legacy libunwind-related build variables
  perf kbuild: remove legacy libpython-related build variable
  perf kbuild: add generated Kconfig build-test cases
  perf kbuild: fix installation of traceevent plugins
  perf kbuild: fix tarpkg target in tests/make
  perf kbuild: update Kbuild files with new and removed sources
  perf kbuild: update build test configurations
  perf kbuild: relocate the configs generating script
  perf kbuild: minor changes
  perf kbuild: remove Makefile.perf

Jiri Olsa (5):
  kbuild: Introduce KBUILD_AUTOCONF variable for auto.conf include
  kbuild: Introduce KCONFIG_AUTOCONFIGDEP variable for conf tool
  perf tools: Kbuild builtin source related fixies
  perf tools: Kbuild source related fixies
  perf tools: Add kbuild support into Makefile.kbuild

 scripts/Makefile.build                             |   3 +-
 scripts/kconfig/confdata.c                         |  11 +-
 scripts/kconfig/lkc.h                              |   1 +
 tools/perf/Kbuild                                  |  47 ++
 tools/perf/Kconfig                                 | 370 ++++++++
 tools/perf/MANIFEST                                |   1 +
 tools/perf/Makefile                                |   2 +-
 tools/perf/Makefile.kbuild                         | 414 +++++++++
 tools/perf/Makefile.perf                           | 930 ---------------------
 tools/perf/arch/Kbuild                             |   3 +
 tools/perf/arch/arm/Makefile                       |   4 +-
 tools/perf/arch/powerpc/Makefile                   |   2 +-
 tools/perf/arch/s390/Makefile                      |   2 +-
 tools/perf/arch/sh/Makefile                        |   2 +-
 tools/perf/arch/sparc/Makefile                     |   2 +-
 tools/perf/arch/x86/Kbuild                         |   2 +
 tools/perf/arch/x86/Makefile                       |   8 +-
 tools/perf/arch/x86/tests/Kbuild                   |   2 +
 tools/perf/arch/x86/util/Kbuild                    |   5 +
 tools/perf/bench/Kbuild                            |  12 +
 tools/perf/builtin-annotate.c                      |   8 +-
 tools/perf/builtin-bench.c                         |   5 +-
 tools/perf/builtin-cmds.h                          |  31 +
 tools/perf/builtin-help.c                          |   1 +
 tools/perf/builtin-inject.c                        |   2 +-
 tools/perf/builtin-kvm.c                           |  32 +-
 tools/perf/builtin-lock.c                          |   4 +-
 tools/perf/builtin-mem.c                           |   3 +-
 tools/perf/builtin-probe.c                         |  15 +-
 tools/perf/builtin-record.c                        |  14 +-
 tools/perf/builtin-report.c                        |   3 +
 tools/perf/builtin-sched.c                         |   2 +
 tools/perf/builtin-script.c                        |   6 +-
 tools/perf/builtin-top.c                           |  15 +-
 tools/perf/config/Makefile                         | 397 +++++----
 tools/perf/config/defconfig                        |  54 ++
 tools/perf/perf.c                                  |  53 +-
 tools/perf/perf.h                                  |   2 +
 tools/perf/scripts/perl/Perf-Trace-Util/Kbuild     |   3 +
 tools/perf/scripts/python/Perf-Trace-Util/Kbuild   |   5 +
 tools/perf/tests/Kbuild                            |  34 +
 tools/perf/tests/builtin-test.c                    |   3 +-
 tools/perf/tests/configs/MINIMAL_config            |  60 ++
 tools/perf/tests/configs/NO_BACKTRACE_config       |  69 ++
 .../perf/tests/configs/NO_BUILTIN_ANNOTATE_config  |  69 ++
 tools/perf/tests/configs/NO_BUILTIN_BENCH_config   |  69 ++
 .../tests/configs/NO_BUILTIN_BUILDID_CACHE_config  |  69 ++
 .../tests/configs/NO_BUILTIN_BUILDID_LIST_config   |  68 ++
 tools/perf/tests/configs/NO_BUILTIN_DIFF_config    |  68 ++
 tools/perf/tests/configs/NO_BUILTIN_EVLIST_config  |  69 ++
 tools/perf/tests/configs/NO_BUILTIN_HELP_config    |  69 ++
 tools/perf/tests/configs/NO_BUILTIN_INJECT_config  |  69 ++
 tools/perf/tests/configs/NO_BUILTIN_KMEM_config    |  69 ++
 tools/perf/tests/configs/NO_BUILTIN_KVM_config     |  69 ++
 tools/perf/tests/configs/NO_BUILTIN_LIST_config    |  69 ++
 tools/perf/tests/configs/NO_BUILTIN_LOCK_config    |  69 ++
 tools/perf/tests/configs/NO_BUILTIN_MEM_config     |  69 ++
 tools/perf/tests/configs/NO_BUILTIN_PROBE_config   |  69 ++
 tools/perf/tests/configs/NO_BUILTIN_RECORD_config  |  60 ++
 tools/perf/tests/configs/NO_BUILTIN_REPORT_config  |  65 ++
 tools/perf/tests/configs/NO_BUILTIN_SCHED_config   |  69 ++
 tools/perf/tests/configs/NO_BUILTIN_SCRIPT_config  |  69 ++
 tools/perf/tests/configs/NO_BUILTIN_STAT_config    |  68 ++
 tools/perf/tests/configs/NO_BUILTIN_TEST_config    |  69 ++
 .../perf/tests/configs/NO_BUILTIN_TIMECHART_config |  69 ++
 tools/perf/tests/configs/NO_BUILTIN_TOP_config     |  68 ++
 tools/perf/tests/configs/NO_BUILTIN_TRACE_config   |  69 ++
 tools/perf/tests/configs/NO_DEMANGLE_config        |  67 ++
 tools/perf/tests/configs/NO_GTK2_config            |  69 ++
 tools/perf/tests/configs/NO_LIBAUDIT_config        |  68 ++
 tools/perf/tests/configs/NO_LIBDWARF_config        |  67 ++
 tools/perf/tests/configs/NO_LIBELF_MMAP_config     |  69 ++
 tools/perf/tests/configs/NO_LIBGTK2_INFOBAR_config |  69 ++
 tools/perf/tests/configs/NO_LIBGTK2_config         |  67 ++
 tools/perf/tests/configs/NO_LIBNUMA_config         |  69 ++
 tools/perf/tests/configs/NO_LIBPERL_config         |  69 ++
 tools/perf/tests/configs/NO_LIBPYTHON_config       |  69 ++
 tools/perf/tests/configs/NO_LIBSLANG_config        |  68 ++
 .../tests/configs/NO_LIBUNWIND_DEBUG_FRAME_config  |  69 ++
 tools/perf/tests/configs/NO_STDIO_config           |  69 ++
 tools/perf/tests/configs/NO_TIMERFD_config         |  69 ++
 tools/perf/tests/configs/NO_TUI_config             |  69 ++
 tools/perf/tests/configs/NO_UNWIND_config          |  65 ++
 tools/perf/tests/configs/REF_config                |  69 ++
 tools/perf/tests/generate_configs.py               |  33 +
 tools/perf/tests/make                              |  73 +-
 tools/perf/tests/tests.h                           |   4 +-
 tools/perf/ui/Kbuild                               |  15 +
 tools/perf/ui/browsers/Kbuild                      |   9 +
 tools/perf/ui/browsers/scripts.c                   |   4 +
 tools/perf/ui/gtk/Kbuild                           |   9 +
 tools/perf/ui/gtk/browser.c                        |   4 +-
 tools/perf/ui/gtk/gtk.h                            |   5 +-
 tools/perf/ui/gtk/util.c                           |   6 +-
 tools/perf/ui/setup.c                              |  14 +-
 tools/perf/ui/stdio/Kbuild                         |   1 +
 tools/perf/ui/tui/Kbuild                           |   4 +
 tools/perf/ui/ui.h                                 |   4 +-
 tools/perf/util/Kbuild                             | 125 +++
 tools/perf/util/PERF-VERSION-GEN                   |   4 +
 tools/perf/util/annotate.h                         |   4 +-
 tools/perf/util/generate-cmdlist.sh                |  22 +-
 tools/perf/util/hist.h                             |   4 +-
 tools/perf/util/include/dwarf-regs.h               |   4 +-
 tools/perf/util/map.c                              |   3 +-
 tools/perf/util/probe-event.c                      |   6 +-
 tools/perf/util/probe-finder.h                     |   5 +-
 tools/perf/util/scripting-engines/Kbuild           |  11 +
 tools/perf/util/setup.py                           |   8 +-
 tools/perf/util/srcline.c                          |   8 +-
 tools/perf/util/symbol-elf.c                       |   3 +-
 tools/perf/util/symbol.h                           |  33 +-
 tools/perf/util/trace-event-scripting.c            |  13 +-
 tools/perf/util/unwind-libunwind.c                 |   5 +-
 tools/perf/util/unwind.h                           |   7 +-
 tools/perf/util/util.c                             |   5 +-
 116 files changed, 4556 insertions(+), 1274 deletions(-)
 create mode 100644 tools/perf/Kbuild
 create mode 100644 tools/perf/Kconfig
 create mode 100644 tools/perf/Makefile.kbuild
 delete mode 100644 tools/perf/Makefile.perf
 create mode 100644 tools/perf/arch/Kbuild
 create mode 100644 tools/perf/arch/x86/Kbuild
 create mode 100644 tools/perf/arch/x86/tests/Kbuild
 create mode 100644 tools/perf/arch/x86/util/Kbuild
 create mode 100644 tools/perf/bench/Kbuild
 create mode 100644 tools/perf/builtin-cmds.h
 create mode 100644 tools/perf/config/defconfig
 create mode 100644 tools/perf/scripts/perl/Perf-Trace-Util/Kbuild
 create mode 100644 tools/perf/scripts/python/Perf-Trace-Util/Kbuild
 create mode 100644 tools/perf/tests/Kbuild
 create mode 100644 tools/perf/tests/configs/MINIMAL_config
 create mode 100644 tools/perf/tests/configs/NO_BACKTRACE_config
 create mode 100644 tools/perf/tests/configs/NO_BUILTIN_ANNOTATE_config
 create mode 100644 tools/perf/tests/configs/NO_BUILTIN_BENCH_config
 create mode 100644 tools/perf/tests/configs/NO_BUILTIN_BUILDID_CACHE_config
 create mode 100644 tools/perf/tests/configs/NO_BUILTIN_BUILDID_LIST_config
 create mode 100644 tools/perf/tests/configs/NO_BUILTIN_DIFF_config
 create mode 100644 tools/perf/tests/configs/NO_BUILTIN_EVLIST_config
 create mode 100644 tools/perf/tests/configs/NO_BUILTIN_HELP_config
 create mode 100644 tools/perf/tests/configs/NO_BUILTIN_INJECT_config
 create mode 100644 tools/perf/tests/configs/NO_BUILTIN_KMEM_config
 create mode 100644 tools/perf/tests/configs/NO_BUILTIN_KVM_config
 create mode 100644 tools/perf/tests/configs/NO_BUILTIN_LIST_config
 create mode 100644 tools/perf/tests/configs/NO_BUILTIN_LOCK_config
 create mode 100644 tools/perf/tests/configs/NO_BUILTIN_MEM_config
 create mode 100644 tools/perf/tests/configs/NO_BUILTIN_PROBE_config
 create mode 100644 tools/perf/tests/configs/NO_BUILTIN_RECORD_config
 create mode 100644 tools/perf/tests/configs/NO_BUILTIN_REPORT_config
 create mode 100644 tools/perf/tests/configs/NO_BUILTIN_SCHED_config
 create mode 100644 tools/perf/tests/configs/NO_BUILTIN_SCRIPT_config
 create mode 100644 tools/perf/tests/configs/NO_BUILTIN_STAT_config
 create mode 100644 tools/perf/tests/configs/NO_BUILTIN_TEST_config
 create mode 100644 tools/perf/tests/configs/NO_BUILTIN_TIMECHART_config
 create mode 100644 tools/perf/tests/configs/NO_BUILTIN_TOP_config
 create mode 100644 tools/perf/tests/configs/NO_BUILTIN_TRACE_config
 create mode 100644 tools/perf/tests/configs/NO_DEMANGLE_config
 create mode 100644 tools/perf/tests/configs/NO_GTK2_config
 create mode 100644 tools/perf/tests/configs/NO_LIBAUDIT_config
 create mode 100644 tools/perf/tests/configs/NO_LIBDWARF_config
 create mode 100644 tools/perf/tests/configs/NO_LIBELF_MMAP_config
 create mode 100644 tools/perf/tests/configs/NO_LIBGTK2_INFOBAR_config
 create mode 100644 tools/perf/tests/configs/NO_LIBGTK2_config
 create mode 100644 tools/perf/tests/configs/NO_LIBNUMA_config
 create mode 100644 tools/perf/tests/configs/NO_LIBPERL_config
 create mode 100644 tools/perf/tests/configs/NO_LIBPYTHON_config
 create mode 100644 tools/perf/tests/configs/NO_LIBSLANG_config
 create mode 100644 tools/perf/tests/configs/NO_LIBUNWIND_DEBUG_FRAME_config
 create mode 100644 tools/perf/tests/configs/NO_STDIO_config
 create mode 100644 tools/perf/tests/configs/NO_TIMERFD_config
 create mode 100644 tools/perf/tests/configs/NO_TUI_config
 create mode 100644 tools/perf/tests/configs/NO_UNWIND_config
 create mode 100644 tools/perf/tests/configs/REF_config
 create mode 100644 tools/perf/tests/generate_configs.py
 create mode 100644 tools/perf/ui/Kbuild
 create mode 100644 tools/perf/ui/browsers/Kbuild
 create mode 100644 tools/perf/ui/gtk/Kbuild
 create mode 100644 tools/perf/ui/stdio/Kbuild
 create mode 100644 tools/perf/ui/tui/Kbuild
 create mode 100644 tools/perf/util/Kbuild
 create mode 100644 tools/perf/util/scripting-engines/Kbuild

-- 
1.9.2

