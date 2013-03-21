Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757729Ab3CUHSz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 03:18:55 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:45112 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756089Ab3CUHSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 03:18:54 -0400
X-AuditID: 9c930179-b7c78ae000000e4b-c1-514ab45c13b3
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCHSET 0/9] perf util: Cleanup die() and its friends (v2)
Date: Thu, 21 Mar 2013 16:18:43 +0900
Message-Id: <1363850332-25297-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I updated this series with previous feedbacks from Steven, Peter and
Arnaldo.  Thanks for all your comments.

* v2 changes
 - fix a grammar in an error message
 - change some pr_err() -> pr_debug()
 - use kernel error checking style consistently

Namhyung Kim (9):
  perf util: Let get_tracing_file() can return NULL
  perf util: Get rid of malloc_or_die() in trace-event-info.c
  perf util: Get rid of write_or_die() from trace-event-info.c
  perf util: Get rid of die() calls from trace-event-info.c
  perf util: Handle failure case in trace_report()
  perf util: Get rid of malloc_or_die() in trace-event-read.c
  perf util: Get rid of read_or_die() in trace-event-read.c
  perf util: Get rid of die() calls in trace-data-read.c
  perf util: Cleanup calc_data_size logic

 tools/perf/util/header.c           |   9 +-
 tools/perf/util/trace-event-info.c | 347 +++++++++++++++++++++++++------------
 tools/perf/util/trace-event-read.c | 270 +++++++++++++++++++----------
 tools/perf/util/trace-event.h      |   2 +-
 4 files changed, 425 insertions(+), 203 deletions(-)

-- 
1.7.11.7

