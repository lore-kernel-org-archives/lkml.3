Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876AbbAEJVR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 04:21:17 -0500
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:58305 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238AbbAEJVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 04:21:12 -0500
Date: Mon, 5 Jan 2015 10:21:05 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Chen Gang <gang.chen@sunrus.com.cn>
Cc: schwidefsky@de.ibm.com, linux-s390@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] s390: boot: compressed: misc: Express the return value
 of _sclp_print_early()
Message-ID: <20150105092105.GA4281@osiris>
References: <54A7B663.3010507@sunrus.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54A7B663.3010507@sunrus.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15010509-0025-0000-0000-00000332A99C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 03, 2015 at 05:29:07PM +0800, Chen Gang wrote:
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

Thanks, applied. However I moved the declaration to the sclp header file.

