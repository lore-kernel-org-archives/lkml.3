Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095AbaHHBkE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 21:40:04 -0400
Received: from mail1.windriver.com ([147.11.146.13]:45516 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754814AbaHHBkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 21:40:02 -0400
Message-ID: <53E42A42.3000707@windriver.com>
Date: Fri, 8 Aug 2014 09:39:14 +0800
From: "Yang,Wei" <Wei.Yang@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: "Yang,Wei" <Wei.Yang@windriver.com>, <Wei.Yang@windriver.com>,
        <ralf@linux-mips.org>
CC: <linux-mips@linux-mips.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1] MIPS:KDUMP: set a right value to kexec_indirection_page
 variable
References: <1406806949-27039-1-git-send-email-Wei.Yang@windriver.com> <53DF0204.6000904@windriver.com>
In-Reply-To: <53DF0204.6000904@windriver.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.162.170]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ralf,

What do you think of this patch?

Thanks
Wei
On 08/04/2014 11:46 AM, Yang,Wei wrote:
> ping.
>
> BR,
> Wei
> On 07/31/2014 07:42 PM, Wei.Yang@windriver.com wrote:
>> From: Yang Wei <Wei.Yang@windriver.com>
>>
>> Since there is not indirection page in crash type, so the vaule of 
>> the head
>> field of kimage structure is not equal to the address of indirection 
>> page but
>> IND_DONE. so we have to set kexec_indirection_page variable to the 
>> address of
>> the head field of image structure.
>>
>> Signed-off-by: Yang Wei <Wei.Yang@windriver.com>
>>
>>            Hi Ralf,
>>
>>           Please help me take a look at this patch, I have already 
>> verified it on Cavium 6100EVB board.
>>
>>           Thanks
>>           Wei
>> ---
>>   arch/mips/kernel/machine_kexec.c |    9 +++++++--
>>   1 file changed, 7 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/mips/kernel/machine_kexec.c 
>> b/arch/mips/kernel/machine_kexec.c
>> index 992e184..531b70d 100644
>> --- a/arch/mips/kernel/machine_kexec.c
>> +++ b/arch/mips/kernel/machine_kexec.c
>> @@ -71,8 +71,13 @@ machine_kexec(struct kimage *image)
>>       kexec_start_address =
>>           (unsigned long) phys_to_virt(image->start);
>>   -    kexec_indirection_page =
>> -        (unsigned long) phys_to_virt(image->head & PAGE_MASK);
>> +    if (image->type == KEXEC_TYPE_DEFAULT) {
>> +        kexec_indirection_page =
>> +            (unsigned long) phys_to_virt(image->head & PAGE_MASK);
>> +    } else {
>> +        kexec_indirection_page = (unsigned long)&image->head;
>> +    }
>> +
>>         memcpy((void*)reboot_code_buffer, relocate_new_kernel,
>>              relocate_new_kernel_size);
>
>
>

