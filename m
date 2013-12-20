Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753099Ab3LTFLW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 00:11:22 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:50330 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963Ab3LTFLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 00:11:20 -0500
X-AuditID: 9c93016f-b7cc5ae000007121-34-52b3d17620e1
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCHSET 0/7] perf tools: A couple of TUI improvements (v2)
Date: Fri, 20 Dec 2013 14:11:11 +0900
Message-Id: <1387516278-17024-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I was playing with TUI code and added two new windows.  One for
showing log messages and another for showing header information.
(Maybe they can be implemented on the GTK code too someday.)

 * changes from v1)
  - fix segfault on perf top (Ingo)
  - split print function handling patch (Arnaldo)
  - add filtering support on log window (Jiri, Ingo)


I put the patches on 'perf/tui-v2' branch in my tree:

  git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git

Any feedbacks are more than welcome, thanks
Namhyung


Namhyung Kim (7):
  perf report: Use pr_*() functions if possible
  perf report: Print session information only if --stdio is given
  perf tools: Introduce struct perf_log
  perf tools: Save message when pr_*() was called
  perf ui/tui: Implement log window
  perf ui/tui: Implement header window
  perf ui/tui: Filter messages in log window

 tools/perf/Makefile.perf        |   3 +
 tools/perf/builtin-report.c     |  24 +++---
 tools/perf/perf.c               |   3 +
 tools/perf/ui/browser.h         |   3 +
 tools/perf/ui/browsers/header.c | 116 +++++++++++++++++++++++++++
 tools/perf/ui/browsers/hists.c  |  10 +++
 tools/perf/ui/browsers/log.c    | 171 ++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/debug.c         |   6 ++
 tools/perf/util/debug.h         |  15 ++++
 tools/perf/util/log.c           | 105 ++++++++++++++++++++++++
 10 files changed, 445 insertions(+), 11 deletions(-)
 create mode 100644 tools/perf/ui/browsers/header.c
 create mode 100644 tools/perf/ui/browsers/log.c
 create mode 100644 tools/perf/util/log.c

-- 
1.7.11.7

