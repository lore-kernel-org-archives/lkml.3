Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759300Ab3ICC5j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 22:57:39 -0400
Received: from mail.active-venture.com ([67.228.131.205]:61239 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759202Ab3ICC5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 22:57:38 -0400
X-Virus-Scan: Scanned by ClamAV 0.97.2 (no viruses);
  Mon, 02 Sep 2013 21:55:31 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <52254FA2.8020407@roeck-us.net>
Date: Mon, 02 Sep 2013 19:55:30 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: linux-xtensa@linux-xtensa.org, linux-kernel@vger.kernel.org,
        Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>
Subject: Re: [PATCH] xtensa: Fix broken allmodconfig build
References: <1377662797-21770-1-git-send-email-linux@roeck-us.net>
In-Reply-To: <1377662797-21770-1-git-send-email-linux@roeck-us.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2013 09:06 PM, Guenter Roeck wrote:
> xtansa allmodbuild fails with:
>
> arch/xtensa/kernel/xtensa_ksyms.c:129:1: error: '_mcount' undeclared here (not in a function)
> make[2]: *** [arch/xtensa/kernel/xtensa_ksyms.o] Error 1
> make[1]: *** [arch/xtensa/kernel] Error 2
>
> The breakage is due to commit 478ba61af (xtensa: add static function tracer
> support) which exports _mcount without declaring it.
>
> Cc: Max Filippov <jcmvbkbc@gmail.com>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---

Ping ... 3.11 now ships with xtensa allmodconfig broken, which is completely unnecessary.

Guenter

>   arch/xtensa/kernel/xtensa_ksyms.c |    1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/arch/xtensa/kernel/xtensa_ksyms.c b/arch/xtensa/kernel/xtensa_ksyms.c
> index d8507f8..74a60c7 100644
> --- a/arch/xtensa/kernel/xtensa_ksyms.c
> +++ b/arch/xtensa/kernel/xtensa_ksyms.c
> @@ -25,6 +25,7 @@
>   #include <asm/io.h>
>   #include <asm/page.h>
>   #include <asm/pgalloc.h>
> +#include <asm/ftrace.h>
>   #ifdef CONFIG_BLK_DEV_FD
>   #include <asm/floppy.h>
>   #endif
>

