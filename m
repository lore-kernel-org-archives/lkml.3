Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611AbaAORJE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 12:09:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44365 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752572AbaAORJA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 12:09:00 -0500
Date: Wed, 15 Jan 2014 18:08:35 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/timers 3/4] timers: Reduce future
	__run_timers() latency for newly emptied list
Message-ID: <20140115170835.GC11499@redhat.com>
References: <20140115051939.GA31164@linux.vnet.ibm.com> <1389763248-31297-1-git-send-email-paulmck@linux.vnet.ibm.com> <1389763248-31297-3-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389763248-31297-3-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14, Paul E. McKenney wrote:
>
> @@ -700,6 +700,7 @@ static int detach_if_pending(struct timer_list *timer, struct tvec_base *base,
>  			base->next_timer = base->timer_jiffies;
>  	}
>  	base->all_timers--;
> +	(void)catchup_timer_jiffies(base);

Agreed, but I think that detach_expired_timer() should do the same,
this can stop main loop in __run_timers().

Oleg.

