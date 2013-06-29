Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188Ab3F2IBT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 04:01:19 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:48629 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445Ab3F2IBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 04:01:18 -0400
Message-ID: <51CE9442.2020105@gmail.com>
Date: Sat, 29 Jun 2013 20:01:06 +1200
From: Michael Schmitz <schmitzmic@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Chen Gang <gang.chen@asianux.com>
CC: Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-m68k <linux-m68k@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch: m68k: include: asm: define 'VM_DATA_DEFAULT_FLAGS'
 no matter whether has 'NOMMU' or not.
References: <51C548E2.1060104@asianux.com> <51C54A9B.9060009@asianux.com>
In-Reply-To: <51C54A9B.9060009@asianux.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> The same .config file, also report the compiling error below:
>
> drivers/i2c/busses/i2c-ocores.c:81:2: error: implicit declaration of function ‘iowrite8’ [-Werror=implicit-function-declaration]
> drivers/i2c/busses/i2c-ocores.c:86:2: error: implicit declaration of function ‘iowrite16’ [-Werror=implicit-function-declaration]
> drivers/i2c/busses/i2c-ocores.c:91:2: error: implicit declaration of function ‘iowrite32’ [-Werror=implicit-function-declaration]
> drivers/i2c/busses/i2c-ocores.c:96:2: error: implicit declaration of function ‘ioread8’ [-Werror=implicit-function-declaration]
> drivers/i2c/busses/i2c-ocores.c:101:2: error: implicit declaration of function ‘ioread16’ [-Werror=implicit-function-declaration]
> drivers/i2c/busses/i2c-ocores.c:106:2: error: implicit declaration of function ‘ioread32’ [-Werror=implicit-function-declaration]
>
> Excuse me, I am not quite familiar with the related hardware and m68k,
> I guess under m68k architecture, we need not this drivers, is it correct ?

That would be correct, yes. Perhaps add appropriate dependencies in 
drivers/i2c/Kconfig to allow building I2C drivers
only on hardware that supports it?

(Joking - some fallout would be expected when using make randconfig)

Cheers,

     Michael


> Thanks.
>
>
> On 06/22/2013 02:49 PM, Chen Gang wrote:
>> Define 'VM_DATA_DEFAULT_FLAGS' when 'NOMMU' to pass compiling.
>>
>> So move it from "include/asm/page_mm.h to "include/asm/page.h"
>>
>> The related make:
>>
>>    make ARCH=m68k randconfig
>>    make ARCH=m68k menuconfig
>>      choose cross compiler
>>      disable MMU support
>>    make ARCH=m68k V=1 EXTRA_CFLAGS=-W
>>
>> The related error:
>>
>>    security/selinux/hooks.c: In function �selinux_init�:
>>    security/selinux/hooks.c:5821:21: error: �VM_DATA_DEFAULT_FLAGS� undeclared (first use in this function)
>>
>> (the attachment is the related .config file)
>>
>>
>> Signed-off-by: Chen Gang <gang.chen@asianux.com>
>> ---
>>   arch/m68k/include/asm/page.h    |    3 +++
>>   arch/m68k/include/asm/page_mm.h |    3 ---
>>   2 files changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/m68k/include/asm/page.h b/arch/m68k/include/asm/page.h
>> index 7c360da..38b024a 100644
>> --- a/arch/m68k/include/asm/page.h
>> +++ b/arch/m68k/include/asm/page.h
>> @@ -48,6 +48,9 @@ extern unsigned long _ramend;
>>   #include <asm/page_no.h>
>>   #endif
>>   
>> +#define VM_DATA_DEFAULT_FLAGS	(VM_READ | VM_WRITE | VM_EXEC | \
>> +				 VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
>> +
>>   #include <asm-generic/getorder.h>
>>   
>>   #endif /* _M68K_PAGE_H */
>> diff --git a/arch/m68k/include/asm/page_mm.h b/arch/m68k/include/asm/page_mm.h
>> index 89f2014..5029f73 100644
>> --- a/arch/m68k/include/asm/page_mm.h
>> +++ b/arch/m68k/include/asm/page_mm.h
>> @@ -173,7 +173,4 @@ static inline __attribute_const__ int __virt_to_node_shift(void)
>>   
>>   #endif /* __ASSEMBLY__ */
>>   
>> -#define VM_DATA_DEFAULT_FLAGS	(VM_READ | VM_WRITE | VM_EXEC | \
>> -				 VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
>> -
>>   #endif /* _M68K_PAGE_MM_H */
>>
>

