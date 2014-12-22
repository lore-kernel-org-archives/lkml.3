Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821AbaLVWlF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 17:41:05 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:33810 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbaLVWlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 17:41:03 -0500
Message-ID: <54989DDE.3060409@ti.com>
Date: Mon, 22 Dec 2014 17:40:30 -0500
From: Murali Karicheri <m-karicheri2@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <bhelgaas@google.com>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <grant.likely@linaro.org>,
        <robh+dt@kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <will.deacon@arm.com>
Subject: Re: [RFC v1 PATCH 1/2] of/pci: add of_pci_dma_configure() update
 dma configuration
References: <1418940425-2017-1-git-send-email-m-karicheri2@ti.com> <11285984.OK9CqQGmjZ@wuerfel> <54988FDB.8000108@ti.com> <2285493.QXo0OxClZ5@wuerfel>
In-Reply-To: <2285493.QXo0OxClZ5@wuerfel>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/22/2014 05:24 PM, Arnd Bergmann wrote:
> On Monday 22 December 2014 16:40:43 Murali Karicheri wrote:
>>>> +++ b/arch/arm/mm/dma-mapping.c
>>>> @@ -2052,9 +2052,10 @@ void arch_setup_dma_ops(struct device *dev, u64
>>>> dma_base, u64 size,
>>>>                            struct iommu_ops *iommu, bool coherent)
>>>>     {
>>>>            struct dma_map_ops *dma_ops;
>>>> +       u64 temp_size = min((*(dev->dma_mask) + 1), size);
>>>>
>>>>            dev->archdata.dma_coherent = coherent;
>>>> -       if (arm_setup_iommu_dma_ops(dev, dma_base, size, iommu))
>>>> +       if (arm_setup_iommu_dma_ops(dev, dma_base, temp_size, iommu))
>>>>
>>>> If you agree, I will post v1 of the patch with these updates. Let me
>>>> know. I did some basic tests on Keystone with these changes and it works
>>>> fine.
>>>
>>> It's not exactly what I meant. My main point was that we need to limit
>>> dev->dma_mask to (size-1) here, but you are not touching that.
>>
>> if you mean overriding the dev->dma_mask to min((*dev->dma_mask),
>> size-1), then I am getting the error "Coherent DMA mask 0x7fffffff (pfn
>> 0x780000-0x800000) covers a smaller range of system memory than the DMA
>> zone pfn 0x0-0x880000) when the devices on Keystone tries to set the dma
>> mask. Something wrong and I need to look into the code.
>
> Right, it sounds like the offset was applied incorrectly at some point.
>
> What are the DMA zone size and the phys-offset?
2G and 0x8_0000_0000. This limit the usable DMA size to 2G on Keystone, 
I believe you shouldn't be limiting the dma mask to size-1 in this case, 
right? The DT setup the dma-range to have a size of 2G (0x80000000).

Murali
>
> 	Arnd


-- 
Murali Karicheri
Linux Kernel, Texas Instruments
