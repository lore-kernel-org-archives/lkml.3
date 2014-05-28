Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478AbaE1N0u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 09:26:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43776 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752670AbaE1N0s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 09:26:48 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Cody P Schafer <dev@codyps.com>, David Ahern <dsahern@gmail.com>,
        Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Javi Merino <javi.merino@arm.com>, Jiri Olsa <jolsa@kernel.org>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Subject: [GIT PULL 0/9] perf/core improvements and fixes
Date: Wed, 28 May 2014 15:20:53 +0200
Message-Id: <1401283262-16035-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Ingo,
please consider pulling

thanks,
jirka


The following changes since commit e450f90e8c7d0bf70519223c1b848446ae63f313:

  Merge tag 'perf-core-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf into perf/core (2014-05-22 11:37:40 +0200)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git tags/perf-core-for-mingo

for you to fetch changes up to 34cfec19bd8496279d283498b97069d9a0f7e130:

  tools lib traceevent: Added support for __get_bitmask() macro (2014-05-28 15:08:26 +0200)

----------------------------------------------------------------
perf/core improvements and fixes:

. Added support for __get_bitmask() macro to traceevent library (Steven Rostedt)

. Allow overriding sysfs and proc finding with env var (Cody P Schafer)

. Consider header files outside perf directory in tags target (Sebastian Andrzej Siewior)

. Add warning when disabling perl scripting support due to missing devel files (Arnaldo Carvalho de Melo)

. Warn the user when trace command is not available (Arnaldo Carvalho de Melo)

. Pass protection and flags bits through mmap2 interface (Peter Zijlstra)

. Update perf tool mmap2 interface with protection and flag bits (Don Zickus)

. Re-enable mmap interface (Don Zickus)

. Add mem-mode documentation to report command (Don Zickus)

Signed-off-by: Jiri Olsa <jolsa@kernel.org>

----------------------------------------------------------------
Arnaldo Carvalho de Melo (2):
      perf trace: Warn the user when not available
      perf tools: Add warning when disabling perl scripting support due to missing devel files

Cody P Schafer (1):
      perf tools: Allow overriding sysfs and proc finding with env var

Don Zickus (3):
      Revert "perf: Disable PERF_RECORD_MMAP2 support"
      perf tools: Update mmap2 interface with protection and flag bits
      perf report: Add mem-mode documentation to report command

Peter Zijlstra (1):
      perf: Pass protection and flags bits through mmap2 interface

Sebastian Andrzej Siewior (1):
      perf tools: Consider header files outside perf directory in tags target

Steven Rostedt (Red Hat) (1):
      tools lib traceevent: Added support for __get_bitmask() macro

 include/uapi/linux/perf_event.h                    |   1 +
 kernel/events/core.c                               |  37 ++++++-
 tools/lib/api/fs/fs.c                              |  43 +++++++-
 tools/lib/traceevent/event-parse.c                 | 113 +++++++++++++++++++++
 tools/lib/traceevent/event-parse.h                 |   7 ++
 tools/perf/Documentation/perf-report.txt           |  22 ++++
 tools/perf/Makefile.perf                           |   9 +-
 tools/perf/config/Makefile                         |   1 +
 tools/perf/perf.c                                  |   8 +-
 tools/perf/tests/dwarf-unwind.c                    |   2 +-
 tools/perf/util/event.c                            |  59 +++++++----
 tools/perf/util/event.h                            |   2 +
 tools/perf/util/evsel.c                            |   1 +
 tools/perf/util/machine.c                          |   4 +-
 tools/perf/util/map.c                              |   4 +-
 tools/perf/util/map.h                              |   4 +-
 .../perf/util/scripting-engines/trace-event-perl.c |   1 +
 .../util/scripting-engines/trace-event-python.c    |   1 +
 18 files changed, 286 insertions(+), 33 deletions(-)
