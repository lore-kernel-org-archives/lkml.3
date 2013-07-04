Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933689Ab3GDIjP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 04:39:15 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:51306 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756127Ab3GDIjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 04:39:10 -0400
X-AuditID: 9c93016f-b7b26ae000002351-38-51d534ab9884
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCHSET 00/16] perf tools: Cleanups on tracepoint handling
References: <1370323231-14022-1-git-send-email-namhyung@kernel.org>
Date: Thu, 04 Jul 2013 17:39:06 +0900
In-Reply-To: <1370323231-14022-1-git-send-email-namhyung@kernel.org> (Namhyung
	Kim's message of "Tue, 4 Jun 2013 14:20:15 +0900")
Message-ID: <87hagazplh.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping!

On Tue,  4 Jun 2013 14:20:15 +0900, Namhyung Kim wrote:
> Hello,
>
> This patchset is a resend version of previous work and basis of
> upcoming perf ftrace patchset.  Although I saw no issue on this series
> when I posted earlier, it'd be great if Steve or others take a look at
> it again and give comments.
>
> I also updated 'perf/cleanup' branch on my tree at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git
>
> Thanks,
> Namhyung
>
>
> Namhyung Kim (16):
>   tools lib traceevent: Remove unused install targets
>   tools lib traceevent: Get rid of unused gui target
>   tools lib traceevent: Add const qualifier to string arguments
>   tools lib traceevent: Add trace_seq_reset()
>   tools lib traceevent: Add page_size field to pevent
>   tools lib traceevent: Port kbuffer parser routines
>   perf util: Save page size in a trace file to pevent
>   perf util: Save long size of traced system
>   perf util: Make file/host_bigendian variable local
>   perf util: Skip reading header_event file
>   perf util: Parse header_page to get proper long size
>   perf util: Get rid of unused header_page_* variables
>   perf util: Move latency_format variable to builtin-script.c
>   perf util: Rename read_*() functions in trace-event-info.c
>   perf util: No need to call read_trace_init() in tracing_data_header()
>   perf util: Remove unused enum and macro in trace-event.h
>
>  tools/lib/traceevent/Makefile        |  18 +-
>  tools/lib/traceevent/event-parse.c   |   7 +-
>  tools/lib/traceevent/event-parse.h   |  15 +-
>  tools/lib/traceevent/kbuffer-parse.c | 732 +++++++++++++++++++++++++++++++++++
>  tools/lib/traceevent/kbuffer.h       |  67 ++++
>  tools/lib/traceevent/trace-seq.c     |  13 +
>  tools/perf/builtin-script.c          |   1 +
>  tools/perf/util/trace-event-info.c   |  22 +-
>  tools/perf/util/trace-event-parse.c  |   6 -
>  tools/perf/util/trace-event-read.c   |  52 ++-
>  tools/perf/util/trace-event.h        |  15 -
>  11 files changed, 875 insertions(+), 73 deletions(-)
>  create mode 100644 tools/lib/traceevent/kbuffer-parse.c
>  create mode 100644 tools/lib/traceevent/kbuffer.h
