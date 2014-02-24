Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508AbaBXT6I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 14:58:08 -0500
Received: from merlin.infradead.org ([205.233.59.134]:49161 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753352AbaBXT4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 14:56:55 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jean Pihet <jean.pihet@linaro.org>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 00/12] perf/core improvements and fixes
Date: Mon, 24 Feb 2014 16:56:28 -0300
Message-Id: <1393271800-17505-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>

Hi Ingo,

	Please consider pulling,

- Arnaldo

The following changes since commit 7e74efcf76c16f851df5c838c143c4a1865ea9fa:

  Merge tag 'perf-core-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/core (2014-02-22 17:26:24 +0100)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-core-for-mingo

for you to fetch changes up to 1029f9fedf87fa6f52096991588fa54ffd159584:

  perf symbols: Check compatible symtab type before loading dso (2014-02-24 16:25:01 -0300)

----------------------------------------------------------------
perf/core improvements and fixes

. Add support for the new DWARF unwinder library in elfutils (Jiri Olsa)

. Fix build race in the generation of bison files (Jiri Olsa)

. Further streamline the feature detection display, trimming it a bit to
  show just the libraries detected, using VF=1 gets a more verbose output,
  showing the less interesting feature checks as well (Jiri Olsa).

. Check compatible symtab type before loading dso (Namhyung Kim)

. Check return value of filename__read_debuglink() (Stephane Eranian)

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Arnaldo Carvalho de Melo (1):
      perf tools: Warn the user about how to enable libunwind support

Jiri Olsa (9):
      perf tests: Fix *.o make tests
      perf tests: Add pmu-bison.o make test
      perf tools: Fix bison OUTPUT directories dependency
      perf tools: Factor features display code
      perf tools: Add variable display for VF make output
      perf tools: Add feature check for libdw dwarf unwind
      perf tools: Add libdw DWARF post unwind support
      perf tools: Setup default dwarf post unwinder
      perf tests: Add NO_LIBDW_DWARF_UNWIND make test

Namhyung Kim (1):
      perf symbols: Check compatible symtab type before loading dso

Stephane Eranian (1):
      perf symbols: Check return value of filename__read_debuglink()

 tools/perf/Makefile.perf                           |  24 ++-
 tools/perf/arch/x86/Makefile                       |   5 +
 tools/perf/arch/x86/util/unwind-libdw.c            |  51 +++++
 tools/perf/config/Makefile                         | 232 +++++++++++++++------
 tools/perf/config/feature-checks/Makefile          |   6 +-
 tools/perf/config/feature-checks/test-all.c        |   5 +
 .../feature-checks/test-libdw-dwarf-unwind.c       |  13 ++
 tools/perf/tests/make                              |  25 ++-
 tools/perf/util/dso.c                              |   4 +-
 tools/perf/util/symbol-elf.c                       |   2 +
 tools/perf/util/symbol.c                           |  61 +++++-
 tools/perf/util/unwind-libdw.c                     | 210 +++++++++++++++++++
 tools/perf/util/unwind-libdw.h                     |  21 ++
 13 files changed, 569 insertions(+), 90 deletions(-)
 create mode 100644 tools/perf/arch/x86/util/unwind-libdw.c
 create mode 100644 tools/perf/config/feature-checks/test-libdw-dwarf-unwind.c
 create mode 100644 tools/perf/util/unwind-libdw.c
 create mode 100644 tools/perf/util/unwind-libdw.h
