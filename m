Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729AbaJWWaq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 18:30:46 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:57961 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102AbaJWWap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 18:30:45 -0400
From: Alexis Berlemont <alexis.berlemont@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Alexis Berlemont <alexis.berlemont@gmail.com>, jolsa@redhat.com,
        dsahern@gmail.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        paulus@samba.org, acme@kernel.org, namhyung@kernel.org, mmarek@suse.cz
Subject: [PATCH v3 00/14] Kbuild for perf
Date: Fri, 24 Oct 2014 00:28:08 +0200
Message-Id: <1414103302-14906-1-git-send-email-alexis.berlemont@gmail.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1414101372-14443-1-git-send-email-alexis.berlemont@gmail.com>
References: <1414101372-14443-1-git-send-email-alexis.berlemont@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Here is a proposal of perf's build process managed by Kbuild:
* The file Makefile.perf is replaced by Makefile.kbuild
* Makefile.kbuild generates a default .config file if none exists
  (allyesconfig)
* Makefile.kbuild adapts the .config file according to the
  features-check tests results
* Makefile.kbuild builds external dependencies (linux/tools/lib/*)
* Makefile.kbuild leaves the rest to Kbuild 

Regards,

Alexis.

Alexis Berlemont (11):
  kbuild: add support of custom paths for "auto.conf*" files
  perf kbuild: remove Makefile.perf
  perf kbuild: remove legacy tui/gui-related build variables
  perf kbuild: remove legacy demangle-related build variables
  perf kbuild: cross-compilation variables are now handled in Kconfig
  perf kbuild: remove legacy misc build variables
  perf kbuild: remove legacy libelf-related build variables
  perf kbuild: remove legacy libdwarf-related build variables
  perf kbuild: remove legacy script-related build variables
  perf kbuild: final cosmetic changes
  perf kbuild: add generated Kconfig build-test cases

Jiri Olsa (3):
  perf tools: Kbuild builtin source related fixies
  perf tools: Kbuild source related fixies
  perf tools: Add kbuild support into Makefile.kbuild

 scripts/Makefile.build                             |   3 +-
 scripts/kconfig/confdata.c                         |  23 +-
 scripts/kconfig/lkc.h                              |   1 +
 tools/perf/Kbuild                                  |  47 +
 tools/perf/Kconfig                                 | 436 ++++++++++
 tools/perf/MANIFEST                                |   1 +
 tools/perf/Makefile                                |   2 +-
 tools/perf/Makefile.kbuild                         | 443 ++++++++++
 tools/perf/Makefile.perf                           | 949 ---------------------
 tools/perf/arch/Kbuild                             |   3 +
 tools/perf/arch/arm/Kbuild                         |   2 +
 tools/perf/arch/arm/Makefile                       |  14 -
 tools/perf/arch/arm/tests/Kbuild                   |   2 +
 tools/perf/arch/arm/util/Kbuild                    |   3 +
 tools/perf/arch/arm64/Kbuild                       |   1 +
 tools/perf/arch/arm64/Makefile                     |   7 -
 tools/perf/arch/arm64/util/Kbuild                  |   2 +
 tools/perf/arch/powerpc/Kbuild                     |   1 +
 tools/perf/arch/powerpc/Makefile                   |   6 -
 tools/perf/arch/powerpc/util/Kbuild                |   3 +
 tools/perf/arch/s390/Kbuild                        |   1 +
 tools/perf/arch/s390/Makefile                      |   7 -
 tools/perf/arch/s390/util/Kbuild                   |   2 +
 tools/perf/arch/sh/Kbuild                          |   1 +
 tools/perf/arch/sh/Makefile                        |   4 -
 tools/perf/arch/sh/util/Kbuild                     |   1 +
 tools/perf/arch/sparc/Kbuild                       |   1 +
 tools/perf/arch/sparc/Makefile                     |   4 -
 tools/perf/arch/sparc/util/Kbuild                  |   1 +
 tools/perf/arch/x86/Kbuild                         |   2 +
 tools/perf/arch/x86/Makefile                       |  19 -
 tools/perf/arch/x86/include/perf_regs.h            |   8 +-
 tools/perf/arch/x86/tests/Kbuild                   |   3 +
 tools/perf/{ => arch/x86}/tests/perf-time-to-tsc.c |   2 +-
 tools/perf/arch/x86/tests/regs_load.S              |   3 +-
 tools/perf/arch/x86/util/Kbuild                    |   6 +
 tools/perf/arch/x86/util/unwind-libunwind.c        |   5 +-
 tools/perf/bench/Kbuild                            |  12 +
 tools/perf/bench/mem-memcpy-arch.h                 |   4 +-
 tools/perf/bench/mem-memcpy.c                      |   4 +-
 tools/perf/bench/mem-memset-arch.h                 |   4 +-
 tools/perf/bench/mem-memset.c                      |   4 +-
 tools/perf/builtin-annotate.c                      |   8 +-
 tools/perf/builtin-bench.c                         |   5 +-
 tools/perf/builtin-help.c                          |   1 +
 tools/perf/builtin-inject.c                        |   2 +-
 tools/perf/builtin-kvm.c                           |  38 +-
 tools/perf/builtin-lock.c                          |   5 +-
 tools/perf/builtin-probe.c                         |  15 +-
 tools/perf/builtin-record.c                        |   4 +-
 tools/perf/builtin-report.c                        |   3 +
 tools/perf/builtin-sched.c                         |   3 +
 tools/perf/builtin-script.c                        |   6 +-
 tools/perf/builtin-top.c                           |  19 +-
 tools/perf/config/Makefile                         | 430 +++++-----
 tools/perf/config/defconfig                        |  54 ++
 tools/perf/perf-sys.h                              |   4 +-
 tools/perf/perf.c                                  |  53 +-
 tools/perf/scripts/perl/Perf-Trace-Util/Kbuild     |   6 +
 tools/perf/scripts/python/Perf-Trace-Util/Kbuild   |   5 +
 tools/perf/tests/Kbuild                            |  40 +
 tools/perf/tests/builtin-test.c                    |   3 +-
 tools/perf/tests/configs/MINIMAL_config            |  60 ++
 tools/perf/tests/configs/NO_BACKTRACE_config       |  73 ++
 .../perf/tests/configs/NO_BUILTIN_ANNOTATE_config  |  73 ++
 tools/perf/tests/configs/NO_BUILTIN_BENCH_config   |  73 ++
 .../tests/configs/NO_BUILTIN_BUILDID_CACHE_config  |  73 ++
 .../tests/configs/NO_BUILTIN_BUILDID_LIST_config   |  71 ++
 tools/perf/tests/configs/NO_BUILTIN_DIFF_config    |  71 ++
 tools/perf/tests/configs/NO_BUILTIN_EVLIST_config  |  73 ++
 tools/perf/tests/configs/NO_BUILTIN_HELP_config    |  73 ++
 tools/perf/tests/configs/NO_BUILTIN_INJECT_config  |  73 ++
 tools/perf/tests/configs/NO_BUILTIN_KMEM_config    |  73 ++
 .../perf/tests/configs/NO_BUILTIN_KVM_STAT_config  |  73 ++
 tools/perf/tests/configs/NO_BUILTIN_KVM_config     |  72 ++
 tools/perf/tests/configs/NO_BUILTIN_LIST_config    |  73 ++
 tools/perf/tests/configs/NO_BUILTIN_LOCK_config    |  73 ++
 tools/perf/tests/configs/NO_BUILTIN_MEM_config     |  73 ++
 tools/perf/tests/configs/NO_BUILTIN_PROBE_config   |  73 ++
 tools/perf/tests/configs/NO_BUILTIN_RECORD_config  |  63 ++
 tools/perf/tests/configs/NO_BUILTIN_REPORT_config  |  68 ++
 tools/perf/tests/configs/NO_BUILTIN_SCHED_config   |  73 ++
 tools/perf/tests/configs/NO_BUILTIN_SCRIPT_config  |  73 ++
 tools/perf/tests/configs/NO_BUILTIN_STAT_config    |  71 ++
 tools/perf/tests/configs/NO_BUILTIN_TEST_config    |  73 ++
 .../perf/tests/configs/NO_BUILTIN_TIMECHART_config |  73 ++
 tools/perf/tests/configs/NO_BUILTIN_TOP_config     |  71 ++
 tools/perf/tests/configs/NO_BUILTIN_TRACE_config   |  73 ++
 tools/perf/tests/configs/NO_DEMANGLE_config        |  71 ++
 tools/perf/tests/configs/NO_GTK2_config            |  73 ++
 tools/perf/tests/configs/NO_LIBAUDIT_config        |  72 ++
 tools/perf/tests/configs/NO_LIBDWARF_config        |  71 ++
 tools/perf/tests/configs/NO_LIBELF_MMAP_config     |  73 ++
 tools/perf/tests/configs/NO_LIBGTK2_INFOBAR_config |  73 ++
 tools/perf/tests/configs/NO_LIBGTK2_config         |  71 ++
 tools/perf/tests/configs/NO_LIBNUMA_config         |  73 ++
 tools/perf/tests/configs/NO_LIBPERL_config         |  73 ++
 tools/perf/tests/configs/NO_LIBPYTHON_config       |  73 ++
 tools/perf/tests/configs/NO_LIBSLANG_config        |  72 ++
 .../tests/configs/NO_LIBUNWIND_DEBUG_FRAME_config  |  73 ++
 tools/perf/tests/configs/NO_PERF_REGS_config       |  73 ++
 tools/perf/tests/configs/NO_STDIO_config           |  73 ++
 tools/perf/tests/configs/NO_TIMERFD_config         |  73 ++
 tools/perf/tests/configs/NO_TUI_config             |  73 ++
 tools/perf/tests/configs/NO_UNWIND_config          |  69 ++
 tools/perf/tests/configs/REF_config                |  73 ++
 tools/perf/tests/generate_configs.py               |  43 +
 tools/perf/tests/make                              |  70 +-
 tools/perf/tests/tests.h                           |   6 +-
 tools/perf/ui/Kbuild                               |  15 +
 tools/perf/ui/browsers/Kbuild                      |   9 +
 tools/perf/ui/browsers/scripts.c                   |   4 +
 tools/perf/ui/gtk/Kbuild                           |   9 +
 tools/perf/ui/gtk/browser.c                        |   4 +-
 tools/perf/ui/gtk/gtk.h                            |   5 +-
 tools/perf/ui/gtk/util.c                           |   6 +-
 tools/perf/ui/setup.c                              |  12 +-
 tools/perf/ui/stdio/Kbuild                         |   1 +
 tools/perf/ui/tui/Kbuild                           |   4 +
 tools/perf/ui/ui.h                                 |   4 +-
 tools/perf/util/Kbuild                             | 128 +++
 tools/perf/util/PERF-VERSION-GEN                   |   4 +
 tools/perf/util/annotate.h                         |   4 +-
 tools/perf/util/callchain.c                        |  11 +-
 tools/perf/util/callchain.h                        |   3 +-
 tools/perf/util/generate-cmdlist.sh                |  22 +-
 tools/perf/util/hist.h                             |   3 +-
 tools/perf/util/include/dwarf-regs.h               |   4 +-
 tools/perf/util/machine.c                          |   3 +-
 tools/perf/util/map.c                              |   3 +-
 tools/perf/util/perf_regs.c                        |   1 +
 tools/perf/util/perf_regs.h                        |   6 +-
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
 143 files changed, 4992 insertions(+), 1410 deletions(-)
 create mode 100644 tools/perf/Kbuild
 create mode 100644 tools/perf/Kconfig
 create mode 100644 tools/perf/Makefile.kbuild
 delete mode 100644 tools/perf/Makefile.perf
 create mode 100644 tools/perf/arch/Kbuild
 create mode 100644 tools/perf/arch/arm/Kbuild
 delete mode 100644 tools/perf/arch/arm/Makefile
 create mode 100644 tools/perf/arch/arm/tests/Kbuild
 create mode 100644 tools/perf/arch/arm/util/Kbuild
 create mode 100644 tools/perf/arch/arm64/Kbuild
 delete mode 100644 tools/perf/arch/arm64/Makefile
 create mode 100644 tools/perf/arch/arm64/util/Kbuild
 create mode 100644 tools/perf/arch/powerpc/Kbuild
 delete mode 100644 tools/perf/arch/powerpc/Makefile
 create mode 100644 tools/perf/arch/powerpc/util/Kbuild
 create mode 100644 tools/perf/arch/s390/Kbuild
 delete mode 100644 tools/perf/arch/s390/Makefile
 create mode 100644 tools/perf/arch/s390/util/Kbuild
 create mode 100644 tools/perf/arch/sh/Kbuild
 delete mode 100644 tools/perf/arch/sh/Makefile
 create mode 100644 tools/perf/arch/sh/util/Kbuild
 create mode 100644 tools/perf/arch/sparc/Kbuild
 delete mode 100644 tools/perf/arch/sparc/Makefile
 create mode 100644 tools/perf/arch/sparc/util/Kbuild
 create mode 100644 tools/perf/arch/x86/Kbuild
 delete mode 100644 tools/perf/arch/x86/Makefile
 create mode 100644 tools/perf/arch/x86/tests/Kbuild
 rename tools/perf/{ => arch/x86}/tests/perf-time-to-tsc.c (99%)
 create mode 100644 tools/perf/arch/x86/util/Kbuild
 create mode 100644 tools/perf/bench/Kbuild
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
 create mode 100644 tools/perf/tests/configs/NO_BUILTIN_KVM_STAT_config
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
 create mode 100644 tools/perf/tests/configs/NO_PERF_REGS_config
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

Changes since v2:
 * All the CCs addresses were missing

2.1.1

