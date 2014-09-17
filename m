Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757076AbaIQVYi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 17:24:38 -0400
Received: from mail.kernel.org ([198.145.19.201]:57847 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756386AbaIQVYg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 17:24:36 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexander Yarygin <yarygin@linux.vnet.ibm.com>,
        Anton Blanchard <anton@samba.org>,
        Avi Kivity <avi@cloudius-systems.com>,
        Chanho Park <chanho61.park@samsung.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, david lerner <dlernerdroid@gmail.com>,
        Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jean Pihet <jean.pihet@linaro.org>, Jiri Olsa <jolsa@redhat.com>,
        John Spencer <maillist-linux@barfooze.de>,
        Kyle McMartin <kyle@mcmartin.ca>, linux-perf-users@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Michael Ellerman <mpe@ellerman.id.au>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        yrl.pp-manager.tt@hitachi.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 00/20] perf/core improvements and fixes
Date: Wed, 17 Sep 2014 18:24:03 -0300
Message-Id: <1410989063-14207-1-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

	Please consider pulling,

- Arnaldo

The following changes since commit c88f2096136416b261bd3647cc260935f6e95805:

  perf: Do not check PERF_EVENT_STATE_EXIT on syscall read path (2014-09-16 10:30:36 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git tags/perf-core-for-mingo

for you to fetch changes up to e5685730e2c620f97bc12380e9370e857e5bd7a7:

  perf record: Use ring buffer consume method to look like other tools (2014-09-17 18:01:43 -0300)

----------------------------------------------------------------
perf/core improvements and fixes:

User visible:

o Add +field argument support for --sort option (Jiri Olsa)

o Do not access kallsyms when analyzing user binaries with 'probe' (Masami Hiramatsu)

o Ignore stripped vmlinux and fallback to kallsyms (Anton Blanchard)

o Add path to Ubuntu kernel debuginfo file (Anton Blanchard)

o Disable kernel symbol demangling by default (Avi Kivity)

Infrastructure:

o More intel PT prep work, from Adrian Hunter, including:

  - Let a user specify a PMU event without any config terms
  - Add perf-with-kcore script
  - Let default config be defined for a PMU
  - Add perf_pmu__scan_file()

o "perf kvm stat report" improvements by Alexander Yarygin:
  o  Save pid string in opts.target.pid
  o  Enable the target.system_wide flag
  o  Unify the title bar output

o Fix build issue on powerpc when DWARF support is disabled (Anton Blanchard)

o Allow to specify lib compile variable for spec usage (Jiri Olsa)

o Fix build on ARM (Stephane Eranian)

o Fix build on powerpc when DWARF support is disabled (Anton Blanchard)

o Don't include sys/poll.h directly (Arnaldo Carvalho de Melo)

o Use ring buffer consume method to look like other tools (Arnaldo Carvalho de Melo)

Chanho Park (1):
  perf tools: define _DEFAULT_SOURCE for glibc_2.20

o Allow to specify lib compile variable for spec usage (Jiri Olsa)

o Fix GNU-only grep usage in Makefile (John Spencer)

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Adrian Hunter (4):
      perf tools: Let a user specify a PMU event without any config terms
      perf tools: Add perf-with-kcore script
      perf tools: Let default config be defined for a PMU
      perf tools: Add perf_pmu__scan_file()

Alexander Yarygin (3):
      perf kvm stat report: Save pid string in opts.target.pid
      perf kvm stat report: Enable the target.system_wide flag
      perf kvm stat report: Unify the title bar output

Anton Blanchard (3):
      perf tools powerpc: Fix build issue when DWARF support is disabled
      perf symbols: Ignore stripped vmlinux and fallback to kallsyms
      perf symbols: Add path to Ubuntu kernel debuginfo file

Arnaldo Carvalho de Melo (2):
      perf tools: Don't include sys/poll.h directly
      perf record: Use ring buffer consume method to look like other tools

Avi Kivity (1):
      perf tools: Disable kernel symbol demangling by default

Chanho Park (1):
      perf tools: define _DEFAULT_SOURCE for glibc_2.20

Jiri Olsa (2):
      perf tools: Add +field argument support for --sort option
      perf tools: Allow to specify lib compile variable for spec usage

John Spencer (1):
      perf tools: Fix GNU-only grep usage in Makefile

Masami Hiramatsu (2):
      perf probe: Do not access kallsyms when analyzing user binaries
      perf probe: Do not use dwfl_module_addrsym if dwarf_diename finds symbol name

Stephane Eranian (1):
      perf tool: fix compilation for ARM

 tools/perf/.gitignore                       |   1 +
 tools/perf/Documentation/perf-probe.txt     |   3 +
 tools/perf/Documentation/perf-report.txt    |   3 +
 tools/perf/Documentation/perf-top.txt       |   3 +
 tools/perf/Makefile.perf                    |   5 +-
 tools/perf/arch/arm/tests/dwarf-unwind.c    |   1 +
 tools/perf/arch/arm/util/unwind-libunwind.c |   1 +
 tools/perf/arch/powerpc/Makefile            |   2 +-
 tools/perf/bench/sched-messaging.c          |   2 +-
 tools/perf/builtin-kvm.c                    |  23 +--
 tools/perf/builtin-probe.c                  |   5 +-
 tools/perf/builtin-record.c                 |   8 +-
 tools/perf/builtin-report.c                 |   2 +
 tools/perf/builtin-top.c                    |   4 +-
 tools/perf/config/Makefile                  |  12 +-
 tools/perf/config/utilities.mak             |   2 +-
 tools/perf/perf-with-kcore.sh               | 259 ++++++++++++++++++++++++++++
 tools/perf/tests/pmu.c                      |   2 +-
 tools/perf/util/kvm-stat.h                  |   1 -
 tools/perf/util/parse-events.c              |  13 +-
 tools/perf/util/parse-events.y              |  10 ++
 tools/perf/util/pmu.c                       |  79 +++++++--
 tools/perf/util/pmu.h                       |  12 +-
 tools/perf/util/probe-event.c               |   9 +-
 tools/perf/util/probe-event.h               |   3 +-
 tools/perf/util/probe-finder.c              |  16 +-
 tools/perf/util/sort.c                      |  37 +++-
 tools/perf/util/symbol-elf.c                |  15 +-
 tools/perf/util/symbol.c                    |   9 +-
 tools/perf/util/symbol.h                    |   1 +
 tools/perf/util/util.h                      |   4 +-
 31 files changed, 487 insertions(+), 60 deletions(-)
 create mode 100644 tools/perf/perf-with-kcore.sh
