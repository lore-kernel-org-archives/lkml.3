Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608Ab3LZFiK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 00:38:10 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:44611 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804Ab3LZFiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 00:38:07 -0500
X-AuditID: 9c93017e-b7cd8ae000002ce9-e7-52bbc0bc6cbf
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCHSET 0/8] perf tools: A couple of TUI improvements (v3)
Date: Thu, 26 Dec 2013 14:37:56 +0900
Message-Id: <1388036284-32342-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I reordered the patches so that it can be applied more smoothly.
Patch 1-2 are general cleanup/fix and not related to this patchset.
Patch 3 implements the header window for perf report.  And the rest is
for the new log window.

 * changes from v2)
  - fix segfault on log window w/ filter (Jiri)
  - split and sort help messages (Ingo)
  - optimize log window update w/ filter
  - fix help/input window display


I put the patches on 'perf/tui-v3' branch in my tree:

  git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git

Any feedbacks are more than welcome, thanks
Namhyung


Namhyung Kim (8):
  perf ui/tui: Protect windows by ui__lock
  perf ui/tui: Split help message for perf top and report
  perf ui/tui: Implement header window
  perf tools: Introduce struct perf_log
  perf tools: Save message when pr_*() was called
  perf ui/tui: Implement log window
  perf ui/tui: Filter messages in log window
  perf ui/tui: Remember last log line for filtering

 tools/perf/Makefile.perf        |   3 +
 tools/perf/perf.c               |   3 +
 tools/perf/ui/browser.h         |   3 +
 tools/perf/ui/browsers/header.c | 127 ++++++++++++++++++++++
 tools/perf/ui/browsers/hists.c  |  60 ++++++----
 tools/perf/ui/browsers/log.c    | 235 ++++++++++++++++++++++++++++++++++++++++
 tools/perf/ui/tui/util.c        |  19 +++-
 tools/perf/util/debug.c         |   6 +
 tools/perf/util/debug.h         |  16 +++
 tools/perf/util/log.c           | 111 +++++++++++++++++++
 10 files changed, 561 insertions(+), 22 deletions(-)
 create mode 100644 tools/perf/ui/browsers/header.c
 create mode 100644 tools/perf/ui/browsers/log.c
 create mode 100644 tools/perf/util/log.c

-- 
1.7.11.7

