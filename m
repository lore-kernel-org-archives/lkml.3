Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751599Ab3LSHAR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 02:00:17 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:47860 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872Ab3LSHAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 02:00:15 -0500
X-AuditID: 9c930179-b7bedae000000f15-54-52b2997c2454
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCHSET 0/6] perf tools: A couple of TUI improvements
Date: Thu, 19 Dec 2013 16:00:05 +0900
Message-Id: <1387436411-20160-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I was playing with TUI code and added two new windows.  One for
showing log messages and another for showing header information.
(Maybe they can be implemented on the GTK code too someday.)

Please try to use it! :)

I put the patches on 'perf/tui-v1' branch in my tree:

  git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git

Any feedbacks are more than welcome, thanks
Namhyung


Namhyung Kim (6):
  perf report: Use pr_*() functions if possible
  perf tools: Introduce struct perf_log
  perf tools: Get rid of a duplicate va_end()
  perf tools: Save message when pr_*() was called
  perf ui/tui: Implement log window
  perf ui/tui: Implement header window

 tools/perf/Makefile.perf        |   3 ++
 tools/perf/builtin-report.c     |  24 +++++----
 tools/perf/perf.c               |   3 ++
 tools/perf/ui/browser.h         |   3 ++
 tools/perf/ui/browsers/header.c | 116 ++++++++++++++++++++++++++++++++++++++++
 tools/perf/ui/browsers/hists.c  |   8 +++
 tools/perf/ui/browsers/log.c    |  92 +++++++++++++++++++++++++++++++
 tools/perf/util/debug.c         |   7 ++-
 tools/perf/util/debug.h         |  15 ++++++
 tools/perf/util/log.c           | 105 ++++++++++++++++++++++++++++++++++++
 10 files changed, 364 insertions(+), 12 deletions(-)
 create mode 100644 tools/perf/ui/browsers/header.c
 create mode 100644 tools/perf/ui/browsers/log.c
 create mode 100644 tools/perf/util/log.c

-- 
1.7.11.7

