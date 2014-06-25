Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932267AbaFYP3m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 11:29:42 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:47012 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932212AbaFYP3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 11:29:41 -0400
MIME-Version: 1.0
In-Reply-To: <53A6CC0E.5010000@gmail.com>
References: <53A6CC0E.5010000@gmail.com>
Date: Wed, 25 Jun 2014 23:29:40 +0800
Message-ID: <CAF0htA7YoQ=UtfMsNSRrYEO33aQZHnQP3Thy5ZUCreHwdqtg_Q@mail.gmail.com>
Subject: Re: [PATCH] arch/score/include/asm/uaccess.h: Use standard
 clear_user() prototype
From: Lennox Wu <lennox.wu@gmail.com>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: Liqin Chen <liqin.linux@gmail.com>, Guenter Roeck <linux@roeck-us.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the patch.

Acked-by: Lennox Wu<lennox.wu@gmail.com>

2014-06-22 20:29 GMT+08:00 Chen Gang <gang.chen.5i5j@gmail.com>:
> Use standard clear_user() just like another architectures, also match
> __clear_user() under score.
>
> The related warning (allmodconfig under score):
>
>     CC [M]  drivers/md/dm-ioctl.o
>   drivers/md/dm-ioctl.c: In function 'copy_params':
>   drivers/md/dm-ioctl.c:1728:33: warning: passing argument 1 of 'clear_user' from incompatible pointer type
>      if (secure_data && clear_user(user, param_kernel->data_size))
>                                    ^
>   In file included from include/linux/uaccess.h:5:0,
>                    from include/linux/highmem.h:8,
>                    from include/linux/bio.h:23,
>                    from include/linux/device-mapper.h:11,
>                    from drivers/md/dm.h:14,
>                    from drivers/md/dm-ioctl.c:8:
>   ./arch/score/include/asm/uaccess.h:364:29: note: expected 'char *' but argument is of type 'struct dm_ioctl *'
>    static inline unsigned long clear_user(char *src, unsigned long size)
>                                ^
>
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> ---
>  arch/score/include/asm/uaccess.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/arch/score/include/asm/uaccess.h b/arch/score/include/asm/uaccess.h
> index ab66ddd..259a539 100644
> --- a/arch/score/include/asm/uaccess.h
> +++ b/arch/score/include/asm/uaccess.h
> @@ -361,7 +361,8 @@ copy_in_user(void *to, const void *from, unsigned long len)
>   */
>  extern unsigned long __clear_user(void __user *src, unsigned long size);
>
> -static inline unsigned long clear_user(char *src, unsigned long size)
> +static inline unsigned long __must_check clear_user(void __user *src,
> +                                                       unsigned long size)
>  {
>         if (access_ok(VERIFY_WRITE, src, size))
>                 return __clear_user(src, size);
> --
> 1.9.2.459.g68773ac
