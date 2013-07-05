Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051Ab3GEXRp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 19:17:45 -0400
Received: from www.linutronix.de ([62.245.132.108]:47168 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906Ab3GEXRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 19:17:44 -0400
Date: Sat, 6 Jul 2013 01:17:41 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
cc: John Stultz <john.stultz@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Emilio Lopez <emilio@elopez.com.ar>,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, linux-sunxi@googlegroups.com
Subject: Re: [PATCHv4 08/10] clocksource: sun4i: Remove TIMER_SCAL variable
In-Reply-To: <1373062725-19625-9-git-send-email-maxime.ripard@free-electrons.com>
Message-ID: <alpine.DEB.2.02.1307060031030.32106@ionos.tec.linutronix.de>
References: <1373062725-19625-1-git-send-email-maxime.ripard@free-electrons.com> <1373062725-19625-9-git-send-email-maxime.ripard@free-electrons.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maxime,

On Sat, 6 Jul 2013, Maxime Ripard wrote:
> @@ -168,8 +166,7 @@ static void __init sun4i_timer_init(struct device_node *node)
>  	clocksource_mmio_init(timer_base + TIMER_CNTVAL_REG(1), node->name,
>  			      rate, 300, 32, clocksource_mmio_readl_down);
>  
> -	writel(rate / (TIMER_SCAL * HZ),
> -	       timer_base + TIMER_INTVAL_REG(0));
> +	writel(rate / HZ, timer_base + TIMER_INTVAL_REG(0));
>  
>  	/* set clock source to HOSC, 16 pre-division */
>  	val = readl(timer_base + TIMER_CTL_REG(0));
> @@ -192,8 +189,8 @@ static void __init sun4i_timer_init(struct device_node *node)
>  
>  	sun4i_clockevent.cpumask = cpumask_of(0);
>  
> -	clockevents_config_and_register(&sun4i_clockevent, rate / TIMER_SCAL,
> -					0x1, 0xff);
> +	clockevents_config_and_register(&sun4i_clockevent, rate, 0x1,
> +					0xffffffff);

I really recommend that you go out for lots of beer/wine NOW and
resume reading this mail when you recovered from that.

I definitely appreciate your responsivness to feedback, but please go
back and read my reply to the previous version of this patch
carefully. You might eventually find out that I pointed you to another
redundant clk_get_rate() call in that code.

After you did this, please go through the other patches in that series
and check how many new instances of clk_get_rate() calls you add down
the road. I did not even bother to look whether you cleaned it up
between v3 and v4, but I'm quite sure you did not. If I'm wrong, I owe
you a beer at the next conference.

Please take your time to address all concerns and look over the whole
thing carefullly before resending. This is not a speed coding contest!

Taking time and reconsidering whether a comment for patch N/M might
apply to other parts of the code or other parts of the patch series is
not optional. Review comments are mostly hints. So it's up to you to
check whether such a comment might apply to more than the particular
patch line which was commented.

Taking time and being careful actually spares time on both and aside
of that it spares a lot of pointless wasted electrons sent through the
intertubes.

Have a good weekend!

     tglx
