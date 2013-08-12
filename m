Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752257Ab3HLRv0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 13:51:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9685 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753931Ab3HLRvW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 13:51:22 -0400
Date: Mon, 12 Aug 2013 19:45:15 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] Teach perf_trace_##call() to check
	hlist_empty(perf_events)
Message-ID: <20130812174515.GA14359@redhat.com>
References: <20130806160826.GA2717@redhat.com> <20130812150945.GL27162@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130812150945.GL27162@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12, Peter Zijlstra wrote:
>
> So I suppose the down-side to putting them in TP_ARGS() is that you
> cannot use arbitrary expressions for them anymore; like:
>
>   TP_ARGS(foo);
>
>   TP_perf_assign(
>     __perf_task(foo->ponies);
>     __perf_count(foo->horses);
>   ),
>
> Not that we actually did something like that, but I imagine it might've
> been useful..

Yes. This is of course less generic. And more confusing, I agree.

> A well, lets not worry too much about that and go with
> this. We'll get creative again if we ever need something like that.
>
> Acked-by: Peter Zijlstra <peterz@infradead.org>

Thanks ;)

BTW. Can't we kill __perf_addr() and the corresponding argument in
perf_trace_buf_submit/perf_tp_event ?

Or do you think it can have a new user?

Oleg.

