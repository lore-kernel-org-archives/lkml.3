Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626AbaDPFok (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 01:44:40 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:48467 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960AbaDPFoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 01:44:38 -0400
Message-ID: <534E18B4.9060704@gmail.com>
Date: Wed, 16 Apr 2014 13:44:20 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: =?UTF-8?B?566h6Zuq5rab?= <gxt@pku.edu.cn>
CC: Guan Xuetao <gxt@mprc.pku.edu.cn>, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org
Subject: Re: =?UTF-8?B?5Zue5aSN77yaIFtQQVRDSF0gdW5pY29yZTMyOiBpbmNsdWRlOiA=?=
 =?UTF-8?B?YXNtOiBhZGQgbWlzc2luZyAnKScgZm9yIFBBR0VfKiBtYWNyb3MgaW4gcGd0YWI=?=
 =?UTF-8?B?bGUuaA==?=
References: <1941336741.38929.1397625571001.JavaMail.root@bj-mail03.pku.edu.cn>
In-Reply-To: <1941336741.38929.1397625571001.JavaMail.root@bj-mail03.pku.edu.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/2014 01:19 PM, 管雪涛 wrote:
> This problem has been fixed, but I didn't submit.
> Anyway, I can apply your version.
> 
> Acked-by: Xuetao Guan <gxt@mprc.pku.edu.cn>
> 

OK, thanks.

> ----- Chen Gang <gang.chen.5i5j@gmail.com> 写道：
>> Missing related ')', the related compiling error:
>>
>>     CC [M]  drivers/gpu/drm/udl/udl_fb.o
>>   drivers/gpu/drm/udl/udl_fb.c: In function ‘udl_fb_mmap’:
>>   drivers/gpu/drm/udl/udl_fb.c:273: error: expected ‘)’ before ‘return’
>>   drivers/gpu/drm/udl/udl_fb.c:281: error: expected expression before ‘}’ token
>>   make[4]: *** [drivers/gpu/drm/udl/udl_fb.o] Error 1
>>   make[3]: *** [drivers/gpu/drm/udl] Error 2
>>   make[2]: *** [drivers/gpu/drm] Error 2
>>   make[1]: *** [drivers/gpu] Error 2
>>   make: *** [drivers] Error 2
>>
>>
>> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
>> ---
>>  arch/unicore32/include/asm/pgtable.h |   10 +++++-----
>>  1 file changed, 5 insertions(+), 5 deletions(-)
>>
>> diff --git a/arch/unicore32/include/asm/pgtable.h b/arch/unicore32/include/asm/pgtable.h
>> index 233c258..ed6f7d0 100644
>> --- a/arch/unicore32/include/asm/pgtable.h
>> +++ b/arch/unicore32/include/asm/pgtable.h
>> @@ -87,16 +87,16 @@ extern pgprot_t pgprot_kernel;
>>  
>>  #define PAGE_NONE		pgprot_user
>>  #define PAGE_SHARED		__pgprot(pgprot_val(pgprot_user | PTE_READ \
>> -								| PTE_WRITE)
>> +								| PTE_WRITE))
>>  #define PAGE_SHARED_EXEC	__pgprot(pgprot_val(pgprot_user | PTE_READ \
>>  								| PTE_WRITE \
>> -								| PTE_EXEC)
>> +								| PTE_EXEC))
>>  #define PAGE_COPY		__pgprot(pgprot_val(pgprot_user | PTE_READ)
>>  #define PAGE_COPY_EXEC		__pgprot(pgprot_val(pgprot_user | PTE_READ \
>> -								| PTE_EXEC)
>> -#define PAGE_READONLY		__pgprot(pgprot_val(pgprot_user | PTE_READ)
>> +								| PTE_EXEC))
>> +#define PAGE_READONLY		__pgprot(pgprot_val(pgprot_user | PTE_READ))
>>  #define PAGE_READONLY_EXEC	__pgprot(pgprot_val(pgprot_user | PTE_READ \
>> -								| PTE_EXEC)
>> +								| PTE_EXEC))
>>  #define PAGE_KERNEL		pgprot_kernel
>>  #define PAGE_KERNEL_EXEC	__pgprot(pgprot_val(pgprot_kernel | PTE_EXEC))
>>  
>> -- 
>> 1.7.9.5
> 

-- 
Chen Gang

Open, share, and attitude like air, water, and life which God blessed
