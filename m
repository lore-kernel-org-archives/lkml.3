Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956AbaE3OP7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 10:15:59 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:50864 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755135AbaE3OP4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 10:15:56 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>,
        "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
CC: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>, "tony@atomide.com" <tony@atomide.com>,
        "jg1.han@samsung.com" <jg1.han@samsung.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Mohit Kumar <mohit.kumar@st.com>,
        "Marek Vasut" <marex@denx.de>
Subject: RE: [PATCH v2 03/18] PCI: designware: Configuration space should be
 specified in 'reg'
Thread-Topic: [PATCH v2 03/18] PCI: designware: Configuration space should
 be specified in 'reg'
Thread-Index: AQHPewm2FSpUludLU0uP4h3ZfCi97ZtX0dEAgAFbLYA=
Date: Fri, 30 May 2014 14:15:13 +0000
Message-ID: <3E54258959B69E4282D79E01AB1F32B70477D2A4@DFLE11.ent.ti.com>
References: <1401345500-20188-1-git-send-email-kishon@ti.com>
 <1401345500-20188-4-git-send-email-kishon@ti.com> <53876116.90504@ti.com>
In-Reply-To: <53876116.90504@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.170.170.90]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Murali Karicheri [mailto:m-karicheri2@ti.com]
>Sent: Thursday, May 29, 2014 12:32 PM
>To: ABRAHAM, KISHON VIJAY
>Cc: devicetree@vger.kernel.org; linux-doc@vger.kernel.org; linux-arm-
>kernel@lists.infradead.org; linux-omap@vger.kernel.org; linux-pci@vger.kernel.org; linux-
>kernel@vger.kernel.org; arnd@arndb.de; tony@atomide.com; jg1.han@samsung.com;
>Jason Gunthorpe; Bjorn Helgaas; Mohit Kumar; Marek Vasut
>Subject: Re: [PATCH v2 03/18] PCI: designware: Configuration space should be specified
>in 'reg'
>
>On 5/29/2014 2:38 AM, ABRAHAM, KISHON VIJAY wrote:
>> The configuration address space has so far been specified in *ranges*,
>> however it should be specified in *reg* making it a platform MEM resource.
>> Hence used 'platform_get_resource_*' API to get configuration address
>> space in the designware driver.
>>
>> Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
>> Cc: Bjorn Helgaas <bhelgaas@google.com>
>> Cc: Mohit Kumar <mohit.kumar@st.com>
>> Cc: Jingoo Han <jg1.han@samsung.com>
>> Cc: Marek Vasut <marex@denx.de>
>> Cc: Arnd Bergmann <arnd@arndb.de>
>> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
>> ---
>>   .../devicetree/bindings/pci/designware-pcie.txt    |    1 +
>>   drivers/pci/host/pcie-designware.c                 |   17 +++++++++++++++--
>>   2 files changed, 16 insertions(+), 2 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/pci/designware-pcie.txt
>> b/Documentation/devicetree/bindings/pci/designware-pcie.txt
>> index d6fae13..8314360 100644
>> --- a/Documentation/devicetree/bindings/pci/designware-pcie.txt
>> +++ b/Documentation/devicetree/bindings/pci/designware-pcie.txt
>> @@ -6,6 +6,7 @@ Required properties:
>>   	as "samsung,exynos5440-pcie" or "fsl,imx6q-pcie".
>>   - reg: base addresses and lengths of the pcie controller,
>>   	the phy controller, additional register for the phy controller.
>> +	The configuration address space should also be specified here.
>Kishon,
>
>I am working on the Keystone PCI driver for which v1 is already posted.
>Want to clarify
>following.
>1. Original text for reg states "base addresses and lengths of the pcie controller,
>         the phy controller, additional register for the phy controller"
>and you added
>         "The configuration address space should also be specified here"
>
>    and the code below added resource name "config"
>
>Does PCI designware follow some convention? Does it mean after applying this patch
>config name is mandatory or optional? Below code you are not returning error. Can you or
>author of PCI designware clarify what is expected to be present as mandatory and what is
>optional.
>
>Does config refers to RC's config space or EP's config space or both?
>The code below divide
>the size by 2. So it appears to be RC's + EP's config space. Please clarify.
>
>>   - interrupts: interrupt values for level interrupt,
>>   	pulse interrupt, special interrupt.
>>   - clocks: from common clock binding: handle to pci clock.
>> diff --git a/drivers/pci/host/pcie-designware.c
>> b/drivers/pci/host/pcie-designware.c
>> index c4e3732..603b386 100644
>> --- a/drivers/pci/host/pcie-designware.c
>> +++ b/drivers/pci/host/pcie-designware.c
>> @@ -20,6 +20,7 @@
>>   #include <linux/of_pci.h>
>>   #include <linux/pci.h>
>>   #include <linux/pci_regs.h>
>> +#include <linux/platform_device.h>
>>   #include <linux/types.h>
>>
>>   #include "pcie-designware.h"
>> @@ -392,11 +393,23 @@ static const struct irq_domain_ops msi_domain_ops = {
>>   int __init dw_pcie_host_init(struct pcie_port *pp)
>>   {
>>   	struct device_node *np = pp->dev->of_node;
>> +	struct platform_device *pdev = to_platform_device(pp->dev);
>>   	struct of_pci_range range;
>>   	struct of_pci_range_parser parser;
>> +	struct resource *cfg_res;
>>   	u32 val;
>>   	int i;
>>
>> +	cfg_res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "config");
>> +	if (cfg_res) {
>> +		pp->config.cfg0_size = resource_size(cfg_res)/2;
>> +		pp->config.cfg1_size = resource_size(cfg_res)/2;
>> +		pp->cfg0_base = cfg_res->start;
>> +		pp->cfg1_base = cfg_res->start + pp->config.cfg0_size;
>> +	} else {
>> +		dev_err(pp->dev, "missing *config* reg space\n");
>This should return error -EINVAL.
>
>> +	}
>> +
>>   	if (of_pci_range_parser_init(&parser, np)) {
>>   		dev_err(pp->dev, "missing ranges property\n");
>>   		return -EINVAL;
>> @@ -429,6 +442,8 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
>>   			of_pci_range_to_resource(&range, np, &pp->cfg);
>>   			pp->config.cfg0_size = resource_size(&pp->cfg)/2;
>>   			pp->config.cfg1_size = resource_size(&pp->cfg)/2;
>> +			pp->cfg0_base = pp->cfg.start;
>> +			pp->cfg1_base = pp->cfg.start + pp->config.cfg0_size;
>>   		}
>>   	}
>>
>> @@ -441,8 +456,6 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
>>   		}
>>   	}
>>
>> -	pp->cfg0_base = pp->cfg.start;
>> -	pp->cfg1_base = pp->cfg.start + pp->config.cfg0_size;
>>   	pp->mem_base = pp->mem.start;
>>
>>   	pp->va_cfg0_base = devm_ioremap(pp->dev, pp->cfg0_base,
>BTW, Please also review my Keystone series so that we could discuss this topic in that
>context as well.

