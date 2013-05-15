Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756345Ab3EOBtJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 21:49:09 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:59268 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756223Ab3EOBtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 21:49:06 -0400
Date: Wed, 15 May 2013 10:49:01 +0900
From: Simon Horman <horms@verge.net.au>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Michal Simek <michal.simek@xilinx.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jamie Iles <jamie@jamieiles.com>, Magnus Damm <magnus.damm@gmail.com>,
        Christian Daudt <csd@broadcom.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        David Brown <davidb@codeaurora.org>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Shawn Guo <shawn.guo@linaro.org>, Barry Song <baohua.song@csr.com>,
        Tony Prisk <linux@prisktech.co.nz>,
        linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH 05/20] ARM: shmobile: ape6evm: Remove init_irq
 declaration in machine description
Message-ID: <20130515014901.GR12246@verge.net.au>
References: <1368545933-7430-1-git-send-email-maxime.ripard@free-electrons.com>
 <1368545933-7430-6-git-send-email-maxime.ripard@free-electrons.com>
 <20130515005907.GD12246@verge.net.au>
 <20130515014604.GK12246@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130515014604.GK12246@verge.net.au>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 15, 2013 at 10:46:04AM +0900, Simon Horman wrote:
> On Wed, May 15, 2013 at 09:59:07AM +0900, Simon Horman wrote:
> > On Tue, May 14, 2013 at 05:38:38PM +0200, Maxime Ripard wrote:
> > > Commit ebafed7a ("ARM: irq: Call irqchip_init if no init_irq function is
> > > specified") removed the need to explictly setup the init_irq field in
> > > the machine description when using only irqchip_init. Remove that
> > > declaration for shmobile as well.
> > > 
> > > Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> > > ---
> > >  arch/arm/mach-shmobile/board-ape6evm.c | 2 --
> > >  1 file changed, 2 deletions(-)
> > > 
> > > diff --git a/arch/arm/mach-shmobile/board-ape6evm.c b/arch/arm/mach-shmobile/board-ape6evm.c
> > > index 55b8c9f..8dfbdba 100644
> > > --- a/arch/arm/mach-shmobile/board-ape6evm.c
> > > +++ b/arch/arm/mach-shmobile/board-ape6evm.c
> > > @@ -20,7 +20,6 @@
> > >  
> > >  #include <linux/gpio.h>
> > >  #include <linux/interrupt.h>
> > > -#include <linux/irqchip.h>
> > >  #include <linux/kernel.h>
> > >  #include <linux/pinctrl/machine.h>
> > >  #include <linux/platform_device.h>
> > > @@ -87,7 +86,6 @@ static const char *ape6evm_boards_compat_dt[] __initdata = {
> > >  };
> > >  
> > >  DT_MACHINE_START(APE6EVM_DT, "ape6evm")
> > > -	.init_irq	= irqchip_init,
> > >  	.init_time	= shmobile_timer_init,
> > >  	.init_machine	= ape6evm_add_standard_devices,
> > >  	.dt_compat	= ape6evm_boards_compat_dt,
> > 
> > Signed-off-by: Simon Horman <horms+renesas@verge.net.au>
> 
> Sorry, what I should have said is:
> 
> Queued up for v3.11 in the boards-spe6evm branch of my renesas tree

s/spe6evm/ape6evm/

> on kernel.org. It is included in the renesas-next-20130515 tag of
> that tree and should appear in linux-next in the not to distant future.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sh" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
