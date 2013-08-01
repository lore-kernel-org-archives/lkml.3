Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752435Ab3HACPT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 22:15:19 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:47526 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751693Ab3HACPS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 22:15:18 -0400
Message-ID: <51F9C491.8070808@ti.com>
Date: Wed, 31 Jul 2013 22:14:41 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: Re: [RFC/RFT PATCH 4/5] ARM: mm: change max*pfn to include the physical
 offset of memory
References: <1373665694-7580-1-git-send-email-santosh.shilimkar@ti.com> <1373665694-7580-5-git-send-email-santosh.shilimkar@ti.com> <20130731105643.GW24642@n2100.arm.linux.org.uk>
In-Reply-To: <20130731105643.GW24642@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 31 July 2013 06:56 AM, Russell King - ARM Linux wrote:
> On Fri, Jul 12, 2013 at 05:48:13PM -0400, Santosh Shilimkar wrote:
>> diff --git a/arch/arm/include/asm/dma-mapping.h b/arch/arm/include/asm/dma-mapping.h
>> index 5b579b9..b2d5937 100644
>> --- a/arch/arm/include/asm/dma-mapping.h
>> +++ b/arch/arm/include/asm/dma-mapping.h
>> @@ -47,12 +47,12 @@ static inline int dma_set_mask(struct device *dev, u64 mask)
>>  #ifndef __arch_pfn_to_dma
>>  static inline dma_addr_t pfn_to_dma(struct device *dev, unsigned long pfn)
>>  {
>> -	return (dma_addr_t)__pfn_to_bus(pfn);
>> +	return (dma_addr_t)__pfn_to_bus(pfn + PHYS_PFN_OFFSET);
>>  }
>>  
>>  static inline unsigned long dma_to_pfn(struct device *dev, dma_addr_t addr)
>>  {
>> -	return __bus_to_pfn(addr);
>> +	return __bus_to_pfn(addr) - PHYS_PFN_OFFSET;
>>  }
>>  
>>  static inline void *dma_to_virt(struct device *dev, dma_addr_t addr)
>> @@ -64,15 +64,16 @@ static inline dma_addr_t virt_to_dma(struct device *dev, void *addr)
>>  {
>>  	return (dma_addr_t)__virt_to_bus((unsigned long)(addr));
>>  }
>> +
>>  #else
>>  static inline dma_addr_t pfn_to_dma(struct device *dev, unsigned long pfn)
>>  {
>> -	return __arch_pfn_to_dma(dev, pfn);
>> +	return __arch_pfn_to_dma(dev, pfn + PHYS_PFN_OFFSET);
>>  }
>>  
>>  static inline unsigned long dma_to_pfn(struct device *dev, dma_addr_t addr)
>>  {
>> -	return __arch_dma_to_pfn(dev, addr);
>> +	return __arch_dma_to_pfn(dev, addr) - PHYS_PFN_OFFSET;
>>  }
>>  
>>  static inline void *dma_to_virt(struct device *dev, dma_addr_t addr)
>> @@ -86,6 +87,13 @@ static inline dma_addr_t virt_to_dma(struct device *dev, void *addr)
>>  }
>>  #endif
> 
> Note that I don't think the above are correct - the 'pfn' argument to the
> above functions already includes the PFN offset of physical memory -
> they're all physical_address >> PAGE_SHIFT values.
> 
Right.
Updated patch pushed into the patch system. (patch 7805/1)

Regards,
Santosh
