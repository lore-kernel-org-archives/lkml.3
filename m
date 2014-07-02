Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224AbaGBLRp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 07:17:45 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:34952 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753069AbaGBLRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 07:17:43 -0400
Date: Wed, 2 Jul 2014 12:17:48 +0100
From: Will Deacon <will.deacon@arm.com>
To: Liviu Dudau <Liviu.Dudau@arm.com>
Cc: linux-pci <linux-pci@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Arnd Bergmann <arnd@arndb.de>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sinan Kaya <okaya@codeaurora.org>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Device Tree ML <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v8 7/9] pci: of: Parse and map the IRQ when adding the
 PCI device.
Message-ID: <20140702111748.GJ18731@arm.com>
References: <1404240214-9804-1-git-send-email-Liviu.Dudau@arm.com>
 <1404240214-9804-8-git-send-email-Liviu.Dudau@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404240214-9804-8-git-send-email-Liviu.Dudau@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2014 at 07:43:32PM +0100, Liviu Dudau wrote:
> Enhance the default implementation of pcibios_add_device() to
> parse and map the IRQ of the device if a DT binding is available.
> 
> Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
> ---
>  drivers/pci/pci.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index 63a54a3..8e65dc3 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -17,6 +17,7 @@
>  #include <linux/spinlock.h>
>  #include <linux/string.h>
>  #include <linux/log2.h>
> +#include <linux/of_pci.h>
>  #include <linux/pci-aspm.h>
>  #include <linux/pm_wakeup.h>
>  #include <linux/interrupt.h>
> @@ -1453,6 +1454,9 @@ EXPORT_SYMBOL(pcim_pin_device);
>   */
>  int __weak pcibios_add_device(struct pci_dev *dev)
>  {
> +#ifdef CONFIG_OF
> +	dev->irq = of_irq_parse_and_map_pci(dev, 0, 0);
> +#endif

You could avoid the #ifdef by only assigning dev->irq if
of_irq_parse_and_map_pci returned something > 0.

Will
