Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755133Ab3FDFTk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 01:19:40 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:63940 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570Ab3FDFTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 01:19:38 -0400
X-AuditID: 9c93017d-b7c04ae00000207d-a9-51ad78e948e3
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCHSET 00/16] perf tools: Cleanups on tracepoint handling
Date: Tue,  4 Jun 2013 14:19:36 +0900
Message-Id: <1370323176-13980-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patchset is a resend version of previous work and basis of
upcoming perf ftrace patchset.  Although I saw no issue on this series
when I posted earlier, it'd be great if Steve or others take a look at
it again and give comments.

I also updated 'perf/cleanup' branch on my tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git

Thanks,
Namhyung


Namhyung Kim (16):
  tools lib traceevent: Remove unused install targets
  tools lib traceevent: Get rid of unused gui target
  tools lib traceevent: Add const qualifier to string arguments
  tools lib traceevent: Add trace_seq_reset()
  tools lib traceevent: Add page_size field to pevent
  tools lib traceevent: Port kbuffer parser routines
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

 tools/lib/traceevent/Makefile        |  18 +-
 tools/lib/traceevent/event-parse.c   |   7 +-
 tools/lib/traceevent/event-parse.h   |  15 +-
 tools/lib/traceevent/kbuffer-parse.c | 732 +++++++++++++++++++++++++++++++++++
 tools/lib/traceevent/kbuffer.h       |  67 ++++
 tools/lib/traceevent/trace-seq.c     |  13 +
 tools/perf/builtin-script.c          |   1 +
 tools/perf/util/trace-event-info.c   |  22 +-
 tools/perf/util/trace-event-parse.c  |   6 -
 tools/perf/util/trace-event-read.c   |  52 ++-
 tools/perf/util/trace-event.h        |  15 -
 11 files changed, 875 insertions(+), 73 deletions(-)
 create mode 100644 tools/lib/traceevent/kbuffer-parse.c
 create mode 100644 tools/lib/traceevent/kbuffer.h

-- 
1.7.11.7

