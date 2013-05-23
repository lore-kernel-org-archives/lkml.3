Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759246Ab3EWO3m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 10:29:42 -0400
Received: from 13.mo4.mail-out.ovh.net ([178.33.251.8]:52079 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759217Ab3EWO3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 10:29:41 -0400
X-Greylist: delayed 14366 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 May 2013 10:29:41 EDT
Date: Thu, 23 May 2013 13:59:14 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Boris BREZILLON <b.brezillon@overkiz.com>,
        Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
X-Ovh-Mailout: 178.32.228.4 (mo4.mail-out.ovh.net)
Subject: Re: [PATCH 1/3] ARM: at91: move at91 aic driver to drivers/irqchip
Message-ID: <20130523115914.GB24476@game.jcrosoft.org>
References: <1369299909-10078-1-git-send-email-b.brezillon@overkiz.com>
 <1369299909-10078-2-git-send-email-b.brezillon@overkiz.com>
 <20130523101825.GL18614@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130523101825.GL18614@n2100.arm.linux.org.uk>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 401101842821458867
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrtddtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrtddtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11:18 Thu 23 May     , Russell King - ARM Linux wrote:
> On Thu, May 23, 2013 at 11:05:07AM +0200, Boris BREZILLON wrote:
> > Move arch/arm/mach-at91/irq.c to drivers/irqchip/irq-at91.c.
> > Move arch/arm/mach-at91/at91_aic.h to
> > arch/arm/mach-at91/include/mach/at91_aic.h to avoid ugly reference
> > to header file :
> > #include "../../arch/arm/mach-at91/at91_aic.h"
> 
> The right way to do this is to move the definitions which should only
> be used by arch/arm/mach-at91/irq.c to that file or a header file along
> side that file, and find a place in include/linux for the remainder.
> 
> I notice arch/arm/mach-at91/pm.c makes use of some of the register
> definitions:
> 
>         at91_irq_suspend();
> 
>         pr_debug("AT91: PM - wake mask %08x, pm state %d\n",
>                         /* remember all the always-wake irqs */
>                         (at91_pmc_read(AT91_PMC_PCSR)
>                                         | (1 << AT91_ID_FIQ)
>                                         | (1 << AT91_ID_SYS)
>                                         | (at91_extern_irq))
>                                 & at91_aic_read(AT91_AIC_IMR),
>                         state);
> 
> at91_irq_suspend() is in arch/arm/mach-at91/irq.c already, so there's no
> reason that fragment can't be moved there.
> 
> That leaves: at91_aic_handle_irq, at91_aic5_handle_irq, NR_AIC_IRQS and
> NR_AIC5_IRQS, which if you did patch 3 first, would leave you with just
> the NR_.*_IRQS definitions to find a home for.

Boris please update as this

Best Regards,
J.
