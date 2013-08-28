Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517Ab3H1S1W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 14:27:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6466 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753461Ab3H1S1U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 14:27:20 -0400
Date: Wed, 28 Aug 2013 14:27:10 -0400
From: Dave Jones <davej@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: FTRACE_WARN_ON((rec->flags & ~FTRACE_FL_MASK) == 0))
Message-ID: <20130828182710.GA14103@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20130828034627.GA30596@redhat.com>
 <20130828095408.37c3dd83@gandalf.local.home>
 <20130828095833.103ccdf0@gandalf.local.home>
 <20130828111746.35369b84@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130828111746.35369b84@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 28, 2013 at 11:17:46AM -0400, Steven Rostedt wrote:
 
 > Dave, can you add this patch to your kernels you test, and that way,
 > the next time you hit this error, I want to see if this warning was
 > triggered too.
 > 
 > If we did not unregister the ftrace ops but free the filters, it will
 > cause the accounting to get out of whack.
 > 
 > Thanks!
 > 
 > -- Steve
 > 
 > diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
 > index 80c36bc..05167bb 100644
 > --- a/kernel/trace/trace_event_perf.c
 > +++ b/kernel/trace/trace_event_perf.c
 > @@ -306,6 +306,7 @@ static int perf_ftrace_function_unregister(struct perf_event *event)
 >  {
 >  	struct ftrace_ops *ops = &event->ftrace_ops;
 >  	int ret = unregister_ftrace_function(ops);
 > +	WARN_ON(ret);
 >  	ftrace_free_filter(ops);
 >  	return ret;
 >  }

I hit the WARN in the subject, and then this new one immediately afterwards.

	Dave.

