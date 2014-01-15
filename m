Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657AbaAORYk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 12:24:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35876 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751502AbaAORYi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 12:24:38 -0500
Date: Wed, 15 Jan 2014 18:24:09 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/timers 4/4] timers: Reduce future
	__run_timers() latency for first add to empty list
Message-ID: <20140115172409.GD11499@redhat.com>
References: <20140115051939.GA31164@linux.vnet.ibm.com> <1389763248-31297-1-git-send-email-paulmck@linux.vnet.ibm.com> <1389763248-31297-4-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389763248-31297-4-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14, Paul E. McKenney wrote:
>
> @@ -749,6 +749,7 @@ __mod_timer(struct timer_list *timer, unsigned long expires,
>
>  	base = lock_timer_base(timer, &flags);
>
> +	(void)catchup_timer_jiffies(base);

Agreed, but perhaps it would be better to do this before
all_timers++ in internal_add_timer() ?

This is funny, but I already have the same change for ->next_timer,
if we add this optimization perhaps that trivial patch makes sense
too.

Oleg.

