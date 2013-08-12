Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756982Ab3HLPKO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 11:10:14 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57401 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756867Ab3HLPKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 11:10:09 -0400
Date: Mon, 12 Aug 2013 17:09:45 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] Teach perf_trace_##call() to check
 hlist_empty(perf_events)
Message-ID: <20130812150945.GL27162@twins.programming.kicks-ass.net>
References: <20130806160826.GA2717@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130806160826.GA2717@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 06, 2013 at 06:08:26PM +0200, Oleg Nesterov wrote:
> On 08/05, Steven Rostedt wrote:
> >
> > > Sorry... should I resend once again ?
> >
> > Sure, why not. It's only 3 patches :-)
> 
> OK. Added "v2" to avoid the confusion.
> 
> The only change is
> 
> 	- Reviewed-and-Acked-by: Steven Rostedt <rostedt@goodmis.org>
> 	+ Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
> 	+ Acked-by: Steven Rostedt <rostedt@goodmis.org>
> 	
> > I wonder if the Reviewed-by assumes the Acked-by?
> 
> I dunno. But since you gave me both, I'd better preserve them all.

So I suppose the down-side to putting them in TP_ARGS() is that you
cannot use arbitrary expressions for them anymore; like:

  TP_ARGS(foo);

  TP_perf_assign(
    __perf_task(foo->ponies);
    __perf_count(foo->horses);
  ),

Not that we actually did something like that, but I imagine it might've
been useful.. A well, lets not worry too much about that and go with
this. We'll get creative again if we ever need something like that.

Acked-by: Peter Zijlstra <peterz@infradead.org>

Thanks!
