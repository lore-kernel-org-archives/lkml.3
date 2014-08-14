Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755076AbaHNO6T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 10:58:19 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:46381 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526AbaHNO6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 10:58:17 -0400
Date: Thu, 14 Aug 2014 22:58:04 +0800
From: Wei Yang <weiyang@linux.vnet.ibm.com>
To: Liviu Dudau <Liviu.Dudau@arm.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sinan Kaya <okaya@codeaurora.org>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        linux-pci <linux-pci@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Device Tree ML <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v9 02/12] PCI: OF: Parse and map the IRQ when adding the
 PCI device.
Message-ID: <20140814145804.GA5586@richard>
Reply-To: Wei Yang <weiyang@linux.vnet.ibm.com>
References: <1407860725-25202-1-git-send-email-Liviu.Dudau@arm.com>
 <1407860725-25202-3-git-send-email-Liviu.Dudau@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407860725-25202-3-git-send-email-Liviu.Dudau@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14081414-5564-0000-0000-000000C68005
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2014 at 05:25:15PM +0100, Liviu Dudau wrote:
>Enhance the default implementation of pcibios_add_device() to
>parse and map the IRQ of the device if a DT binding is available.
>
>Cc: Bjorn Helgaas <bhelgaas@google.com>
>Cc: Grant Likely <grant.likely@linaro.org>
>Cc: Rob Herring <robh+dt@kernel.org>
>Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
>---
> drivers/pci/pci.c | 3 +++
> 1 file changed, 3 insertions(+)
>
>diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
>index 1c8592b..29d1775 100644
>--- a/drivers/pci/pci.c
>+++ b/drivers/pci/pci.c
>@@ -17,6 +17,7 @@
> #include <linux/spinlock.h>
> #include <linux/string.h>
> #include <linux/log2.h>
>+#include <linux/of_pci.h>
> #include <linux/pci-aspm.h>
> #include <linux/pm_wakeup.h>
> #include <linux/interrupt.h>
>@@ -1453,6 +1454,8 @@ EXPORT_SYMBOL(pcim_pin_device);
>  */
> int __weak pcibios_add_device(struct pci_dev *dev)
> {
>+	dev->irq = of_irq_parse_and_map_pci(dev, 0, 0);
>+
> 	return 0;
> }

Liviu,

For this, my suggestion is to add arch dependent function to setup the irq
line for pci devices. I can't find an obvious reason this won't work on other
archs, but maybe this will hurt some of them?

>
>-- 
>2.0.4
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-pci" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Richard Yang
Help you, Help me

