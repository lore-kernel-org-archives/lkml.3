Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759573Ab3KMSjY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 13:39:24 -0500
Received: from smtp.outflux.net ([198.145.64.163]:58127 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756935Ab3KMSjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 13:39:17 -0500
Date: Wed, 13 Nov 2013 10:39:13 -0800
From: Kees Cook <keescook@chromium.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gcc4: Disable __compiletime_object_size for GCC 4.6+
Message-ID: <20131113183913.GK4994@outflux.net>
References: <1365821348-7177-1-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365821348-7177-1-git-send-email-linux@roeck-us.net>
Organization: Outflux
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

On Fri, Apr 12, 2013 at 07:49:08PM -0700, Guenter Roeck wrote:
> __builtin_object_size is known to be broken on gcc 4.6+.
> See http://gcc.gnu.org/bugzilla/show_bug.cgi?id=48880 for details.
> 
> This causes unnecssary build warnings and errors such as
> 
> In function 'copy_from_user', inlined from 'sb16_copy_from_user'
> 	at sound/oss/sb_audio.c:878:22:
> arch/x86/include/asm/uaccess_32.h:211:26: error: call to 'copy_from_user_overflow'
> 	declared with attribute error: copy_from_user() buffer size is not provably correct
> make[3]: [sound/oss/sb_audio.o] Error 1 (ignored)
> 
> Disable it where broken.

Is there an alternative? This means that things like
DEBUG_STRICT_USER_COPY_CHECKS are being rendered useless. I don't think
this is _always_ broken, just under certain situations, right?

-Kees

> 
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
>  include/linux/compiler-gcc4.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/compiler-gcc4.h b/include/linux/compiler-gcc4.h
> index 68b162d..842de22 100644
> --- a/include/linux/compiler-gcc4.h
> +++ b/include/linux/compiler-gcc4.h
> @@ -13,7 +13,7 @@
>  #define __must_check 		__attribute__((warn_unused_result))
>  #define __compiler_offsetof(a,b) __builtin_offsetof(a,b)
>  
> -#if GCC_VERSION >= 40100
> +#if GCC_VERSION >= 40100 && GCC_VERSION < 40600
>  # define __compiletime_object_size(obj) __builtin_object_size(obj, 0)
>  #endif
>  
> -- 
> 1.7.9.7
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Kees Cook
Chrome OS Security
