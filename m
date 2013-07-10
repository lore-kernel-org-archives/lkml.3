Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114Ab3GJFpX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 01:45:23 -0400
Received: from mail.windriver.com ([147.11.1.11]:54679 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891Ab3GJFpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 01:45:22 -0400
Message-ID: <51DCF518.4090105@windriver.com>
Date: Wed, 10 Jul 2013 13:46:00 +0800
From: "tiejun.chen" <tiejun.chen@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Bhushan Bharat-R65777 <R65777@freescale.com>
CC: "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        Wood Scott-B07421 <B07421@freescale.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [v3][PATCH 7/8] book3e/kexec/kdump: redefine VIRT_PHYS_OFFSET
References: <1373357007-30785-1-git-send-email-tiejun.chen@windriver.com> <1373357007-30785-8-git-send-email-tiejun.chen@windriver.com> <6A3DF150A5B70D4F9B66A25E3F7C888D070AE138@039-SN2MPN1-011.039d.mgd.msft.net>
In-Reply-To: <6A3DF150A5B70D4F9B66A25E3F7C888D070AE138@039-SN2MPN1-011.039d.mgd.msft.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.162.214]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2013 01:20 PM, Bhushan Bharat-R65777 wrote:
>
>
>> -----Original Message-----
>> From: Linuxppc-dev [mailto:linuxppc-dev-
>> bounces+bharat.bhushan=freescale.com@lists.ozlabs.org] On Behalf Of Tiejun Chen
>> Sent: Tuesday, July 09, 2013 1:33 PM
>> To: benh@kernel.crashing.org
>> Cc: linuxppc-dev@lists.ozlabs.org; linux-kernel@vger.kernel.org
>> Subject: [v3][PATCH 7/8] book3e/kexec/kdump: redefine VIRT_PHYS_OFFSET
>>
>> Book3e is always aligned 1GB to create TLB so we should
>> use (KERNELBASE - MEMORY_START) as VIRT_PHYS_OFFSET to
>> get __pa/__va properly while boot kdump.
>>
>> Signed-off-by: Tiejun Chen <tiejun.chen@windriver.com>
>> ---
>>   arch/powerpc/include/asm/page.h |    2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/arch/powerpc/include/asm/page.h b/arch/powerpc/include/asm/page.h
>> index 988c812..5b00081 100644
>> --- a/arch/powerpc/include/asm/page.h
>> +++ b/arch/powerpc/include/asm/page.h
>> @@ -112,6 +112,8 @@ extern long long virt_phys_offset;
>>   /* See Description below for VIRT_PHYS_OFFSET */
>>   #ifdef CONFIG_RELOCATABLE_PPC32
>>   #define VIRT_PHYS_OFFSET virt_phys_offset
>> +#elif defined(CONFIG_PPC_BOOK3E_64)
>> +#define VIRT_PHYS_OFFSET (KERNELBASE - MEMORY_START)
>
> Can you please explain this code a bit more. I am not understanding this part:)

Nothing is special, we only need to redefine this to make sure __va()/__pa() can 
work well for BOOk3E-64 in BOOKE case:

#ifdef CONFIG_BOOKE
#define __va(x) ((void *)(unsigned long)((phys_addr_t)(x) + VIRT_PHYS_OFFSET))
#define __pa(x) ((unsigned long)(x) - VIRT_PHYS_OFFSET)

And the arch/powerpc/include/asm/page.h file has more descriptions inline :)

Tiejun
