Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752182AbaJQKwm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 06:52:42 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53010 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878AbaJQKwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 06:52:41 -0400
Date: Fri, 17 Oct 2014 12:51:56 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Yifan Zhang <yifan.zhangm@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, mark.rutland@arm.com,
        lauraa@codeaurora.org, ganapatrao.kulkarni@caviumnetworks.com,
        robh@kernel.org, leif.lindholm@linaro.org, Yalin.Wang@sonymobile.com,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org, Yifan Zhang <zhangyf@marvell.com>
Subject: Re: [PATCH] arm64: mm: use macro instead of if judgement of ZONE_DMA
Message-ID: <20141017105156.GF29470@pengutronix.de>
References: <CAGZxSSRsYYNURnVB1fpGSTMA7WJMdy=Cmt1pj0Q=69ahHEsO1w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGZxSSRsYYNURnVB1fpGSTMA7WJMdy=Cmt1pj0Q=69ahHEsO1w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Oct 16, 2014 at 05:19:43PM +0800, Yifan Zhang wrote:
> @@ -82,10 +82,10 @@ static void __init zone_sizes_init(unsigned long
> min, unsigned long max)
> 
>         memset(zone_size, 0, sizeof(zone_size));
> 
> 
> 
>         /* 4GB maximum for 32-bit only capable devices */
> 
> -        if (IS_ENABLED(CONFIG_ZONE_DMA)) {
> 
> -                 max_dma = PFN_DOWN(max_zone_dma_phys());
> 
> -                 zone_size[ZONE_DMA] = max_dma - min;
> 
> -        }
> 
> +#ifdef CONFIG_ZONE_DMA
> 
> +       max_dma = PFN_DOWN(max_zone_dma_phys());
> 
> +       zone_size[ZONE_DMA] = max_dma - min;
> 
> +#endif
Apart from your patch being broken (probably by your MUA or MTA) usually
if (IS_ENABLED(...)) is preferred over #ifdef because it doesn't stand
out over the other program source.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
