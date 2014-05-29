Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756269AbaE2HM2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 03:12:28 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:36436 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752460AbaE2HMZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 03:12:25 -0400
From: Mohit KUMAR DCG <Mohit.KUMAR@st.com>
To: Kishon Vijay Abraham I <kishon@ti.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "arnd@arndb.de" <arnd@arndb.de>, "tony@atomide.com" <tony@atomide.com>,
        "jg1.han@samsung.com" <jg1.han@samsung.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Marek Vasut <marex@denx.de>
Date: Thu, 29 May 2014 15:11:08 +0800
Subject: RE: [PATCH v2 03/18] PCI: designware: Configuration space should be
 specified in 'reg'
Thread-Topic: [PATCH v2 03/18] PCI: designware: Configuration space should
 be specified in 'reg'
Thread-Index: Ac97CMnREtH+0ey4Sd2ECcii+AlXSQAArwqQ
Message-ID: <2CC2A0A4A178534D93D5159BF3BCB6619B94AD3904@EAPEX1MAIL1.st.com>
References: <1401345500-20188-1-git-send-email-kishon@ti.com>
 <1401345500-20188-4-git-send-email-kishon@ti.com>
In-Reply-To: <1401345500-20188-4-git-send-email-kishon@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-05-29_02:2014-05-28,2014-05-29,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Kishon,

> -----Original Message-----
> From: Kishon Vijay Abraham I [mailto:kishon@ti.com]
> Sent: Thursday, May 29, 2014 12:08 PM
> To: devicetree@vger.kernel.org; linux-doc@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org; linux-omap@vger.kernel.org; linux-
> pci@vger.kernel.org; linux-kernel@vger.kernel.org
> Cc: arnd@arndb.de; tony@atomide.com; jg1.han@samsung.com;
> kishon@ti.com; Jason Gunthorpe; Bjorn Helgaas; Mohit KUMAR DCG; Marek
> Vasut
> Subject: [PATCH v2 03/18] PCI: designware: Configuration space should be
> specified in 'reg'
> 
> The configuration address space has so far been specified in *ranges*,
> however it should be specified in *reg* making it a platform MEM resource.
> Hence used 'platform_get_resource_*' API to get configuration address
> space in the designware driver.
> 
> Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: Mohit Kumar <mohit.kumar@st.com>
> Cc: Jingoo Han <jg1.han@samsung.com>
> Cc: Marek Vasut <marex@denx.de>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
>  .../devicetree/bindings/pci/designware-pcie.txt    |    1 +
>  drivers/pci/host/pcie-designware.c                 |   17 +++++++++++++++--
>  2 files changed, 16 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/pci/designware-pcie.txt
> b/Documentation/devicetree/bindings/pci/designware-pcie.txt
> index d6fae13..8314360 100644
> --- a/Documentation/devicetree/bindings/pci/designware-pcie.txt
> +++ b/Documentation/devicetree/bindings/pci/designware-pcie.txt
> @@ -6,6 +6,7 @@ Required properties:
>  	as "samsung,exynos5440-pcie" or "fsl,imx6q-pcie".
>  - reg: base addresses and lengths of the pcie controller,
>  	the phy controller, additional register for the phy controller.
> +	The configuration address space should also be specified here.
>  - interrupts: interrupt values for level interrupt,
>  	pulse interrupt, special interrupt.
>  - clocks: from common clock binding: handle to pci clock.
> diff --git a/drivers/pci/host/pcie-designware.c b/drivers/pci/host/pcie-
> designware.c
> index c4e3732..603b386 100644
> --- a/drivers/pci/host/pcie-designware.c
> +++ b/drivers/pci/host/pcie-designware.c
> @@ -20,6 +20,7 @@
>  #include <linux/of_pci.h>
>  #include <linux/pci.h>
>  #include <linux/pci_regs.h>
> +#include <linux/platform_device.h>
>  #include <linux/types.h>
> 
>  #include "pcie-designware.h"
> @@ -392,11 +393,23 @@ static const struct irq_domain_ops
> msi_domain_ops = {  int __init dw_pcie_host_init(struct pcie_port *pp)  {
>  	struct device_node *np = pp->dev->of_node;
> +	struct platform_device *pdev = to_platform_device(pp->dev);
>  	struct of_pci_range range;
>  	struct of_pci_range_parser parser;
> +	struct resource *cfg_res;
>  	u32 val;
>  	int i;
> 
> +	cfg_res = platform_get_resource_byname(pdev,
> IORESOURCE_MEM, "config");
> +	if (cfg_res) {
> +		pp->config.cfg0_size = resource_size(cfg_res)/2;
> +		pp->config.cfg1_size = resource_size(cfg_res)/2;
> +		pp->cfg0_base = cfg_res->start;
> +		pp->cfg1_base = cfg_res->start + pp->config.cfg0_size;
> +	} else {
> +		dev_err(pp->dev, "missing *config* reg space\n");
> +	}
> +
>  	if (of_pci_range_parser_init(&parser, np)) {
>  		dev_err(pp->dev, "missing ranges property\n");
>  		return -EINVAL;
> @@ -429,6 +442,8 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
>  			of_pci_range_to_resource(&range, np, &pp->cfg);
>  			pp->config.cfg0_size = resource_size(&pp->cfg)/2;
>  			pp->config.cfg1_size = resource_size(&pp->cfg)/2;
> +			pp->cfg0_base = pp->cfg.start;
> +			pp->cfg1_base = pp->cfg.start + pp-
> >config.cfg0_size;

- As you are getting cfg address space as MEM resource, so remove above code that
 gets the configuration space from dt range. Also correct dt for pcie cfg space for the platforms
 based on this driver.

Otherwise looks fine to me.

Thanks
Mohit

>  		}
>  	}
> 
> @@ -441,8 +456,6 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
>  		}
>  	}
> 
> -	pp->cfg0_base = pp->cfg.start;
> -	pp->cfg1_base = pp->cfg.start + pp->config.cfg0_size;
>  	pp->mem_base = pp->mem.start;
> 
>  	pp->va_cfg0_base = devm_ioremap(pp->dev, pp->cfg0_base,
> --
> 1.7.9.5

