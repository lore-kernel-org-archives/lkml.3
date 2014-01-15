Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740AbaAORja (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 12:39:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1463 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752719AbaAORjV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 12:39:21 -0500
Date: Wed, 15 Jan 2014 18:38:58 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/timers 2/4] timers: Reduce __run_timers()
	latency for empty list
Message-ID: <20140115173858.GC14473@redhat.com>
References: <20140115051939.GA31164@linux.vnet.ibm.com> <1389763248-31297-1-git-send-email-paulmck@linux.vnet.ibm.com> <1389763248-31297-2-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389763248-31297-2-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

forgot to mention...

On 01/14, Paul E. McKenney wrote:
>
> +static bool catchup_timer_jiffies(struct tvec_base *base)
> +{
> +#ifdef CONFIG_NO_HZ_FULL
> +	if (!base->all_timers) {
> +		base->timer_jiffies = jiffies;
> +		return 1;
> +	}
> +#endif /* #ifdef CONFIG_NO_HZ_FULL */
> +	return 0;
> +}

Do we really want ifdef?

This check is cheap, and !CONFIG_NO_HZ_FULL case looks a bit
strange because we still update ->all_timers for no reason.

Oleg.

