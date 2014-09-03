Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163AbaICKit (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 06:38:49 -0400
Received: from www.linutronix.de ([62.245.132.108]:43267 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755690AbaICKir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 06:38:47 -0400
Date: Wed, 3 Sep 2014 12:38:43 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Xiubo Li <Li.Xiubo@freescale.com>
cc: daniel.lezcano@linaro.org, dongsheng.wang@freescale.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] Clocksource: Flextimer: Use internal clocksource
 read API.
In-Reply-To: <1409031951-39021-3-git-send-email-Li.Xiubo@freescale.com>
Message-ID: <alpine.DEB.2.10.1409031236450.3333@nanos>
References: <1409031951-39021-1-git-send-email-Li.Xiubo@freescale.com> <1409031951-39021-3-git-send-email-Li.Xiubo@freescale.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Aug 2014, Xiubo Li wrote:

> Since the Flextimer device will be implemented in BE mode on
> LS1 SoC, and in LE mode on Vybrid, LS2 SoCs, so here we need
> the endianness judgment before doing the mmio.

Brilliant. So for every clocksource read you take a conditional.
 
> @@ -238,7 +243,7 @@ static int __init ftm_clocksource_init(unsigned long freq)
>  	sched_clock_register(ftm_read_sched_clock, 16, freq / (1 << priv->ps));
>  	err = clocksource_mmio_init(priv->clksrc_base + FTM_CNT, "fsl-ftm",
>  				    freq / (1 << priv->ps), 300, 16,
> -				    clocksource_mmio_readl_up);
> +				    ftm_clocksource_read_up);

What's wrong with having endianess aware clocksource_mmio functions
and make the decision at init time?

Thanks

	tglx
