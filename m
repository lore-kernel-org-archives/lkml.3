Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751842AbaEUH6r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 03:58:47 -0400
Received: from mx9.pku.edu.cn ([162.105.129.172]:34139 "EHLO mail.pku.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751069AbaEUH6q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 03:58:46 -0400
X-Spam-Flag: NO
X-Spam-Score: -307.339
Date: Wed, 21 May 2014 15:58:35 +0800 (CST)
From: =?utf-8?B?566h6Zuq5rab?= <gxt@pku.edu.cn>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>, linux-kernel@vger.kernel.org
Message-ID: <911514109.40740.1400659115169.JavaMail.root@bj-mail03.pku.edu.cn>
In-Reply-To: <537C0344.5010509@gmail.com>
Subject: =?utf-8?Q?=E5=9B=9E=E5=A4=8D=EF=BC=9A_[PATCH]_arch:_unicore?=
 =?utf-8?Q?32:_kernel:_ksyms:_remove?=
 =?utf-8?Q?_'bswapsi2'_and_'muldi3'_to_avoid_compiling_failure?=
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [162.105.129.97]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks.

For __muldi3, it is no longer used by gcc, so I think that's ok.
For __bswapsi2, maybe it's because I copied it from arm.

Acked-by: Xuetao Guan <gxt@mprc.pku.edu.cn>

----- Chen Gang <gang.chen.5i5j@gmail.com> 写道：
> After check the code, 'bswapsi2' and 'muldi3' are useless for
> unicore32, so can remove them to avoid compiling failure.
> 
> The related error (with allmodconfig under unicore32):
> 
>     LD      init/built-in.o
>   arch/unicore32/kernel/built-in.o:(___ksymtab+__muldi3+0x0): undefined reference to `__muldi3'
>   arch/unicore32/kernel/built-in.o:(___ksymtab+__bswapsi2+0x0): undefined reference to `__bswapsi2'
> 
> 
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> ---
>  arch/unicore32/kernel/ksyms.c | 2 --
>  arch/unicore32/kernel/ksyms.h | 2 --
>  2 files changed, 4 deletions(-)
> 
> diff --git a/arch/unicore32/kernel/ksyms.c b/arch/unicore32/kernel/ksyms.c
> index bc06140..e78911a 100644
> --- a/arch/unicore32/kernel/ksyms.c
> +++ b/arch/unicore32/kernel/ksyms.c
> @@ -53,9 +53,7 @@ EXPORT_SYMBOL(__ashrdi3);
>  EXPORT_SYMBOL(__divsi3);
>  EXPORT_SYMBOL(__lshrdi3);
>  EXPORT_SYMBOL(__modsi3);
> -EXPORT_SYMBOL(__muldi3);
>  EXPORT_SYMBOL(__ucmpdi2);
>  EXPORT_SYMBOL(__udivsi3);
>  EXPORT_SYMBOL(__umodsi3);
> -EXPORT_SYMBOL(__bswapsi2);
>  
> diff --git a/arch/unicore32/kernel/ksyms.h b/arch/unicore32/kernel/ksyms.h
> index 185cdc7..31472ad 100644
> --- a/arch/unicore32/kernel/ksyms.h
> +++ b/arch/unicore32/kernel/ksyms.h
> @@ -8,8 +8,6 @@ extern void __ashrdi3(void);
>  extern void __divsi3(void);
>  extern void __lshrdi3(void);
>  extern void __modsi3(void);
> -extern void __muldi3(void);
>  extern void __ucmpdi2(void);
>  extern void __udivsi3(void);
>  extern void __umodsi3(void);
> -extern void __bswapsi2(void);
> -- 
> 1.9.2.459.g68773ac

