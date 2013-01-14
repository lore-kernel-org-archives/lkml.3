Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588Ab3ANLGe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 06:06:34 -0500
Received: from www.linutronix.de ([62.245.132.108]:58430 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756214Ab3ANLGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 06:06:33 -0500
Date: Mon, 14 Jan 2013 12:06:31 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mark Rutland <mark.rutland@arm.com>
cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        nico@linaro.org, will.deacon@arm.com, marc.zyngier@arm.com,
        john.stultz@linaro.org
Subject: Re: [PATCHv2 1/4] clockevents: Add generic timer broadcast
 receiver
In-Reply-To: <1357742770-15028-2-git-send-email-mark.rutland@arm.com>
Message-ID: <alpine.LFD.2.02.1301141204421.7475@ionos>
References: <1357742770-15028-1-git-send-email-mark.rutland@arm.com> <1357742770-15028-2-git-send-email-mark.rutland@arm.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Jan 2013, Mark Rutland wrote:
> +#ifdef CONFIG_GENERIC_CLOCKEVENTS_BROADCAST
> +extern int tick_receive_broadcast(void);
> +#else
> +static inline int tick_receive_broadcast(void)
> +{
> +	return 0;
> +}

What's the inline function for? If an arch does not have broadcasting
support it should not have a receive broadcast function call either.

> +#endif
> +
>  #ifdef CONFIG_GENERIC_CLOCKEVENTS
>  extern void clockevents_notify(unsigned long reason, void *arg);
>  #else
> diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
> index f113755..5079bb7 100644
> --- a/kernel/time/tick-broadcast.c
> +++ b/kernel/time/tick-broadcast.c
> @@ -125,6 +125,18 @@ int tick_device_uses_broadcast(struct clock_event_device *dev, int cpu)
>  	return ret;
>  }
>  
> +int tick_receive_broadcast(void)
> +{
> +	struct tick_device *td = this_cpu_ptr(&tick_cpu_device);
> +	struct clock_event_device *evt = td->evtdev;
> +
> +	if (!evt)
> +		return -ENODEV;

Is anything going to use the return value?

Thanks,

	tglx
