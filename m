Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755620AbaIZNeP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 09:34:15 -0400
Received: from www.linutronix.de ([62.245.132.108]:40374 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755397AbaIZNeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 09:34:12 -0400
Date: Fri, 26 Sep 2014 15:34:08 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Xiubo Li <Li.Xiubo@freescale.com>
cc: daniel.lezcano@linaro.org, john.stultz@linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] clocksource: Add BE APIs support for clocksource
 counter reading.
In-Reply-To: <1411712529-35293-1-git-send-email-Li.Xiubo@freescale.com>
Message-ID: <alpine.DEB.2.11.1409261521340.4567@nanos>
References: <1411712529-35293-1-git-send-email-Li.Xiubo@freescale.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Sep 2014, Xiubo Li wrote:
> For now I just added  _be() support using ioread{16,32}be.
> And i have a check of the clocksource drivers, didn't find anyone
> using LE mode on one BE SoC, so _le() APIs is not needed.

Nonsense. The existing clocksource_mmio accessor function are
providing LE access independent of the CPU endianess. So we don't need
an _le() API simply because we have it already.
 
>  cycle_t clocksource_mmio_readl_up(struct clocksource *c)
>  {
> -	return (cycle_t)readl_relaxed(to_mmio_clksrc(c)->reg);
> +	return (cycle_t)ioread32(to_mmio_clksrc(c)->reg);

And how exactly is this change related to adding BE support?

Thanks,

	tglx
