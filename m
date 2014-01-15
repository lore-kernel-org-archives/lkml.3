Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751964AbaAOUyM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 15:54:12 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:7744 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751720AbaAOUyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 15:54:08 -0500
Date: Wed, 15 Jan 2014 15:54:05 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/timers 3/4] timers: Reduce future
 __run_timers() latency for newly emptied list
Message-ID: <20140115155405.5682a2de@gandalf.local.home>
In-Reply-To: <1389763248-31297-3-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140115051939.GA31164@linux.vnet.ibm.com>
	<1389763248-31297-1-git-send-email-paulmck@linux.vnet.ibm.com>
	<1389763248-31297-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Jan 2014 21:20:47 -0800
"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:


> diff --git a/kernel/timer.c b/kernel/timer.c
> index 295837e5e011..bdd1c00ec4ec 100644
> --- a/kernel/timer.c
> +++ b/kernel/timer.c
> @@ -700,6 +700,7 @@ static int detach_if_pending(struct timer_list *timer, struct tvec_base *base,
>  			base->next_timer = base->timer_jiffies;
>  	}
>  	base->all_timers--;
> +	(void)catchup_timer_jiffies(base);

Why the "(void)" ?

-- Steve

>  	return 1;
>  }
>  

