Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933828Ab3DGO2H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 10:28:07 -0400
Received: from mail-ia0-f175.google.com ([209.85.210.175]:54567 "EHLO
	mail-ia0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933796Ab3DGO2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 10:28:05 -0400
MIME-Version: 1.0
In-Reply-To: <51615AB0.9060502@asianux.com>
References: <51615AB0.9060502@asianux.com>
Date: Sun, 7 Apr 2013 16:28:04 +0200
X-Google-Sender-Auth: TUc4X-JkoUPq-NQkjNdG7lZE1Mw
Message-ID: <CAMuHMdU+K9Kqe1JS+PCcuyf_3V1yMDe_M1r63SyEyp4ppfkpfg@mail.gmail.com>
Subject: Re: [PATCH] kernel: module: strncpy issue, using strlcpy instead of strncpy
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Chen Gang <gang.chen@asianux.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        "linux-kernel@vger.kernel.org >> linux-kernel@vger.kernel.org" 
	<linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 7, 2013 at 1:38 PM, Chen Gang <gang.chen@asianux.com> wrote:
>   ownername and namebuf are all NUL terminated string.
>
>   need always let them ended by '\0'.
>
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  kernel/module.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/module.c b/kernel/module.c
> index 3c2c72d..597efd8 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c

> @@ -3464,7 +3464,7 @@ const char *module_address_lookup(unsigned long addr,
>         }
>         /* Make a copy in here where it's safe */
>         if (ret) {
> -               strncpy(namebuf, ret, KSYM_NAME_LEN - 1);
> +               strlcpy(namebuf, ret, KSYM_NAME_LEN);
>                 ret = namebuf;
>         }
>         preempt_enable();

Is this buffer ever copied to userspace?
If yes, it may leak innocent kernel stack to userspace, as strlcpy()
doesn't fill
the remaining of the buffer with zeroes, while strncpy() does.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
