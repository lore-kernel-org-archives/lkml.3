Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755105Ab3JHKMJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 06:12:09 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:53953 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869Ab3JHKMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 06:12:05 -0400
From: Ingo Molnar <mingo@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH -v2 00/52] tools/perf: Speed up the build system
Date: Tue,  8 Oct 2013 12:10:30 +0200
Message-Id: <1381227082-22039-1-git-send-email-mingo@kernel.org>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

About the purpose of this series, see the previous announcement at:

   https://lkml.org/lkml/2013/10/7/199

This -v2 series addresses the review feedback from David Ahern and
Jiri Olsa (thanks guys!).

If everything is fine with this series then I'll ask Arnaldo to pull
the changes.

The changes can also be fetched from this tree:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git tmp.perf

   (HEAD: c31cfd5dc9c3)

Thanks,

	Ingo

================>
Ingo Molnar (52):
  tools/perf: Standardize feature support define names to:
    HAVE_{FEATURE}_SUPPORT
  tools/perf/build: Add feature check core code
  tools/perf/build: Add 'autodep' functionality, generate feature test
    dependencies automatically
  tools/perf/build: Split out feature check: 'libnuma'
  tools/perf/build: Split out feature check: 'stackprotector-all'
  tools/perf/build: Split out feature check: 'stackprotector'
  tools/perf/build: Split out feature check: 'volatile-register-var'
  tools/perf/build: Split out feature check: 'fortify-source'
  tools/perf/build: Split out feature check: 'bionic'
  tools/perf/build: Clean up the libelf logic in config/Makefile
  tools/perf/build: Split out feature check: 'libelf'
  tools/perf/build: Split out feature check: 'glibc'
  tools/perf/build: Split out feature check: 'dwarf'
  tools/perf/build: Clean up the mmap logic in config/Makefile
  tools/perf/build: Split out feature check: 'libelf-mmap'
  tools/perf/build: Split out feature check: 'libelf-getphdrnum'
  tools/perf/build: Clean up the libunwind logic in config/Makefile
  tools/perf/build: Split out feature check: 'libunwind'
  tools/perf/build: Split out feature check: 'libaudit'
  tools/perf/build: Split out feature check: 'libslang'
  tools/perf/build: Split out feature check: 'gtk2'
  tools/perf/build: Split out feature check: 'gtk2-infobar'
  tools/perf/build: Split out feature check: 'libperl'
  tools/perf/build: Split out feature check: 'libpython'
  tools/perf/build: Split out feature check: 'libpython-version'
  tools/perf/build: Split out feature check: 'libbfd'
  tools/perf/build: Split out feature check: 'strlcpy'
  tools/perf/build: Split out feature check: 'on-exit'
  tools/perf/build: Split out feature check: 'backtrace'
  tools/perf: Clean up util/include/linux/compiler.h
  tools/perf: Turn strlcpy() into a __weak function
  tools/perf/build: Speed up auto-detection of features by adding a
    'test-all' target
  tools/perf/build: Speed up git-version test on re-make
  tools/perf/build: Speed up the final link
  tools/perf: Fix double/triple-build of the feature detection logic
    during 'make install' et al
  tools/perf/build: Invoke feature-checks 'clean' target from the main
    Makefile
  tools/perf/build: Speed up auto-detection
  tools/perf/build: Improve printout-of auto-detected features
  tools/perf/build: Automatically build in parallel, based on number of
    CPUs in the system
  tools/perf/build: Flip Makefile.parallel and Makefile.perf
  tools/perf/build: Standardize the various messages output by parallel
    make
  tools/perf/build: Split out feature checks: 'liberty', 'liberty-z',
    'cplus-demangle'
  tools/perf/build: Remove unused config/feature-tests.mak
  tools/perf/build: Clean up various testcases
  tools/perf/build: Collapse the test-all.c testcase
  tools/perf/build: Pass through all targets to Makefile.perf
  tools/perf/build: Make sure autodep feature binaries honor the O=
    setting
  tools/perf/build: Exclude MAKEFLAGS from nested invocation
  tools/perf/build: Fix non-canonical directory names in O=
  tools/perf/build: Fix O=/some/dir perf.o type of targets
  tools/perf/build: Harmonize the style of the feature testcases
  tools/perf/build: Pass through LDFLAGS to feature tests

 tools/perf/Documentation/Makefile                             |  17 +-
 tools/perf/Makefile                                           | 841 ++---------------------------
 tools/perf/Makefile.perf                                      | 856 ++++++++++++++++++++++++++++++
 tools/perf/arch/x86/include/perf_regs.h                       |   6 +-
 tools/perf/arch/x86/util/unwind.c                             |   4 +-
 tools/perf/bench/mem-memcpy-arch.h                            |   2 +-
 tools/perf/bench/mem-memcpy.c                                 |   2 +-
 tools/perf/bench/mem-memset-arch.h                            |   2 +-
 tools/perf/bench/mem-memset.c                                 |   2 +-
 tools/perf/builtin-bench.c                                    |   4 +-
 tools/perf/builtin-inject.c                                   |   2 +-
 tools/perf/builtin-probe.c                                    |  14 +-
 tools/perf/builtin-record.c                                   |  12 +-
 tools/perf/config/Makefile                                    | 327 +++++++-----
 tools/perf/config/feature-checks/Makefile                     | 148 ++++++
 tools/perf/config/feature-checks/test-all.c                   | 106 ++++
 tools/perf/config/feature-checks/test-backtrace.c             |  13 +
 tools/perf/config/feature-checks/test-bionic.c                |   6 +
 tools/perf/config/feature-checks/test-cplus-demangle.c        |  14 +
 tools/perf/config/feature-checks/test-dwarf.c                 |  10 +
 tools/perf/config/feature-checks/test-fortify-source.c        |   6 +
 tools/perf/config/feature-checks/test-glibc.c                 |   8 +
 tools/perf/config/feature-checks/test-gtk2-infobar.c          |  11 +
 tools/perf/config/feature-checks/test-gtk2.c                  |  10 +
 tools/perf/config/feature-checks/test-hello.c                 |   6 +
 tools/perf/config/feature-checks/test-libaudit.c              |  10 +
 tools/perf/config/feature-checks/test-libbfd.c                |  15 +
 tools/perf/config/feature-checks/test-libelf-getphdrnum.c     |   8 +
 tools/perf/config/feature-checks/test-libelf-mmap.c           |   8 +
 tools/perf/config/feature-checks/test-libelf.c                |   8 +
 tools/perf/config/feature-checks/test-libnuma.c               |   9 +
 tools/perf/config/feature-checks/test-libperl.c               |   9 +
 tools/perf/config/feature-checks/test-libpython-version.c     |  10 +
 tools/perf/config/feature-checks/test-libpython.c             |   8 +
 tools/perf/config/feature-checks/test-libslang.c              |   6 +
 tools/perf/config/feature-checks/test-libunwind.c             |  27 +
 tools/perf/config/feature-checks/test-on-exit.c               |  15 +
 tools/perf/config/feature-checks/test-stackprotector-all.c    |   6 +
 tools/perf/config/feature-checks/test-stackprotector.c        |   6 +
 tools/perf/config/feature-checks/test-volatile-register-var.c |   6 +
 tools/perf/config/feature-tests.mak                           | 246 ---------
 tools/perf/config/utilities.mak                               |  14 -
 tools/perf/perf.c                                             |   4 +-
 tools/perf/ui/gtk/browser.c                                   |   2 +-
 tools/perf/ui/gtk/gtk.h                                       |   4 +-
 tools/perf/ui/gtk/util.c                                      |   4 +-
 tools/perf/ui/ui.h                                            |   4 +-
 tools/perf/util/annotate.h                                    |   4 +-
 tools/perf/util/cache.h                                       |   3 +-
 tools/perf/util/generate-cmdlist.sh                           |   4 +-
 tools/perf/util/hist.h                                        |   4 +-
 tools/perf/util/include/dwarf-regs.h                          |   2 +-
 tools/perf/util/include/linux/compiler.h                      |  19 +-
 tools/perf/util/map.c                                         |   2 +-
 tools/perf/util/path.c                                        |  10 +-
 tools/perf/util/perf_regs.h                                   |   4 +-
 tools/perf/util/probe-event.c                                 |   4 +-
 tools/perf/util/probe-finder.h                                |   4 +-
 tools/perf/util/symbol-elf.c                                  |   2 +-
 tools/perf/util/symbol.h                                      |   8 +-
 tools/perf/util/unwind.h                                      |   4 +-
 tools/perf/util/util.c                                        |   4 +-
 62 files changed, 1678 insertions(+), 1258 deletions(-)
 create mode 100644 tools/perf/Makefile.perf
 create mode 100644 tools/perf/config/feature-checks/Makefile
 create mode 100644 tools/perf/config/feature-checks/test-all.c
 create mode 100644 tools/perf/config/feature-checks/test-backtrace.c
 create mode 100644 tools/perf/config/feature-checks/test-bionic.c
 create mode 100644 tools/perf/config/feature-checks/test-cplus-demangle.c
 create mode 100644 tools/perf/config/feature-checks/test-dwarf.c
 create mode 100644 tools/perf/config/feature-checks/test-fortify-source.c
 create mode 100644 tools/perf/config/feature-checks/test-glibc.c
 create mode 100644 tools/perf/config/feature-checks/test-gtk2-infobar.c
 create mode 100644 tools/perf/config/feature-checks/test-gtk2.c
 create mode 100644 tools/perf/config/feature-checks/test-hello.c
 create mode 100644 tools/perf/config/feature-checks/test-libaudit.c
 create mode 100644 tools/perf/config/feature-checks/test-libbfd.c
 create mode 100644 tools/perf/config/feature-checks/test-libelf-getphdrnum.c
 create mode 100644 tools/perf/config/feature-checks/test-libelf-mmap.c
 create mode 100644 tools/perf/config/feature-checks/test-libelf.c
 create mode 100644 tools/perf/config/feature-checks/test-libnuma.c
 create mode 100644 tools/perf/config/feature-checks/test-libperl.c
 create mode 100644 tools/perf/config/feature-checks/test-libpython-version.c
 create mode 100644 tools/perf/config/feature-checks/test-libpython.c
 create mode 100644 tools/perf/config/feature-checks/test-libslang.c
 create mode 100644 tools/perf/config/feature-checks/test-libunwind.c
 create mode 100644 tools/perf/config/feature-checks/test-on-exit.c
 create mode 100644 tools/perf/config/feature-checks/test-stackprotector-all.c
 create mode 100644 tools/perf/config/feature-checks/test-stackprotector.c
 create mode 100644 tools/perf/config/feature-checks/test-volatile-register-var.c
 delete mode 100644 tools/perf/config/feature-tests.mak

-- 
1.8.3.1

