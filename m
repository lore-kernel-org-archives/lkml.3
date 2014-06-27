Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937AbaF0MVf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 08:21:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57061 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753884AbaF0MVd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 08:21:33 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@kernel.org>,
        Maynard Johnson <maynard@us.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Subject: [GIT PULL 0/5] perf/core improvements and fixes
Date: Fri, 27 Jun 2014 14:20:56 +0200
Message-Id: <1403871661-18474-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Ingo,
please consider pulling

thanks,
jirka

The following changes since commit 1c92f88542faa3ae4f970c548b4fe8275a45201b:

  Merge tag 'perf-core-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf into perf/core (2014-06-25 07:44:19 +0200)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git tags/perf-core-for-mingo

for you to fetch changes up to 8ac631cd502d6b31fd29f6d019305305b479fa3e:

  perf script: Handle the num array type in python properly (2014-06-27 11:15:02 +0200)

----------------------------------------------------------------
perf/core improvements and fixes:

. Handle the num array type in python properly (Sebastian Andrzej Siewior)

. Fix wrong condition for allocation failure (Jiri Olsa)

. Adjust callchain based on DWARF debug info on powerpc (Sukadev Bhattiprolu)

. Fix a risk for doing free on uninitialized pointer in traceevent lib (Rickard Strandqvist)

Signed-off-by: Jiri Olsa <jolsa@kernel.org>

----------------------------------------------------------------
Jiri Olsa (1):
      perf tools: Fix wrong condition for allocation failure

Rickard Strandqvist (1):
      tools lib traceevent: Fix a risk for doing free on uninitialized pointer

Sebastian Andrzej Siewior (2):
      perf script: Move the number processing into its own function
      perf script: Handle the num array type in python properly

Sukadev Bhattiprolu (1):
      perf tools powerpc: Adjust callchain based on DWARF debug info

 tools/lib/traceevent/event-parse.c                 |   6 +-
 tools/perf/arch/powerpc/Makefile                   |   1 +
 tools/perf/arch/powerpc/util/skip-callchain-idx.c  | 266 +++++++++++++++++++++
 tools/perf/builtin-stat.c                          |   2 +-
 tools/perf/config/Makefile                         |   4 +
 tools/perf/util/callchain.h                        |  13 +
 tools/perf/util/machine.c                          |  18 +-
 .../util/scripting-engines/trace-event-python.c    |  57 +++--
 8 files changed, 346 insertions(+), 21 deletions(-)
 create mode 100644 tools/perf/arch/powerpc/util/skip-callchain-idx.c
