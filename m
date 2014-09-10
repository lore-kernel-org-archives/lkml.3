Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485AbaIJUd5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 16:33:57 -0400
Received: from www.linutronix.de ([62.245.132.108]:35958 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717AbaIJUd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 16:33:56 -0400
Date: Wed, 10 Sep 2014 22:33:52 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Xiubo Li <Li.Xiubo@freescale.com>
cc: daniel.lezcano@linaro.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clocksource: Add BE/LE APIs support for clocksource
 counter reading.
In-Reply-To: <1410340819-35110-1-git-send-email-Li.Xiubo@freescale.com>
Message-ID: <alpine.DEB.2.10.1409102212530.4178@nanos>
References: <1410340819-35110-1-git-send-email-Li.Xiubo@freescale.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Sep 2014, Xiubo Li wrote:

So you add BE/LE APIs according to the subject line, but you fail
again to tell WHY. If that would be the only issue ....
 
> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> ---
>  drivers/clocksource/mmio.c | 44 ++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 44 insertions(+)
> 
> diff --git a/drivers/clocksource/mmio.c b/drivers/clocksource/mmio.c
> index 1593ade..ddc5214 100644
> --- a/drivers/clocksource/mmio.c
> +++ b/drivers/clocksource/mmio.c

So you think that adding this to mmio.c is the solution to the
problem?

Ever heard about function prototypes, header files and such? 

> @@ -20,21 +20,65 @@ static inline struct clocksource_mmio *to_mmio_clksrc(struct clocksource *c)
>  	return container_of(c, struct clocksource_mmio, clksrc);
>  }
>  
> +cycle_t clocksource_mmio_readl_up_be(struct clocksource *c)
> +{
> +	return (cycle_t)be32_to_cpu(readl_relaxed(to_mmio_clksrc(c)->reg));
> +}
> +
> +cycle_t clocksource_mmio_readl_up_le(struct clocksource *c)
> +{
> +	return (cycle_t)le32_to_cpu(readl_relaxed(to_mmio_clksrc(c)->reg));
> +}
> +
>  cycle_t clocksource_mmio_readl_up(struct clocksource *c)
>  {
>  	return (cycle_t)readl_relaxed(to_mmio_clksrc(c)->reg);
>  }

So now we have three global functions which provide access to the mmio
clocksource. And one of them is always redundant for a given compile
time endianess. You can't be serious about this...

But ... wait, I've seen enough qualitee code from Fleascale in the
past 10 years, so you actually might be serious about it.

JFYI: You are trying to submit code to the public maintained codebase
of the Linux kernel, not to some random sh^H^Hgit repository inside of
Fleascale which accepts any random amount of crap. Can you see the
difference?

I can see it rather clearly.

Thanks,

	tglx



