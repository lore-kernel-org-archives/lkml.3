Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751690AbbACJuK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2015 04:50:10 -0500
Received: from out1134-194.mail.aliyun.com ([42.120.134.194]:37339 "EHLO
	out1134-194.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750922AbbACJuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2015 04:50:06 -0500
X-Greylist: delayed 21951 seconds by postgrey-1.27 at vger.kernel.org; Sat, 03 Jan 2015 04:50:05 EST
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.06680191|-1;FP=0|0|0|0|0|-1|-1|-1;HT=r46d02008;MF=gang.chen@sunrus.com.cn;PH=DS;RN=4;RT=4;SR=0;
Message-ID: <54A7BB35.9020604@sunrus.com.cn>
Date: Sat, 03 Jan 2015 17:49:41 +0800
From: Chen Gang <gang.chen@sunrus.com.cn>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com
CC: linux-s390@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] s390: boot: compressed: misc: Express the return value
 of _sclp_print_early()
References: <54A7B663.3010507@sunrus.com.cn>
In-Reply-To: <54A7B663.3010507@sunrus.com.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Our s390 can pass allmodconfig at present (although it is still has
various warnings).

Thanks.

On 01/03/2015 05:29 PM, Chen Gang wrote:
> _sclp_print_early() has return value: at present, return 0 for OK, 1 for
> failure. It returns '%r2', so use 'long' as return value (upper caller
> can check '%r2' directly). The related warning:
> 
>     CC      arch/s390/boot/compressed/misc.o
>   arch/s390/boot/compressed/misc.c:66:8: warning: type defaults to 'int' in declaration of '_sclp_print_early' [-Wimplicit-int]
>    extern _sclp_print_early(const char *);
>           ^
> 
> At present, _sclp_print_early() is only used by puts(), so can still
> remain its declaration in 'misc.c' file.
> 
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> ---
>  arch/s390/boot/compressed/misc.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/s390/boot/compressed/misc.c b/arch/s390/boot/compressed/misc.c
> index 57cbaff..09003b2 100644
> --- a/arch/s390/boot/compressed/misc.c
> +++ b/arch/s390/boot/compressed/misc.c
> @@ -63,7 +63,7 @@ static unsigned long free_mem_end_ptr;
>  #include "../../../../lib/decompress_unxz.c"
>  #endif
>  
> -extern _sclp_print_early(const char *);
> +extern long _sclp_print_early(const char *);
>  
>  static int puts(const char *s)
>  {
> 

-- 
Chen Gang

Open, share, and attitude like air, water, and life which God blessed
