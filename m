Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933349AbaCRUzo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 16:55:44 -0400
Received: from www.linutronix.de ([62.245.132.108]:57092 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933122AbaCRUzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 16:55:41 -0400
Date: Tue, 18 Mar 2014 21:55:50 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
cc: Jason Cooper <jason@lakedaemon.net>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 5/5] irqchip: armanda: Sanitize set_irq_affinity()
In-Reply-To: <53285303.8000305@free-electrons.com>
Message-ID: <alpine.DEB.2.02.1403182153330.18573@ionos.tec.linutronix.de>
References: <20140304202425.102779779@linutronix.de> <20140304203101.088889302@linutronix.de> <20140306190531.GF1872@titan.lakedaemon.net> <5319ED86.2050707@free-electrons.com> <alpine.DEB.2.02.1403071816340.18573@ionos.tec.linutronix.de>
 <53285303.8000305@free-electrons.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Mar 2014, Gregory CLEMENT wrote:
> On 07/03/2014 18:17, Thomas Gleixner wrote:
> > It might be the readback of the routing register. I don't have the
> > datasheet of this.
> 
> Sorry for the delay, I was on vacation without the hardware to test it.
> 
> Indeed it was the readback of the routing register. (Unfortunately the
> datasheet was not yet publicly available :(  ). In your patch by replacing
> the line:
> 
> writel(mask, main_int_base + ARMADA_370_XP_INT_SOURCE_CTL(hwirq));
> 
> by the following ones:
> 
> reg = readl(main_int_base + ARMADA_370_XP_INT_SOURCE_CTL(hwirq));
> reg = (reg & (~ARMADA_370_XP_INT_SOURCE_CPU_MASK)) | mask;
> writel(reg, main_int_base + ARMADA_370_XP_INT_SOURCE_CTL(hwirq));
> 
> with
> #define ARMADA_370_XP_INT_SOURCE_CPU_MASK	0xF
> 
> Then it worked.
> 
> About masking with the online CPU in the original code, the purpose
> was to allow sharing the SoC with an other OS by doing AMP. This feature
> is part of the Marvell version of the kernel.
> The idea was to bring this latter in the vanilla kernel, but I am not sure
> that all the part needed for AMP are acceptable for mainline. So I can add
> it back later when we will need it.

Right.

So are you ok with that patch (including your change) ? If you send me
tested/acked-by i'll route it for 3.15

Thanks,

	tglx
