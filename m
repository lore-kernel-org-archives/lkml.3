Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265Ab3HECWe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 22:22:34 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:40238 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754146Ab3HECWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 22:22:31 -0400
Message-ID: <51FF0C1A.3020907@gmail.com>
Date: Mon, 05 Aug 2013 10:21:14 +0800
From: Chen Gang F T <chen.gang.flying.transformer@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Greg Ungerer <gerg@uclinux.org>
CC: Chen Gang <gang.chen@asianux.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, davej@redhat.com,
        Arnd Bergmann <arnd@arndb.de>, linux-m68k <linux-m68k@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: [PATCH] arch: m68k: include: asm: define 'VM_DATA_DEFAULT_FLAGS'
 no matter whether has 'NOMMU' or not.
References: <51C548E2.1060104@asianux.com> <51D0ECC2.3020101@asianux.com> <51FF01E7.5020105@uclinux.org>
In-Reply-To: <51FF01E7.5020105@uclinux.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2013 09:37 AM, Greg Ungerer wrote:
> Hi Chen Gang,
> 
> On 01/07/13 12:43, Chen Gang wrote:
>> Hello Maintainers:
>>
>> Please help check the patch whether OK or not, when you have time.
>>
>> Thanks.
>>
>> On 06/22/2013 02:49 PM, Chen Gang wrote:
>>>
>>> Define 'VM_DATA_DEFAULT_FLAGS' when 'NOMMU' to pass compiling.
>>>
>>> So move it from "include/asm/page_mm.h to "include/asm/page.h"
>>>
>>> The related make:
>>>
>>>   make ARCH=m68k randconfig
>>>   make ARCH=m68k menuconfig
>>>     choose cross compiler
>>>     disable MMU support
>>>   make ARCH=m68k V=1 EXTRA_CFLAGS=-W
>>>
>>> The related error:
>>>
>>>   security/selinux/hooks.c: In function ‘selinux_init’:
>>>   security/selinux/hooks.c:5821:21: error: ‘VM_DATA_DEFAULT_FLAGS’ undeclared (first use in this function)
>>>
>>> (the attachment is the related .config file)
>>>
>>>
>>> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> 
> I am fine with this:
> 
> Acked-by: Greg Ungerer <gerg@uclinux.org>
> 

Thank you very much.

> Do you want me to add this to the m68knommu git tree, and push to
> Linus?
> 

Yeah, thank you.

:-)

> Regards
> Greg
> 
> 
>>> ---
>>>  arch/m68k/include/asm/page.h    |    3 +++
>>>  arch/m68k/include/asm/page_mm.h |    3 ---
>>>  2 files changed, 3 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/arch/m68k/include/asm/page.h b/arch/m68k/include/asm/page.h
>>> index 7c360da..38b024a 100644
>>> --- a/arch/m68k/include/asm/page.h
>>> +++ b/arch/m68k/include/asm/page.h
>>> @@ -48,6 +48,9 @@ extern unsigned long _ramend;
>>>  #include <asm/page_no.h>
>>>  #endif
>>>  
>>> +#define VM_DATA_DEFAULT_FLAGS	(VM_READ | VM_WRITE | VM_EXEC | \
>>> +				 VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
>>> +
>>>  #include <asm-generic/getorder.h>
>>>  
>>>  #endif /* _M68K_PAGE_H */
>>> diff --git a/arch/m68k/include/asm/page_mm.h b/arch/m68k/include/asm/page_mm.h
>>> index 89f2014..5029f73 100644
>>> --- a/arch/m68k/include/asm/page_mm.h
>>> +++ b/arch/m68k/include/asm/page_mm.h
>>> @@ -173,7 +173,4 @@ static inline __attribute_const__ int __virt_to_node_shift(void)
>>>  
>>>  #endif /* __ASSEMBLY__ */
>>>  
>>> -#define VM_DATA_DEFAULT_FLAGS	(VM_READ | VM_WRITE | VM_EXEC | \
>>> -				 VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
>>> -
>>>  #endif /* _M68K_PAGE_MM_H */
>>>
>>
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


-- 
Chen Gang
