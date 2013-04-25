Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273Ab3DYMzg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 08:55:36 -0400
Received: from www.linutronix.de ([62.245.132.108]:43780 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755203Ab3DYMzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 08:55:35 -0400
Message-ID: <517927C2.40402@linutronix.de>
Date: Thu, 25 Apr 2013 14:55:30 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Mike Galbraith <bitbucket@online.de>
CC: Tim Sander <tim.sander@hbm.com>, Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        RT <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Subject: Re: [ANNOUNCE] 3.4.41-rt55-feat1
References: <1366760662.9609.176.camel@gandalf.local.home>  <2156546.QlsX0XyPQz@dabox> <51792277.8000205@linutronix.de> <1366893374.6139.5.camel@marge.simpson.net>
In-Reply-To: <1366893374.6139.5.camel@marge.simpson.net>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2013 02:36 PM, Mike Galbraith wrote:
> hrtimer: fix hrtimer free zone build bug
> 
> Signed-off-by: Mike Galbraith <bitbucket@online.de>
> 
> diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
> index 2328c04..31d57a2 100644
> --- a/kernel/hrtimer.c
> +++ b/kernel/hrtimer.c
> @@ -1036,7 +1036,7 @@ int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
>  		&& hrtimer_enqueue_reprogram(timer, new_base)) {
>  
>  		if (wakeup
> -#ifdef CONFIG_PREEMPT_RT_BASE
> +#if defined(CONFIG_PREEMPT_RT_BASE) && defined(CONFIG_HIGH_RES_TIMERS)
>  		    /*
>  		     * Move softirq based timers away from the rbtree in
>  		     * case it expired already. Otherwise we would have a
> 
> 

hrtimer_enqueue_reprogram() returns 0 in non-high res case so
everything down there is never reached. The compiler should see this :)

Sebastian
