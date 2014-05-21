Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751567AbaEUHJH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 03:09:07 -0400
Received: from mx9.pku.edu.cn ([162.105.129.172]:44558 "EHLO mail.pku.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751033AbaEUHJF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 03:09:05 -0400
X-Spam-Flag: NO
X-Spam-Score: -307.185
Date: Wed, 21 May 2014 15:08:53 +0800 (CST)
From: =?utf-8?B?566h6Zuq5rab?= <gxt@pku.edu.cn>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>, linux-kernel@vger.kernel.org
Message-ID: <1304349982.40103.1400656133055.JavaMail.root@bj-mail03.pku.edu.cn>
In-Reply-To: <537BFA11.4050809@gmail.com>
Subject: =?gbk?B?UmU6IFtQQVRDSCB2Ml0gYXJjaC91bmljb3JlMzIva2VybmVsL2tzeW1zLmM6IHJlbW92ZSAyIGV4cG9ydA0KIHN5bWJvbHMgdG8gYXZvaWQgY29tcGlsaW5nIGZhaWx1cmU=?=
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [162.105.129.97]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, and this is a common error in most architectures.

Acked-by: Xuetao Guan <gxt@mprc.pku.edu.cn>

----- Chen Gang <gang.chen.5i5j@gmail.com> 写道：
> 'csum_partial' and 'csum_partial_copy_from_user' have already been
> exported in "lib/", so need not export them again, or it will cause
> compiling error.
> 
> The related error (with allmodconfig under unicore32):
> 
>     LD      vmlinux.o
>   lib/built-in.o:(___ksymtab+csum_partial+0x0): multiple definition of `__ksymtab_csum_partial'
>   arch/unicore32/kernel/built-in.o:(___ksymtab+csum_partial+0x0): first defined here
>   lib/built-in.o:(___ksymtab+csum_partial_copy_from_user+0x0): multiple definition of `__ksymtab_csum_partial_copy_from_user'
>   arch/unicore32/kernel/built-in.o:(___ksymtab+csum_partial_copy_from_user+0x0): first defined here
>   make: *** [vmlinux] Error 1
> 
> 
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> ---
>  arch/unicore32/kernel/ksyms.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/arch/unicore32/kernel/ksyms.c b/arch/unicore32/kernel/ksyms.c
> index 63afc7f..bc06140 100644
> --- a/arch/unicore32/kernel/ksyms.c
> +++ b/arch/unicore32/kernel/ksyms.c
> @@ -30,10 +30,6 @@ EXPORT_SYMBOL(find_next_bit);
>  EXPORT_SYMBOL(__udelay);
>  EXPORT_SYMBOL(__const_udelay);
>  
> -	/* networking */
> -EXPORT_SYMBOL(csum_partial);
> -EXPORT_SYMBOL(csum_partial_copy_from_user);
> -
>  	/* string / mem functions */
>  EXPORT_SYMBOL(strchr);
>  EXPORT_SYMBOL(strrchr);
> -- 
> 1.9.2.459.g68773ac

