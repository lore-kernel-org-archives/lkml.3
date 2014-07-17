Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757438AbaGQNNi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 09:13:38 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:19796 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757375AbaGQNNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 09:13:34 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18aN2jYhNufwGoc6EFeANOT7oBEQ3TZuPM=
X-DKIM: OpenDKIM Filter v2.0.1 titan 2D55E5AE2D4
Date: Thu, 17 Jul 2014 09:13:20 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: suravee.suthikulpanit@amd.com
Cc: marc.zyngier@arm.com, mark.rutland@arm.com, pawel.moll@arm.com,
        Catalin.Marinas@arm.com, Will.Deacon@arm.com, tglx@linutronix.de,
        Harish.Kasiviswanathan@amd.com, linux-arm-kernel@lists.infradead.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH 3/4 V3] irqchip: gic: Add supports for ARM GICv2m
 MSI(-X)
Message-ID: <20140717131320.GM13108@titan.lakedaemon.net>
References: <1404947104-21345-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1404947104-21345-4-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404947104-21345-4-git-send-email-suravee.suthikulpanit@amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2014 at 06:05:03PM -0500, suravee.suthikulpanit@amd.com wrote:
> From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
> 
> ARM GICv2m specification extends GICv2 to support MSI(-X) with
> a new set of register frames. This patch introduces support for
> the non-secure GICv2m register frame.
> 
> The driver currently matchs "arm,gic-400-plus" in device tree binding,
> which implements GICv2m.
> 
> The "msi-controller" keyword in ARM GIC devicetree binding is used to indentify
> GIC driver that it should enable MSI(-X) support, The region of GICv2m MSI
> register frame is specified using the register frame index 4 in the device tree.
> MSI support is optional.
> 
> Each GIC maintains an "msi_chip" structure. To discover the msi_chip,
> PCI host driver can do the following:
> 
>     struct device_node *gic_node = of_irq_find_parent(pdev->dev.of_node);
>     pcie_bus->msi_chip = of_pci_find_msi_chip_by_node(gic_node);
> 
> Cc: Mark Rutland <Mark.Rutland@arm.com>
> Cc: Marc Zyngier <Marc.Zyngier@arm.com>
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Catalin Marinas <Catalin.Marinas@arm.com>
> Cc: Will Deacon <Will.Deacon@arm.com>
> Signed-off-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
> ---
>  Documentation/devicetree/bindings/arm/gic.txt |  20 +-
>  arch/arm64/Kconfig                            |   1 +
>  drivers/irqchip/Kconfig                       |   7 +
>  drivers/irqchip/Makefile                      |   1 +
>  drivers/irqchip/irq-gic-v2m.c                 | 251 ++++++++++++++++++++++++++
>  drivers/irqchip/irq-gic-v2m.h                 |  13 ++
>  drivers/irqchip/irq-gic.c                     |  23 ++-
>  drivers/irqchip/irq-gic.h                     |  31 +++-
>  8 files changed, 334 insertions(+), 13 deletions(-)
>  create mode 100644 drivers/irqchip/irq-gic-v2m.c
>  create mode 100644 drivers/irqchip/irq-gic-v2m.h

Applied to irqchip/gic with some minor typos fixed in the commit
message.

thx,

Jason.
