Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933252Ab3DOFLl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 01:11:41 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:50881 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932513Ab3DOFLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 01:11:40 -0400
X-AuditID: 9c930179-b7bd8ae000004629-af-516b8c0a8331
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCHSET 00/10] perf util: More cleanups on tracepoint handling
Date: Mon, 15 Apr 2013 14:11:28 +0900
Message-Id: <1366002698-10728-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

It seems some code that handle tracepoint events left unchanged when
they were copied from the trace-cmd.  This series tries to cleanup
them by removing unnecessary function calls and variables and filling
up some missing pieces.

It's based on my previous patchset on libtraceevent [1] and contains a
user of the new pevent_set_page_size() API too. :)

You can get this from 'perf/cleanup' branch on my tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git


Any comments are welcome, thanks.
Namhyung


[1] https://lkml.org/lkml/2013/4/11/194


Namhyung Kim (10):
  perf util: Save page size in a trace file to pevent
  perf util: Save long size of traced system
  perf util: Make file/host_bigendian variable local
  perf util: Skip reading header_event file
  perf util: Parse header_page to get proper long size
  perf util: Get rid of unused header_page_* variables
  perf util: Move latency_format variable to builtin-script.c
  perf util: Rename read_*() functions in trace-event-info.c
  perf util: No need to call read_trace_init() in tracing_data_header()
  perf util: Remove unused enum and macro in trace-event.h

 tools/perf/builtin-script.c         |  1 +
 tools/perf/util/trace-event-info.c  | 22 ++++++++---------
 tools/perf/util/trace-event-parse.c |  6 -----
 tools/perf/util/trace-event-read.c  | 49 +++++++++++++++++++++----------------
 tools/perf/util/trace-event.h       | 15 ------------
 5 files changed, 39 insertions(+), 54 deletions(-)

-- 
1.7.11.7

