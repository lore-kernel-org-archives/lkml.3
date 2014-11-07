Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232AbaKGM2E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 07:28:04 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:18427 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325AbaKGM17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 07:27:59 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18wTS5nWzr9sPEpRgKSG1ncszjNPJnR5RQ=
X-DKIM: OpenDKIM Filter v2.0.1 titan A0F8261441E
Date: Fri, 7 Nov 2014 07:27:45 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Kevin Cernekee <cernekee@gmail.com>
Cc: tglx@linutronix.de, linux-sh@vger.kernel.org, arnd@arndb.de,
        f.fainelli@gmail.com, ralf@linux-mips.org,
        sergei.shtylyov@cogentembedded.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, mbizon@freebox.fr, jogo@openwrt.org,
        linux-mips@linux-mips.org
Subject: Re: [PATCH V4 00/14] genirq endian fixes; bcm7120/brcmstb IRQ
 updates
Message-ID: <20141107122745.GJ3698@titan.lakedaemon.net>
References: <1415342669-30640-1-git-send-email-cernekee@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415342669-30640-1-git-send-email-cernekee@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

On Thu, Nov 06, 2014 at 10:44:15PM -0800, Kevin Cernekee wrote:
> V3->V4:
> 
>  - Fix buildbot bisectability warning on patch 02/14 (missing include)

Dammit.  :(  Even if I had created a topic branch for this series, I
still would have put the genirq changes in /core, then based a brcm
branch off of that.

I'm inclined to think I should just drop v3 and apply v4, as a revert
commit wouldn't solve the bisectability issue.

thoughts?

thx,

Jason.

> 
>  - Add kernel-doc text for the new reg_{readl,writel} struct members and
>    IRQ_GC_BE_IO flag
> 
> 
> Kevin Cernekee (14):
>   sh: Eliminate unused irq_reg_{readl,writel} accessors
>   genirq: Generic chip: Change irq_reg_{readl,writel} arguments
>   genirq: Generic chip: Allow irqchip drivers to override
>     irq_reg_{readl,writel}
>   genirq: Generic chip: Add big endian I/O accessors
>   irqchip: brcmstb-l2: Eliminate dependency on ARM code
>   irqchip: bcm7120-l2: Eliminate bad IRQ check
>   irqchip: bcm7120-l2, brcmstb-l2: Remove ARM Kconfig dependency
>   irqchip: bcm7120-l2: Make sure all register accesses use base+offset
>   irqchip: bcm7120-l2: Fix missing nibble in gc->unused mask
>   irqchip: bcm7120-l2: Use gc->mask_cache to simplify suspend/resume
>     functions
>   irqchip: bcm7120-l2: Extend driver to support 64+ bit controllers
>   irqchip: bcm7120-l2: Decouple driver from brcmstb-l2
>   irqchip: bcm7120-l2: Convert driver to use irq_reg_{readl,writel}
>   irqchip: brcmstb-l2: Convert driver to use irq_reg_{readl,writel}
> 
>  .../interrupt-controller/brcm,bcm7120-l2-intc.txt  |  26 ++-
>  arch/arm/mach-bcm/Kconfig                          |   1 +
>  arch/sh/boards/mach-se/7343/irq.c                  |   3 -
>  arch/sh/boards/mach-se/7722/irq.c                  |   3 -
>  drivers/irqchip/Kconfig                            |   6 +-
>  drivers/irqchip/Makefile                           |   4 +-
>  drivers/irqchip/irq-atmel-aic.c                    |  40 ++---
>  drivers/irqchip/irq-atmel-aic5.c                   |  65 ++++----
>  drivers/irqchip/irq-bcm7120-l2.c                   | 174 +++++++++++++--------
>  drivers/irqchip/irq-brcmstb-l2.c                   |  41 +++--
>  drivers/irqchip/irq-sunxi-nmi.c                    |   4 +-
>  drivers/irqchip/irq-tb10x.c                        |   4 +-
>  include/linux/irq.h                                |  32 +++-
>  kernel/irq/generic-chip.c                          |  36 +++--
>  14 files changed, 263 insertions(+), 176 deletions(-)
> 
> -- 
> 2.1.1
> 
