Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554AbaAVV2B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 16:28:01 -0500
Received: from mailsafe.webbplatsen.se ([94.247.172.109]:42307 "EHLO
	mailsafe.webbplatsen.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134AbaAVV2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 16:28:00 -0500
Date: Wed, 22 Jan 2014 22:27:01 +0100
From: Joakim Hernberg <jbh@alchemy.lu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Mike Galbraith <bitbucket@online.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, John Kacur <jkacur@redhat.com>
Subject: Re: [ANNOUNCE] 3.12.6-rt9
Message-ID: <20140122222701.4c44b08d@tor.valhalla.alchemy.lu>
In-Reply-To: <20140120211736.0c97418a@gandalf.local.home>
References: <20131223225017.GA8623@linutronix.de>
	<1387900067.5490.33.camel@marge.simpson.net>
	<20140117170052.GF5785@linutronix.de>
	<1390014929.5444.38.camel@marge.simpson.net>
	<20140120211736.0c97418a@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Jan 2014 21:17:36 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> I happen to have a i7 box to test on, and sure enough, the latest
> 3.12-rt locks up on boot and reverting the
> timers-do-not-raise-softirq-unconditionally.patch, it boots fine.

> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> diff --git a/kernel/timer.c b/kernel/timer.c
> index 46467be..8212c10 100644
> --- a/kernel/timer.c
> +++ b/kernel/timer.c
> @@ -1464,13 +1464,11 @@ void run_local_timers(void)
>  		raise_softirq(TIMER_SOFTIRQ);
>  		return;
>  	}
> -	if (!base->active_timers)
> -		goto out;
>  
>  	/* Check whether the next pending timer has expired */
>  	if (time_before_eq(base->next_timer, jiffies))
>  		raise_softirq(TIMER_SOFTIRQ);
> -out:
> +
>  	rt_spin_unlock_after_trylock_in_irq(&base->lock);
>  
>  }

This fixes the problem on my i7-2600k.

-- 

   Joakim
