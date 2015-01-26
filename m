Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757352AbbAZX3o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 18:29:44 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:38616 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754575AbbAZX3k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 18:29:40 -0500
Message-ID: <54C6CDB6.2080207@ti.com>
Date: Mon, 26 Jan 2015 18:28:54 -0500
From: Murali Karicheri <m-karicheri2@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <iommu@lists.linux-foundation.org>, Joerg Roedel <joro@8bytes.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Will Deacon <will.deacon@arm.com>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Subject: Re: [PATCH v4 5/6] PCI: update dma configuration from DT
References: <1422052359-12384-1-git-send-email-m-karicheri2@ti.com> <1422052359-12384-6-git-send-email-m-karicheri2@ti.com> <20150123232725.GV29776@google.com>
In-Reply-To: <20150123232725.GV29776@google.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2015 06:27 PM, Bjorn Helgaas wrote:
> On Fri, Jan 23, 2015 at 05:32:38PM -0500, Murali Karicheri wrote:
>> If there is a DT node available for the root bridge's parent device,
>> use the dma configuration from that device node. For example, keystone
>> PCI devices would require dma_pfn_offset to be set correctly in the
>> device structure of the pci device in order to have the correct dma mask.
>> The DT node will have dma-ranges defined for this. Also support using
>> the DT property dma-coherent to allow coherent DMA operation by the
>> PCI device.
>>
>> This patch use the new helper function of_pci_dma_configure() to update
>> the device dma configuration.
>>
>> Cc: Joerg Roedel<joro@8bytes.org>
>> Cc: Grant Likely<grant.likely@linaro.org>
>> Cc: Rob Herring<robh+dt@kernel.org>
>> Cc: Bjorn Helgaas<bhelgaas@google.com>
>> Cc: Will Deacon<will.deacon@arm.com>
>> Cc: Russell King<linux@arm.linux.org.uk>
>> Cc: Arnd Bergmann<arnd@arndb.de>
>> Cc: Suravee Suthikulpanit<Suravee.Suthikulpanit@amd.com>
>>
>> Signed-off-by: Murali Karicheri<m-karicheri2@ti.com>
>
> I assume this series will be merged via some non-PCI tree, so:

Not sure who will pick this. Since this is for PCI, will it be possible 
to apply this to arm-pci/next?

>
> Acked-by: Bjorn Helgaas<bhelgaas@google.com>

I will add your ack for v5.

Murali
>
>> ---
>>   drivers/pci/probe.c |    2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
>> index 23212f8..d7dcd6c 100644
>> --- a/drivers/pci/probe.c
>> +++ b/drivers/pci/probe.c
>> @@ -6,6 +6,7 @@
>>   #include<linux/delay.h>
>>   #include<linux/init.h>
>>   #include<linux/pci.h>
>> +#include<linux/of_pci.h>
>>   #include<linux/pci_hotplug.h>
>>   #include<linux/slab.h>
>>   #include<linux/module.h>
>> @@ -1520,6 +1521,7 @@ void pci_device_add(struct pci_dev *dev, struct pci_bus *bus)
>>   	dev->dev.dma_mask =&dev->dma_mask;
>>   	dev->dev.dma_parms =&dev->dma_parms;
>>   	dev->dev.coherent_dma_mask = 0xffffffffull;
>> +	of_pci_dma_configure(dev);
>>
>>   	pci_set_dma_max_seg_size(dev, 65536);
>>   	pci_set_dma_seg_boundary(dev, 0xffffffff);
>> --
>> 1.7.9.5
>>


-- 
Murali Karicheri
Linux Kernel, Texas Instruments
