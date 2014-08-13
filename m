Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931AbaHMNxH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 09:53:07 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:39548 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbaHMNxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 09:53:04 -0400
Date: Wed, 13 Aug 2014 06:53:02 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3] irqchip: gic: Allow gic_arch_extn hooks to call into
 scheduler
Message-ID: <20140813135300.GC32301@codeaurora.org>
References: <1407891264-4826-1-git-send-email-sboyd@codeaurora.org>
 <alpine.LFD.2.11.1408122205060.6061@knanqh.ubzr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.11.1408122205060.6061@knanqh.ubzr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12, Nicolas Pitre wrote:
> On Tue, 12 Aug 2014, Stephen Boyd wrote:
> > 
> > diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
> > index 7c131cf7cc13..c1dc65209899 100644
> > --- a/drivers/irqchip/irq-gic.c
> > +++ b/drivers/irqchip/irq-gic.c
> > @@ -81,6 +81,11 @@ static DEFINE_RAW_SPINLOCK(irq_controller_lock);
> >  #define NR_GIC_CPU_IF 8
> >  static u8 gic_cpu_map[NR_GIC_CPU_IF] __read_mostly;
> >  
> > +#ifdef CONFIG_BL_SWITCHER
> > +/* Synchronize switching CPU interface and sending SGIs */
> > +static DEFINE_RAW_SPINLOCK(gic_sgi_lock);
> 
> What about ...
> 
> #define sgi_map_lock(flags) raw_spin_lock_irqsave(&gic_sgi_lock, flags)
> #define sgi_map_unlock(flags) raw_spin_unlock_irqrestore(&gic_sgi_lock, 
> flags)
> #else sgi_map_lock(flags) (void)(flags)
> #define sgi_map_unlock(flags) (void)(flags)
> 
> That would avoid some #ifdefs in the main code.

Sure. v4 shortly.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
