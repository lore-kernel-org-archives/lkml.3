Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498AbaAMUsi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 15:48:38 -0500
Received: from merlin.infradead.org ([205.233.59.134]:40491 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435AbaAMUsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 15:48:22 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>, Borislav Petkov <bp@suse.de>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jean Pihet <jean.pihet@linaro.org>, Jiri Olsa <jolsa@redhat.com>,
        linaro-kernel@lists.linaro.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung.kim@lge.com>,
        patches@linaro.org, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ramkumar Ramachandra <artagnon@gmail.com>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Will Deacon <will.deacon@arm.com>,
        Yann Droneaud <ydroneaud@opteya.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 00/38] perf/core improvements and fixes
Date: Mon, 13 Jan 2014 17:47:01 -0300
Message-Id: <1389646059-24881-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>

Hi Ingo,

	There are more patchkits outstanding that I have to revisit/retest, but
lets get this first batch in to keep pull reqs at a reasonable size.

	Please consider pulling,

- Arnaldo

The following changes since commit 1341f3e4c0276aae3de6d902c9202265d89fe438:

  Merge tag 'perf-core-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/core (2014-01-12 17:39:47 +0100)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-core-for-mingo

for you to fetch changes up to 26f7f9877234e6b9ed87eff4ca450631bafe0182:

  perf tools: Remove unused test-volatile-register-var.c (2014-01-13 17:20:05 -0300)

----------------------------------------------------------------
New features:

. perf record: Add --initial-delay option (Andi Kleen)

. Column colouring improvements in 'diff' (Ramkumar Ramachandra)

Fixes:

. Don't show counter information when workload fails (Arnaldo Carvalho de Melo)

. Fixup leak on error path in parse events test. (Arnaldo Carvalho de Melo)

. Fix --delay option in 'stat' man page (Andi Kleen)

. Use the DWARF unwind info only if loaded (Jean Pihet):

Developer stuff:

. Improve forked workload error reporting by sending the errno in the signal
  data queueing integer field, using sigqueue and by doing the signal setup in
  the evlist methods, removing open coded equivalents in various tools. (Arnaldo Carvalho de Melo)

. Do more auto exit cleanup shores in the 'evlist' destructor, so that the tools
  don't have to all do that sequence. (Arnaldo Carvalho de Melo)

. Pack 'struct perf_session_env' and 'struct trace' (Arnaldo Carvalho de Melo)

. Include tools/lib/api/ in MANIFEST, fixing detached tarballs (Arnaldo Carvalho de Melo)

. Add test for building detached source tarballs (Arnaldo Carvalho de Melo)

. Shut up libtracevent plugins make message (Jiri Olsa)

. Fix installation tests path setup (Jiri Olsa)

. Fix id_hdr_size initialization (Jiri Olsa)

. Move some header files from tools/perf/ to tools/include/ to make them available to
  other tools/ dwelling codebases (Namhyung Kim)

. Fix 'probe' build when DWARF support libraries not present (Arnaldo Carvalho de Melo)

Refactorings:

. Move logic to warn about kptr_restrict'ed kernels to separate
  function in 'report' (Arnaldo Carvalho de Melo)

. Move hist browser selection code to separate function (Arnaldo Carvalho de Melo)

. Move histogram entries collapsing to separate function (Arnaldo Carvalho de Melo)

. Introduce evlist__for_each() & friends (Arnaldo Carvalho de Melo)

. Automate setup of FEATURE_CHECK_(C|LD)FLAGS-all variables (Jiri Olsa)

. Move arch setup into seprate Makefile (Jiri Olsa)

Trivial stuff:

. Remove misplaced __maybe_unused in 'stat' (Arnaldo Carvalho de Melo)

. Remove old evsel_list usage in 'record' (Arnaldo Carvalho de Melo)

. Comment typo fix (Cody P Schafer)

. Remove unused test-volatile-register-var.c (Yann Droneaud)

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Andi Kleen (2):
      perf stat: Fix --delay option in man page
      perf record: Add --initial-delay option

Arnaldo Carvalho de Melo (18):
      perf stat: Don't show counter information when workload fails
      perf evlist: Send the errno in the signal when workload fails
      perf evlist: Move the SIGUSR1 error reporting logic to prepare_workload
      perf record: Remove old evsel_list usage
      perf evlist: Move destruction of maps to evlist destructor
      perf evlist: Close fds on destructor
      perf evlist: Auto unmap on destructor
      perf tests: Fixup leak on error path in parse events test
      perf stat: Remove misplaced __maybe_unused
      perf header: Pack 'struct perf_session_env'
      perf trace: Pack 'struct trace'
      perf report: Move logic to warn about kptr_restrict'ed kernels to separate function
      perf report: Move hist browser selection code to separate function
      perf report: Move histogram entries collapsing to separate function
      perf evlist: Introduce evlist__for_each() & friends
      perf tools: Include tools/lib/api/ in MANIFEST
      perf tools: Add test for building detached source tarballs
      perf probe: Fix build when DWARF support libraries not present

Cody P Schafer (1):
      tools perf: Comment typo fix

Jean Pihet (1):
      perf tools: Use the DWARF unwind info only if loaded

Jiri Olsa (7):
      perf tools: Move arch setup into seprate Makefile
      perf tests: Fix installation tests path setup
      tools lib traceevent: Replace tabs with spaces for all non-commands statements
      tools lib traceevent: Shut up plugins make message
      perf tools: Automate setup of FEATURE_CHECK_(C|LD)FLAGS-all variables
      perf machine: Fix id_hdr_size initialization
      perf tools: Make perf_event__synthesize_mmap_events global

Namhyung Kim (4):
      tools include: Move perf's linux/compiler.h to a generic place
      tools include: Define likely/unlikely in linux/compiler.h
      tools include: Move perf's bug.h to a generic place
      tools include: Include <linux/compiler.h> from asm/bug.h

Ramkumar Ramachandra (4):
      perf tools: Generalize percent_color_snprintf()
      perf diff: Color the Delta column
      perf diff: Color the Ratio column
      perf diff: Color the Weighted Diff column

Yann Droneaud (1):
      perf tools: Remove unused test-volatile-register-var.c

 tools/{perf/util => }/include/asm/bug.h            |   9 +-
 tools/{perf/util => }/include/linux/compiler.h     |  12 +-
 tools/lib/traceevent/Makefile                      |  59 ++++---
 tools/perf/Documentation/perf-record.txt           |   4 +
 tools/perf/Documentation/perf-stat.txt             |   2 +-
 tools/perf/MANIFEST                                |   4 +-
 tools/perf/Makefile.perf                           |   4 +-
 tools/perf/builtin-annotate.c                      |   2 +-
 tools/perf/builtin-diff.c                          |  98 ++++++++++-
 tools/perf/builtin-evlist.c                        |   2 +-
 tools/perf/builtin-inject.c                        |   2 +-
 tools/perf/builtin-kvm.c                           |   6 +-
 tools/perf/builtin-record.c                        |  82 +++++----
 tools/perf/builtin-report.c                        | 192 ++++++++++++---------
 tools/perf/builtin-script.c                        |   5 +-
 tools/perf/builtin-stat.c                          |  66 ++++---
 tools/perf/builtin-top.c                           |  14 +-
 tools/perf/builtin-trace.c                         |  30 ++--
 tools/perf/config/Makefile                         |  67 ++++---
 tools/perf/config/Makefile.arch                    |  22 +++
 .../feature-checks/test-volatile-register-var.c    |   6 -
 tools/perf/perf.h                                  |   1 +
 tools/perf/tests/code-reading.c                    |   7 +-
 tools/perf/tests/evsel-roundtrip-name.c            |   2 +-
 tools/perf/tests/hists_link.c                      |   4 +-
 tools/perf/tests/keep-tracking.c                   |   7 +-
 tools/perf/tests/make                              |  40 +++--
 tools/perf/tests/mmap-basic.c                      |  25 ++-
 tools/perf/tests/open-syscall-tp-fields.c          |  16 +-
 tools/perf/tests/parse-events.c                    |  10 +-
 tools/perf/tests/perf-record.c                     |  21 +--
 tools/perf/tests/perf-targz-src-pkg                |  21 +++
 tools/perf/tests/perf-time-to-tsc.c                |   6 -
 tools/perf/tests/sw-clock.c                        |  18 +-
 tools/perf/tests/task-exit.c                       |  33 ++--
 tools/perf/ui/browsers/hists.c                     |   5 +-
 tools/perf/ui/gtk/hists.c                          |   2 +-
 tools/perf/util/cgroup.c                           |   4 +-
 tools/perf/util/color.c                            |  15 +-
 tools/perf/util/color.h                            |   1 +
 tools/perf/util/event.c                            |  12 +-
 tools/perf/util/event.h                            |   7 +
 tools/perf/util/evlist.c                           |  78 +++++----
 tools/perf/util/evlist.h                           |  69 +++++++-
 tools/perf/util/evsel.c                            |   3 +-
 tools/perf/util/header.c                           |  19 +-
 tools/perf/util/header.h                           |  10 +-
 tools/perf/util/machine.c                          |   1 +
 tools/perf/util/parse-events.c                     |   5 +-
 tools/perf/util/pmu.c                              |   2 +-
 tools/perf/util/probe-event.c                      |   5 +-
 tools/perf/util/python.c                           |   3 +-
 tools/perf/util/record.c                           |   6 +-
 tools/perf/util/session.c                          |   6 +-
 tools/perf/util/unwind.c                           |   8 +-
 55 files changed, 724 insertions(+), 436 deletions(-)
 rename tools/{perf/util => }/include/asm/bug.h (81%)
 rename tools/{perf/util => }/include/linux/compiler.h (64%)
 create mode 100644 tools/perf/config/Makefile.arch
 delete mode 100644 tools/perf/config/feature-checks/test-volatile-register-var.c
 create mode 100755 tools/perf/tests/perf-targz-src-pkg
