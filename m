Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751560AbaGMXOs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 19:14:48 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:28324 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975AbaGMXOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 19:14:42 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19+JAyP6CEF4i4QWLpZo5VWwSj0t4Tnv7k=
X-DKIM: OpenDKIM Filter v2.0.1 titan 2CF215AA0CA
Date: Sun, 13 Jul 2014 19:14:31 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: suravee.suthikulpanit@amd.com
Cc: marc.zyngier@arm.com, mark.rutland@arm.com, pawel.moll@arm.com,
        Catalin.Marinas@arm.com, Will.Deacon@arm.com, tglx@linutronix.de,
        Harish.Kasiviswanathan@amd.com, linux-arm-kernel@lists.infradead.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH 0/4 V3] irqchip: gic: Introduce ARM GICv2m MSI(-X)
 support
Message-ID: <20140713231431.GM13108@titan.lakedaemon.net>
References: <1404947104-21345-1-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404947104-21345-1-git-send-email-suravee.suthikulpanit@amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suravee,

On Wed, Jul 09, 2014 at 06:05:00PM -0500, suravee.suthikulpanit@amd.com wrote:
> From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
> 
> This patch set introduces support for MSI(-X) in GICv2m specification,
> which is implemented in some variation of GIC400.
> 
> This depends on and has been tested with the V7 of"Add support for PCI in AArch64"
> (https://lkml.org/lkml/2014/3/14/320).

Grrr.  I mis-spoke against your v1 of this series.  There are more
changes to irq-gic.c than I originally thought in this series.

Additionally, we have a lot of other significant changes to that driver
as well this cycle.  It would be really helpful if I could take patches
1-3 through irqchip/gic.  I can Ack #4 with the Subject change, and the
branch it lands in can depend on irqchip/gic, no problem there.

My main concern is your statement above and your answer to my inquiry
against v1.

Right now, I'm only concerned about breaking the build.  Can I take 1-3?
Or, do we need to wait until aarch64 PCI lands in mainline?

If I can take them, I'll fix up the commit log of the one patch when I
apply them.

thx,

Jason.

> Changes in V3:
>     * Rebase to git://git.infradead.org/users/jcooper/linux.git irqchip/gic
>       (per Jason Cooper request)
>     * Misc fix/clean up per Mark Rutland comments
>     * Minor Clean up in the driver/irqchip/irq-gic-v2m.c: alloc_msi_irqs()
>     * Patch 4 is new to the series:
>         * Add ARM64-specific version arch_setup_msi_irqs() to allow support
>           for Multiple MSI.
>         * Add support for Multiple MSI for GICv2m.
> 
> Suravee Suthikulpanit (4):
>   irqchip: gic: Add binding probe for ARM GIC400
>   irqchip: gic: Restructuring ARM GIC code
>   irqchip: gic: Add supports for ARM GICv2m MSI(-X)
>   irqchip: gicv2m: Add support for multiple MSI for ARM64 GICv2m
> 
>  Documentation/devicetree/bindings/arm/gic.txt |  20 +-
>  arch/arm64/Kconfig                            |   1 +
>  arch/arm64/include/asm/msi.h                  |  15 ++
>  arch/arm64/kernel/Makefile                    |   1 +
>  arch/arm64/kernel/msi.c                       |  57 +++++
>  drivers/irqchip/Kconfig                       |   7 +
>  drivers/irqchip/Makefile                      |   1 +
>  drivers/irqchip/irq-gic-v2m.c                 | 331 ++++++++++++++++++++++++++
>  drivers/irqchip/irq-gic-v2m.h                 |  13 +
>  drivers/irqchip/irq-gic.c                     |  90 ++++---
>  drivers/irqchip/irq-gic.h                     |  67 ++++++
>  11 files changed, 562 insertions(+), 41 deletions(-)
>  create mode 100644 arch/arm64/include/asm/msi.h
>  create mode 100644 arch/arm64/kernel/msi.c
>  create mode 100644 drivers/irqchip/irq-gic-v2m.c
>  create mode 100644 drivers/irqchip/irq-gic-v2m.h
>  create mode 100644 drivers/irqchip/irq-gic.h
> 
> -- 
> 1.9.0
> 
