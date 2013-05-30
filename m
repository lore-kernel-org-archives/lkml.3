Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935407Ab3E3QHd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 12:07:33 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51113 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934790Ab3E3QCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 12:02:34 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Andi Kleen <andi@firstfloor.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Borislav Petkov <bp@alien8.de>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        linuxppc-dev@ozlabs.org, Michael Ellerman <michael@ellerman.id.au>,
        Mike Galbraith <efault@gmx.de>, Minchan Kim <minchan@kernel.org>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Rabin Vincent <rabin@rab.in>,
        Runzhen Wang <runzhen@linux.vnet.ibm.com>,
        Sam Ravnborg <sam@ravnborg.org>, Stephane Eranian <eranian@google.com>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        William Cohen <wcohen@redhat.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 00/66] perf/core improvements and fixes
Date: Thu, 30 May 2013 19:00:33 +0300
Message-Id: <1369929699-8724-1-git-send-email-acme@infradead.org>
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

The following changes since commit c0ffaf3655fab1909a920c8f30ba1722932d01bb:

  watchdog: Remove softlockup_thresh from Documentation (2013-05-28 11:28:20 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-core-for-mingo

for you to fetch changes up to c3c44709b5095091216c06b8df83feddc01ba6b0:

  perf tools: Add missing liblk.a dependency for python/perf.so (2013-05-30 17:36:16 +0300)

----------------------------------------------------------------
perf/core improvements and fixes:

. Reset SIGTERM handler in workload child process, fix from David Ahern.

. Handle death by SIGTERM in 'perf record', fix from David Ahern.

. Fix printing of perf_event_paranoid message, from David Ahern.

. Handle realloc failures in 'perf kvm', from David Ahern.

. Fix divide by 0 in variance, from David Ahern.

. Save parent pid in thread struct, from David Ahern.

. Handle JITed code in shared memory, from Andi Kleen.

. Makefile reorganization, prep work for Kconfig patches, from Jiri Olsa.

. Fixes for 'perf diff', from Jiri Olsa.

. Add automated make test suite, from Jiri Olsa.

. 'perf tests' fixes from Jiri Olsa.

. Remove some unused struct members, from Jiri Olsa.

. Add missing liblk.a dependency for python/perf.so, fix from Jiri Olsa.

. Respect CROSS_COMPILE in liblk.a, from Rabin Vincent.

. Expand definition of sysfs format attribute, from Michael Ellerman.

. No need to do locking when adding hists in perf report, only 'top'
  needs that, from Namhyung Kim.

. Sorting improvements, from Namhyung Kim.

. Fix alignment of symbol column in in the hists browser (top, report)
  when -v is given, from NAmhyung Kim.

. Add --percent-limit option to 'top' and 'report', from Namhyung Kim.

. Fix 'perf top' -E option behavior, from Namhyung Kim.

. Fix bug in isupper() and islower(), from Sukadev Bhattiprolu.

. Fix compile errors in bp_signal 'perf test', from Sukadev Bhattiprolu.

. Make Power7 CPI stack events available in sysfs, from Sukadev Bhattiprolu.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Andi Kleen (1):
      perf tools: Handle JITed code in shared memory

Arnaldo Carvalho de Melo (3):
      perf archive: Fix typo on Documentation
      perf hists browser: Use sort__has_sym
      perf test: Fix typo

David Ahern (6):
      perf record: handle death by SIGTERM
      perf evsel: Fix printing of perf_event_paranoid message
      perf kvm: Handle realloc failures
      perf stats: Fix divide by 0 in variance
      perf  tools: Save parent pid in thread struct
      perf evlist: Reset SIGTERM handler in workload child process

Jiri Olsa (32):
      perf tools: Fix tab vs spaces issue in Makefile ifdef/endif
      perf diff: Use internal rb tree for hists__precompute
      perf hists: Rename hist_entry__add_pair arguments
      perf tools: Add automated make test suite
      perf tools: Move arch check into config/Makefile
      perf tools: Move programs check into config/Makefile
      perf tools: Move compiler and linker flags check into config/Makefile
      perf tools: Move libelf check config into config/Makefile
      perf tools: Move libdw check config into config/Makefile
      perf tools: Move libunwind check config into config/Makefile
      perf tools: Move libaudit check config into config/Makefile
      perf tools: Move slang check config into config/Makefile
      perf tools: Move gtk2 check config into config/Makefile
      perf tools: Move libperl check config into config/Makefile
      perf tools: Move libpython check config into config/Makefile
      perf tools: Move libbfd check config into config/Makefile
      perf tools: Move stdlib check config into config/Makefile
      perf tools: Move libnuma check config into config/Makefile
      perf tools: Move paths config into config/Makefile
      perf tools: Final touches for CHK config move
      perf tests: Fix attr test for record -d option
      perf tests: Fix exclude_guest|exclude_host checking for attr tests
      perf tools: Remove frozen from perf_header struct
      perf tools: Remove cwdlen from struct perf_session
      perf tools: Merge all *CFLAGS* make variable into CFLAGS
      perf tools: Merge all *LDFLAGS* make variable into LDFLAGS
      perf tools: Switch to full path C include directories
      perf tools: Add NO_BIONIC variable to confiure bionic setup
      perf tools: Replace tabs with spaces for all non-commands statements
      perf tools: Replace multiple line assignment with multiple statements
      perf tools: Remove '?=' Makefile STRIP assignment
      perf tools: Add missing liblk.a dependency for python/perf.so

Michael Ellerman (1):
      perf: Expand definition of sysfs format attribute

Namhyung Kim (18):
      perf hists: Fix an invalid memory free on he->branch_info
      perf hists: Free unused mem info of a matched hist entry
      perf report: Fix alignment of symbol column when -v is given
      perf sort: Introduce sort__mode variable
      perf sort: Factor out common code in sort_dimension__add()
      perf sort: Separate out memory-specific sort keys
      perf sort: Consolidate sort_entry__setup_elide()
      perf sort: Reorder HISTC_SRCLINE index
      perf sort: Cleanup sort__has_sym setting
      perf top: Use sort__has_sym
      perf top: Fix -E option behavior
      perf top: Fix percent output when no samples collected
      perf top: Get rid of *_threaded() functions
      perf hists: Move locking to its call-sites
      perf report: Don't bother locking when adding hist entries
      perf report: Add --percent-limit option
      perf top: Add --percent-limit option
      perf report: Add report.percent-limit config variable

Rabin Vincent (1):
      tools lib lk: Respect CROSS_COMPILE

Sukadev Bhattiprolu (4):
      perf tools: Fix bug in isupper() and islower()
      perf tests: Fix compile errors in bp_signal files
      perf: Power7: Make CPI stack events available in sysfs
      perf: Power7 Update testing ABI to list CPI-stack events

 .../testing/sysfs-bus-event_source-devices-events  |  32 +-
 .../testing/sysfs-bus-event_source-devices-format  |   6 +
 arch/powerpc/perf/power7-pmu.c                     |  73 +++
 tools/lib/lk/Makefile                              |   3 +
 tools/perf/Documentation/perf-archive.txt          |   2 +-
 tools/perf/Documentation/perf-report.txt           |   4 +
 tools/perf/Documentation/perf-top.txt              |   4 +
 tools/perf/Makefile                                | 630 ++++-----------------
 tools/perf/builtin-diff.c                          |  19 +-
 tools/perf/builtin-kvm.c                           |   3 +
 tools/perf/builtin-record.c                        |   2 +-
 tools/perf/builtin-report.c                        | 102 ++--
 tools/perf/builtin-top.c                           |  74 +--
 tools/perf/config/Makefile                         | 477 ++++++++++++++++
 tools/perf/tests/attr/base-record                  |   4 +-
 tools/perf/tests/attr/base-stat                    |   4 +-
 tools/perf/tests/attr/test-record-data             |   5 +-
 tools/perf/tests/bp_signal.c                       |   6 +
 tools/perf/tests/bp_signal_overflow.c              |   6 +
 tools/perf/tests/builtin-test.c                    |   2 +-
 tools/perf/tests/make                              | 138 +++++
 tools/perf/ui/browsers/hists.c                     | 106 +++-
 tools/perf/ui/gtk/hists.c                          |  13 +-
 tools/perf/ui/stdio/hist.c                         |   7 +-
 tools/perf/util/evlist.c                           |   2 +
 tools/perf/util/evsel.c                            |   2 +-
 tools/perf/util/header.c                           |   2 -
 tools/perf/util/header.h                           |   1 -
 tools/perf/util/hist.c                             |  96 ++--
 tools/perf/util/hist.h                             |  16 +-
 tools/perf/util/map.c                              |   1 +
 tools/perf/util/session.h                          |   1 -
 tools/perf/util/setup.py                           |   5 +-
 tools/perf/util/sort.c                             | 128 +++--
 tools/perf/util/sort.h                             |  36 +-
 tools/perf/util/stat.c                             |   2 +-
 tools/perf/util/thread.c                           |   4 +
 tools/perf/util/thread.h                           |   1 +
 tools/perf/util/top.c                              |  23 +-
 tools/perf/util/top.h                              |   2 +-
 tools/perf/util/util.h                             |   4 +-
 41 files changed, 1270 insertions(+), 778 deletions(-)
 create mode 100644 tools/perf/config/Makefile
 create mode 100644 tools/perf/tests/make
