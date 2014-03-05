Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734AbaCEL74 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 06:59:56 -0500
Received: from merlin.infradead.org ([205.233.59.134]:49580 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756686AbaCEL7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 06:59:51 -0500
Date: Wed, 5 Mar 2014 12:59:42 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Kirill Tkhai <ktkhai@parallels.com>
Cc: linux-kernel@vger.kernel.org, Juri Lelli <juri.lelli@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, tkhai@yandex.ru
Subject: Re: [PATCH tip] sched/rt: Fix picking RT and DL tasks from empty
 queue
Message-ID: <20140305115942.GX9987@twins.programming.kicks-ass.net>
References: <1393946746.3643.3.camel@tkhai>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393946746.3643.3.camel@tkhai>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2014 at 07:25:46PM +0400, Kirill Tkhai wrote:
> The problems:
> 
> 1)We check for rt_nr_running before call of put_prev_task().
> If previous task is RT, its rt_rq may become throttled
> and dequeued after this call.
> 
> In case of p is from rt->rq this just causes picking a task
> from throttled queue, but in case of its rt_rq is child
> we are guaranteed catch BUG_ON.
>     
> 2)The same with deadline class. The only difference we operate
> on only dl_rq.
>     
> This patch fix all above and it adds a small skip in DL update
> like we've already done for RT class:
> 
> 	if (unlikely((s64)delta_exec <= 0))
> 		return;
> 
> This will optimize sequential update_curr_dl() calls a little.
> 

Ah indeed, good catch that. Thanks!
