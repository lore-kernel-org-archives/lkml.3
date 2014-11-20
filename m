Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756160AbaKTGdc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 01:33:32 -0500
Received: from lgeamrelo04.lge.com ([156.147.1.127]:58649 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756103AbaKTGdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 01:33:31 -0500
X-Original-SENDERIP: 10.177.222.33
X-Original-MAILFROM: byungchul.park@lge.com
Date: Thu, 20 Nov 2014 15:33:03 +0900
From: Byungchul Park <byungchul.park@lge.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, mingo@redhat.com,
        linux-kernel@vger.kernel.org, seungho1.park@lge.com, jolsa@redhat.com
Subject: Re: [PATCH v4 3/3] tracing: add additional marks to signal very
 large delay
Message-ID: <20141120063303.GC27177@byungchulpark-X58A-UD3R>
References: <1416290246-882-1-git-send-email-byungchul.park@lge.com>
 <1416290246-882-4-git-send-email-byungchul.park@lge.com>
 <20141119133515.1caa293e@gandalf.local.home>
 <87egsypfjs.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87egsypfjs.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, namhyung

On Thu, Nov 20, 2014 at 03:11:19PM +0900, Namhyung Kim wrote:
> On Wed, 19 Nov 2014 13:35:15 -0500, Steven Rostedt wrote:
> > On Tue, 18 Nov 2014 14:57:26 +0900
> > byungchul.park@lge.com wrote:
> >
> >> From: Byungchul Park <byungchul.park@lge.com>
> >> 
> >> Currently, some tracers tracing latency print "!" or "+" just after time
> >> to signal overhead, depending on the interval between events. Even it is
> >> usually enough to do that, we sometimes need to be signaled for bigger
> >> interval than 100 micro seconds.
> >> 
> >> Signed-off-by: Byungchul Park <byungchul.park@lge.com>
> >> ---
> >>  Documentation/trace/ftrace.txt |    8 +++++---
> >>  kernel/trace/trace_output.c    |   23 ++++++++++++++++++-----
> >>  2 files changed, 23 insertions(+), 8 deletions(-)
> >> 
> >> diff --git a/Documentation/trace/ftrace.txt b/Documentation/trace/ftrace.txt
> >> index f827e2f..64efb3e 100644
> >> --- a/Documentation/trace/ftrace.txt
> >> +++ b/Documentation/trace/ftrace.txt
> >> @@ -680,9 +680,11 @@ The above is mostly meaningful for kernel developers.
> >>  	 needs to be fixed to be only relative to the same CPU.
> >>  	 The marks are determined by the difference between this
> >>  	 current trace and the next trace.
> >> -	  '!' - greater than preempt_mark_thresh (default 100)
> >> -	  '+' - greater than 1 microsecond
> >> -	  ' ' - less than or equal to 1 microsecond.
> >> +	  '$' - greater than 1 second
> >> +	  '#' - greater than 1000 microsecond
> >> +	  '!' - greater than 100 microsecond
> >> +	  '+' - greater than 10 microsecond
> 
> I've noticed that it's now changed from 1 msec to 10 msec.  Is it okay?
>

Yes it is okay. Steve asked for changing the value. :)

Thanks,
Byungchul
 
> Thanks,
> Namhyung
> 
> 
> >> +	  ' ' - less than or equal to 10 microsecond.
> >>  
> >>    The rest is the same as the 'trace' file.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
