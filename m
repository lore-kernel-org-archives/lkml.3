Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754393AbaDPFTt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 01:19:49 -0400
Received: from mx14.pku.edu.cn ([162.105.129.177]:41471 "EHLO mail.pku.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750919AbaDPFTr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 01:19:47 -0400
X-Spam-Flag: NO
X-Spam-Score: -307.091
Date: Wed, 16 Apr 2014 13:19:31 +0800 (CST)
From: =?utf-8?B?566h6Zuq5rab?= <gxt@pku.edu.cn>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org
Message-ID: <1941336741.38929.1397625571001.JavaMail.root@bj-mail03.pku.edu.cn>
In-Reply-To: <534C903C.6050904@gmail.com>
Subject: =?utf-8?Q?=E5=9B=9E=E5=A4=8D=EF=BC=9A_[PATCH]_unicore3?=
 =?utf-8?Q?2:_include:_asm:_add_?=
 =?utf-8?Q?missing_')'_for_PAGE=5F*_macros_in_pgtable.h?=
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [162.105.129.97]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This problem has been fixed, but I didn't submit.
Anyway, I can apply your version.

Acked-by: Xuetao Guan <gxt@mprc.pku.edu.cn>

----- Chen Gang <gang.chen.5i5j@gmail.com> 写道：
> Missing related ')', the related compiling error:
> 
>     CC [M]  drivers/gpu/drm/udl/udl_fb.o
>   drivers/gpu/drm/udl/udl_fb.c: In function ‘udl_fb_mmap’:
>   drivers/gpu/drm/udl/udl_fb.c:273: error: expected ‘)’ before ‘return’
>   drivers/gpu/drm/udl/udl_fb.c:281: error: expected expression before ‘}’ token
>   make[4]: *** [drivers/gpu/drm/udl/udl_fb.o] Error 1
>   make[3]: *** [drivers/gpu/drm/udl] Error 2
>   make[2]: *** [drivers/gpu/drm] Error 2
>   make[1]: *** [drivers/gpu] Error 2
>   make: *** [drivers] Error 2
> 
> 
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> ---
>  arch/unicore32/include/asm/pgtable.h |   10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/unicore32/include/asm/pgtable.h b/arch/unicore32/include/asm/pgtable.h
> index 233c258..ed6f7d0 100644
> --- a/arch/unicore32/include/asm/pgtable.h
> +++ b/arch/unicore32/include/asm/pgtable.h
> @@ -87,16 +87,16 @@ extern pgprot_t pgprot_kernel;
>  
>  #define PAGE_NONE		pgprot_user
>  #define PAGE_SHARED		__pgprot(pgprot_val(pgprot_user | PTE_READ \
> -								| PTE_WRITE)
> +								| PTE_WRITE))
>  #define PAGE_SHARED_EXEC	__pgprot(pgprot_val(pgprot_user | PTE_READ \
>  								| PTE_WRITE \
> -								| PTE_EXEC)
> +								| PTE_EXEC))
>  #define PAGE_COPY		__pgprot(pgprot_val(pgprot_user | PTE_READ)
>  #define PAGE_COPY_EXEC		__pgprot(pgprot_val(pgprot_user | PTE_READ \
> -								| PTE_EXEC)
> -#define PAGE_READONLY		__pgprot(pgprot_val(pgprot_user | PTE_READ)
> +								| PTE_EXEC))
> +#define PAGE_READONLY		__pgprot(pgprot_val(pgprot_user | PTE_READ))
>  #define PAGE_READONLY_EXEC	__pgprot(pgprot_val(pgprot_user | PTE_READ \
> -								| PTE_EXEC)
> +								| PTE_EXEC))
>  #define PAGE_KERNEL		pgprot_kernel
>  #define PAGE_KERNEL_EXEC	__pgprot(pgprot_val(pgprot_kernel | PTE_EXEC))
>  
> -- 
> 1.7.9.5

