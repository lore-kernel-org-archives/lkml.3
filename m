Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604Ab3H3Ffj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 01:35:39 -0400
Received: from mail.active-venture.com ([67.228.131.205]:58438 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567Ab3H3Ffi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 01:35:38 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <52202045.1050506@roeck-us.net>
Date: Thu, 29 Aug 2013 21:32:05 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Chen Gang <gang.chen@asianux.com>
CC: Yoshinori Sato <ysato@users.sourceforge.jp>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2]  h8300/kernel/setup.c: add "linux/initrd.h" to pass
 compiling
References: <521B2E75.1040802@asianux.com> <5220177E.709@asianux.com> <52201896.9040309@asianux.com>
In-Reply-To: <52201896.9040309@asianux.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/2013 08:59 PM, Chen Gang wrote:
> The related error (allmodconfig for h8300):
>
>    arch/h8300/kernel/setup.c: In function 'setup_arch':
>    arch/h8300/kernel/setup.c:103:3: error: 'initrd_start' undeclared (first use in this function)
>       initrd_start = memory_start;
>       ^
>    arch/h8300/kernel/setup.c:103:3: note: each undeclared identifier is reported only once for each function it appears in
>    arch/h8300/kernel/setup.c:104:3: error: 'initrd_end' undeclared (first use in this function)
>       initrd_end = memory_start += be32_to_cpu(((unsigned long *) (memory_start))[2]);
>       ^
>
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>   arch/h8300/kernel/setup.c |    4 ++++
>   1 files changed, 4 insertions(+), 0 deletions(-)
>
> diff --git a/arch/h8300/kernel/setup.c b/arch/h8300/kernel/setup.c
> index d0b1607..85639a1 100644
> --- a/arch/h8300/kernel/setup.c
> +++ b/arch/h8300/kernel/setup.c
> @@ -47,6 +47,10 @@
>   #include <asm/regs267x.h>
>   #endif
>
> +#if defined(CONFIG_BLK_DEV_INITRD)
> +#include <linux/initrd.h>
> +#endif
> +

Is the #ifdef/#endif really needed ? If not you should drop it.

Thanks,
Guenter

