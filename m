Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348AbaENMcA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 08:32:00 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:49703 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754224AbaENMb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 08:31:57 -0400
Message-ID: <5373625B.4050401@linaro.org>
Date: Wed, 14 May 2014 14:32:27 +0200
From: Tomasz Nowicki <tomasz.nowicki@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Catalin Marinas <Catalin.Marinas@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>
CC: rjw@rjwysocki.net, lenb@kernel.org, tony.luck@intel.com, bp@suse.de,
        m.chehab@samsung.com, linux-edac@vger.kernel.org, x86@kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-acpi@lists.linaro.org
Subject: Re: [PATCH 6/7] acpi, apei, ghes: Make unmapping functionality independent
 from architecture.
References: <1397056476-9183-1-git-send-email-tomasz.nowicki@linaro.org> <1397056476-9183-7-git-send-email-tomasz.nowicki@linaro.org> <20140513201118.GF8760@pd.tnic>
In-Reply-To: <20140513201118.GF8760@pd.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13.05.2014 22:11, Borislav Petkov wrote:
> On Wed, Apr 09, 2014 at 05:14:34PM +0200, Tomasz Nowicki wrote:
>> Till now __flush_tlb_one was used for unmapping virtual memory which
>> is x86 specific function. Replace it with more generic
>> flush_tlb_kernel_range.
>>
>> Signed-off-by: Tomasz Nowicki <tomasz.nowicki@linaro.org>
>> ---
>>   drivers/acpi/apei/ghes.c |    4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
>> index aaf8db3..624878b 100644
>> --- a/drivers/acpi/apei/ghes.c
>> +++ b/drivers/acpi/apei/ghes.c
>> @@ -185,7 +185,7 @@ static void ghes_iounmap_nmi(void __iomem *vaddr_ptr)
>>
>>   	BUG_ON(vaddr != (unsigned long)GHES_IOREMAP_NMI_PAGE(base));
>>   	unmap_kernel_range_noflush(vaddr, PAGE_SIZE);
>> -	__flush_tlb_one(vaddr);
>> +	flush_tlb_kernel_range(vaddr, vaddr + PAGE_SIZE);
>>   }
>>
>>   static void ghes_iounmap_irq(void __iomem *vaddr_ptr)
>> @@ -195,7 +195,7 @@ static void ghes_iounmap_irq(void __iomem *vaddr_ptr)
>>
>>   	BUG_ON(vaddr != (unsigned long)GHES_IOREMAP_IRQ_PAGE(base));
>>   	unmap_kernel_range_noflush(vaddr, PAGE_SIZE);
>> -	__flush_tlb_one(vaddr);
>> +	flush_tlb_kernel_range(vaddr, vaddr + PAGE_SIZE);
>
> flush_tlb_kernel_range() does send an IPI to every core on x86 which is
> much more expensive than what __flush_tlb_one does.
>
> Fairer it would be if you added a __flush_tlb_one() version for arm
> which does flush_tlb_kernel_range for you.
>

Thanks for comment. I am not sure if maintainers will allow me to add 
sth like __flush_tlb_one() for arm/arm64. Let me ask them directly. 
Catalin, Russell what do you think?

Regards,
Tomasz
