Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174Ab3HMHrq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 03:47:46 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47570 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043Ab3HMHro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 03:47:44 -0400
Date: Tue, 13 Aug 2013 09:47:28 +0200
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
Message-ID: <20130813074728.GQ27162@twins.programming.kicks-ass.net>
References: <20130806160826.GA2717@redhat.com>
 <20130812150945.GL27162@twins.programming.kicks-ass.net>
 <20130812174515.GA14359@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130812174515.GA14359@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 12, 2013 at 07:45:15PM +0200, Oleg Nesterov wrote:
> BTW. Can't we kill __perf_addr() and the corresponding argument in
> perf_trace_buf_submit/perf_tp_event ?
> 
> Or do you think it can have a new user?

Oh, right.. I suppose that was to enable tracepoints for fault (like)
events. Clearly those never happened.

Yeah, I think we can kill that, another thing to reconsider once we grow
someone wanting it I suppose.
