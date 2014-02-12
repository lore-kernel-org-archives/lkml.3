Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778AbaBLPsl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 10:48:41 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:49015 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735AbaBLPsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 10:48:39 -0500
Date: Wed, 12 Feb 2014 15:48:15 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH 05/14] mfd: sec: Use consistent S2MPS11 RTC alarm
 interrupt indexes
Message-ID: <20140212154815.GB20026@lee--X1>
References: <1392123837-5517-1-git-send-email-k.kozlowski@samsung.com>
 <1392123837-5517-6-git-send-email-k.kozlowski@samsung.com>
 <20140212090746.GR15081@lee--X1>
 <1392197497.22265.8.camel@AMDC1943>
 <20140212100219.GX15081@lee--X1>
 <1392206769.22265.25.camel@AMDC1943>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1392206769.22265.25.camel@AMDC1943>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > > The S2MPS11 RTC has two alarms: alarm0 and alarm1 (corresponding
> > > > > interrupts are named similarly). Use consistent names for interrupts to
> > > > > limit possible errors.
> > > > > 
> > > > > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > > > > ---
> > > > >  drivers/mfd/sec-irq.c           |    8 ++++----
> > > > >  include/linux/mfd/samsung/irq.h |    4 ++--
> > > > >  2 files changed, 6 insertions(+), 6 deletions(-)
> > > > 
> > > > <snip>
> > > > 
> > > > >  #define S2MPS11_IRQ_RTC60S_MASK		(1 << 0)
> > > > >  #define S2MPS11_IRQ_RTCA1_MASK		(1 << 1)
> > > > > -#define S2MPS11_IRQ_RTCA2_MASK		(1 << 2)
> > > > > +#define S2MPS11_IRQ_RTCA0_MASK		(1 << 2)
> > > > 
> > > > This doesn't look correct to me.
> > > 
> > > It is just renaming RTCA2 to RTCA0 because there is no "alarm 2"
> > > registers. Actually the behavior of driver does not change (especially
> > > that there is no RTC driver for S2MPS11) but now it looks properly:
> > >  - set ALARM0 registers for RTCA0 interrupt,
> > >  - set ALARM1 registers for RTCA1 interrupt,
> > > 
> > > This patch is not essential.
> > 
> > I mean the logic.
> > 
> > If these masks are used for registers then I assume RTCA0 would be
> > BIT(1) amd RTCA1 would be BIT(2), but this patch swaps them round.
> 
> 
> Yes, one could assume that and in case of S5M8767 this is right (the
> order is proper)... but on S2MPS11/S2MPS14 this is reverted:
>  - BIT(0): RTC periodic 60s
>  - BIT(1): RTC Alarm 1
>  - BIT(2): RTC Alarm 0
> 
> The original code (BIT(1) for RTCA1 and BIT(2) for RTCA2) was wrong here
> and may lead to errors. I think that this was changed during mainstream
> process to match S5M8767. However some old internal driver sources for
> S2MPS11 have:
> #define S2MPS11_IRQ_RTCA2_MASK          (1 << 1)
> #define S2MPS11_IRQ_RTCA1_MASK          (1 << 2)

Okay, if you're happy that this is correct:
  Acked-by: Lee Jones <lee.jones@linaro.org>

> > > > >  #define S2MPS11_IRQ_SMPL_MASK		(1 << 3)
> > > > >  #define S2MPS11_IRQ_RTC1S_MASK		(1 << 4)
> > > > >  #define S2MPS11_IRQ_WTSR_MASK		(1 << 5)
> > > > 
> > > 
> > 
> 

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
