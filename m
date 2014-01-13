Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751367AbaAMIBB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 03:01:01 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:56271 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229AbaAMIA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 03:00:59 -0500
X-AuditID: 9c930179-b7c5fae000006619-35-52d39d396f12
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCHSET 0/5] perf tools: Add support log window on TUI (v4)
Date: Mon, 13 Jan 2014 17:00:52 +0900
Message-Id: <1389600057-26999-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This is a new attempt to add a log window support on TUI browser.  The
header window support was already merged to acme/perf/core.

 * changes in v3)
  - use tmpfile(3) instead of mkstemp (David)
  - check NULL fp before use (David)
  - rename functions to follow the 'class__method' convention (Arnaldo)
  - restore original position when write failed (David)

You can get it from the 'perf/tui-v4' branch in my tree:

 git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git

Any comments are welcome, thanks
Namhyung


Namhyung Kim (5):
  perf tools: Introduce struct perf_log
  perf tools: Save message when pr_*() was called
  perf ui/tui: Implement log window
  perf ui/tui: Filter messages in log window
  perf ui/tui: Remember last log line for filtering

 tools/perf/Makefile.perf       |   2 +
 tools/perf/perf.c              |   5 +
 tools/perf/ui/browser.h        |   1 +
 tools/perf/ui/browsers/hists.c |   5 +
 tools/perf/ui/browsers/log.c   | 235 +++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/debug.c        |   6 ++
 tools/perf/util/debug.h        |  16 +++
 tools/perf/util/log.c          | 117 ++++++++++++++++++++
 8 files changed, 387 insertions(+)
 create mode 100644 tools/perf/ui/browsers/log.c
 create mode 100644 tools/perf/util/log.c

-- 
1.7.11.7

