Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965777AbaFRJPk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 05:15:40 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:40071 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964994AbaFRJPh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 05:15:37 -0400
Message-ID: <53A15879.7030302@ti.com>
Date: Wed, 18 Jun 2014 14:44:33 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>,
        "jg1.han@samsung.com" <jg1.han@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>
CC: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>, "tony@atomide.com" <tony@atomide.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Mohit Kumar <mohit.kumar@st.com>,
        Marek Vasut <marex@denx.de>
Subject: Re: [PATCH v2 03/18] PCI: designware: Configuration space should
 be specified in 'reg'
References: <1401345500-20188-1-git-send-email-kishon@ti.com> <1401345500-20188-4-git-send-email-kishon@ti.com> <53876116.90504@ti.com> <3E54258959B69E4282D79E01AB1F32B70477D2A4@DFLE11.ent.ti.com>
In-Reply-To: <3E54258959B69E4282D79E01AB1F32B70477D2A4@DFLE11.ent.ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Friday 30 May 2014 07:45 PM, Karicheri, Muralidharan wrote:
>> -----Original Message-----
>> From: Murali Karicheri [mailto:m-karicheri2@ti.com]
>> Sent: Thursday, May 29, 2014 12:32 PM
>> To: ABRAHAM, KISHON VIJAY
>> Cc: devicetree@vger.kernel.org; linux-doc@vger.kernel.org; linux-arm-
>> kernel@lists.infradead.org; linux-omap@vger.kernel.org; linux-pci@vger.kernel.org; linux-
>> kernel@vger.kernel.org; arnd@arndb.de; tony@atomide.com; jg1.han@samsung.com;
>> Jason Gunthorpe; Bjorn Helgaas; Mohit Kumar; Marek Vasut
>> Subject: Re: [PATCH v2 03/18] PCI: designware: Configuration space should be specified
>> in 'reg'
>>
>> On 5/29/2014 2:38 AM, ABRAHAM, KISHON VIJAY wrote:
>>> The configuration address space has so far been specified in *ranges*,
>>> however it should be specified in *reg* making it a platform MEM resource.
>>> Hence used 'platform_get_resource_*' API to get configuration address
>>> space in the designware driver.
>>>
>>> Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
>>> Cc: Bjorn Helgaas <bhelgaas@google.com>
>>> Cc: Mohit Kumar <mohit.kumar@st.com>
>>> Cc: Jingoo Han <jg1.han@samsung.com>
>>> Cc: Marek Vasut <marex@denx.de>
>>> Cc: Arnd Bergmann <arnd@arndb.de>
>>> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
>>> ---
>>>   .../devicetree/bindings/pci/designware-pcie.txt    |    1 +
>>>   drivers/pci/host/pcie-designware.c                 |   17 +++++++++++++++--
>>>   2 files changed, 16 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/Documentation/devicetree/bindings/pci/designware-pcie.txt
>>> b/Documentation/devicetree/bindings/pci/designware-pcie.txt
>>> index d6fae13..8314360 100644
>>> --- a/Documentation/devicetree/bindings/pci/designware-pcie.txt
>>> +++ b/Documentation/devicetree/bindings/pci/designware-pcie.txt
>>> @@ -6,6 +6,7 @@ Required properties:
>>>   	as "samsung,exynos5440-pcie" or "fsl,imx6q-pcie".
>>>   - reg: base addresses and lengths of the pcie controller,
>>>   	the phy controller, additional register for the phy controller.
>>> +	The configuration address space should also be specified here.
>> Kishon,
>>
>> I am working on the Keystone PCI driver for which v1 is already posted.
>> Want to clarify
>> following.
>> 1. Original text for reg states "base addresses and lengths of the pcie controller,
>>         the phy controller, additional register for the phy controller"
>> and you added
>>         "The configuration address space should also be specified here"
>>
>>    and the code below added resource name "config"
>>
>> Does PCI designware follow some convention? Does it mean after applying this patch
>> config name is mandatory or optional? Below code you are not returning error. Can you or
>> author of PCI designware clarify what is expected to be present as mandatory and what is
>> optional.
>>
>> Does config refers to RC's config space or EP's config space or both?
>> The code below divide
>> the size by 2. So it appears to be RC's + EP's config space. Please clarify.
>>
>>>   - interrupts: interrupt values for level interrupt,
>>>   	pulse interrupt, special interrupt.
>>>   - clocks: from common clock binding: handle to pci clock.
>>> diff --git a/drivers/pci/host/pcie-designware.c
>>> b/drivers/pci/host/pcie-designware.c
>>> index c4e3732..603b386 100644
>>> --- a/drivers/pci/host/pcie-designware.c
>>> +++ b/drivers/pci/host/pcie-designware.c
>>> @@ -20,6 +20,7 @@
>>>   #include <linux/of_pci.h>
>>>   #include <linux/pci.h>
>>>   #include <linux/pci_regs.h>
>>> +#include <linux/platform_device.h>
>>>   #include <linux/types.h>
>>>
>>>   #include "pcie-designware.h"
>>> @@ -392,11 +393,23 @@ static const struct irq_domain_ops msi_domain_ops = {
>>>   int __init dw_pcie_host_init(struct pcie_port *pp)
>>>   {
>>>   	struct device_node *np = pp->dev->of_node;
>>> +	struct platform_device *pdev = to_platform_device(pp->dev);
>>>   	struct of_pci_range range;
>>>   	struct of_pci_range_parser parser;
>>> +	struct resource *cfg_res;
>>>   	u32 val;
>>>   	int i;
>>>
>>> +	cfg_res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "config");
>>> +	if (cfg_res) {
>>> +		pp->config.cfg0_size = resource_size(cfg_res)/2;
>>> +		pp->config.cfg1_size = resource_size(cfg_res)/2;
>>> +		pp->cfg0_base = cfg_res->start;
>>> +		pp->cfg1_base = cfg_res->start + pp->config.cfg0_size;
>>> +	} else {
>>> +		dev_err(pp->dev, "missing *config* reg space\n");
>> This should return error -EINVAL.

Just read the other thread and Grant Likely suggested the host controller
driver should be backward compatible [1]. So we can't return -EINVAL here.
So I'd assume this patch is fine as is? Arnd? Jingoo?

[1] -> https://lkml.org/lkml/2014/6/3/124

Thanks
Kishon
