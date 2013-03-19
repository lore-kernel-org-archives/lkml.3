Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757718Ab3CSIxs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 04:53:48 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:61599 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755606Ab3CSIxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 04:53:46 -0400
X-AuditID: 9c930197-b7cc2ae000000eb7-49-51482798fbe3
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCHSET 0/9] perf util: Cleanup die() and its friends
Date: Tue, 19 Mar 2013 17:53:35 +0900
Message-Id: <1363683224-28804-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've done this painful cleanup of *die() removal. ;-) It now can
return error code rather than calling die() when something bad happen.
It only touches tracepoint related code and I tested it's working
normally but lacks thorough testing in various environment.

Please help testing more!

Thanks,
Namhyung


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

 tools/perf/util/header.c           |  11 +-
 tools/perf/util/trace-event-info.c | 336 +++++++++++++++++++++++++------------
 tools/perf/util/trace-event-read.c | 256 ++++++++++++++++++----------
 tools/perf/util/trace-event.h      |   2 +-
 4 files changed, 403 insertions(+), 202 deletions(-)

-- 
1.7.11.7

