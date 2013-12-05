Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066Ab3LEGtg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 01:49:36 -0500
Received: from mail-la0-f41.google.com ([209.85.215.41]:45742 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678Ab3LEGtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 01:49:33 -0500
MIME-Version: 1.0
In-Reply-To: <1369815408-12719-1-git-send-email-geert@linux-m68k.org>
References: <1369815408-12719-1-git-send-email-geert@linux-m68k.org>
From: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
Date: Thu, 5 Dec 2013 15:49:01 +0900
X-Google-Sender-Auth: MLT5lGRqe327Q37W0oQHV2w1CNk
Message-ID: <CABMQnV+mYYmSKK6ayeDbaiOnNSOgUhN4TjZV50eYmQwaQ3rHhQ@mail.gmail.com>
Subject: Re: [PATCH/RFC] sh: Always link in helper functions extracted from libgcc
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Paul Mundt <lethal@linux-sh.org>, Linux-sh <linux-sh@vger.kernel.org>,
        linux-arch@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

# Add akpm@linux-foundation.org and stable@vger.kernel.org to CC.

Hi, Geert.

I was just creating a patch as your patch.... I noticed your patch by chance.
I think your proposal is good.

But Paul does not maintain the SH tree.
Andrew, Could you pickup this patch ?

Tested-by: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
Reviewed-by: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>

Best regards,
  Nobuhiro

2013/5/29 Geert Uytterhoeven <geert@linux-m68k.org>:
> E.g. landisk_defconfig, which has CONFIG_NTFS_FS=m:
>
> ERROR: "__ashrdi3" [fs/ntfs/ntfs.ko] undefined!
>
> For "lib-y", if no symbols in a compilation unit are referenced by other
> units, the compilation unit will not be included in vmlinux.
> This breaks modules that do reference those symbols.
>
> Use "obj-y" instead to fix this.
>
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
> http://kisskb.ellerman.id.au/kisskb/buildresult/8838077/
>
> This doesn't fix all cases. There are others, e.g. udivsi3.
> This is also not limited to sh, many architectures handle this in the same
> way.
>
> A simple solution is to unconditionally include all helper functions.
> A more complex solution is to make the choice of "lib-y" or "obj-y" depend
> on CONFIG_MODULES:
>   obj-$(CONFIG_MODULES) += ...
>   lib-y($CONFIG_MODULES) += ...
>
> What do you think?
> Thanks for your comments!
>
>  arch/sh/lib/Makefile |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/arch/sh/lib/Makefile b/arch/sh/lib/Makefile
> index 7b95f29..3baff31 100644
> --- a/arch/sh/lib/Makefile
> +++ b/arch/sh/lib/Makefile
> @@ -6,7 +6,7 @@ lib-y  = delay.o memmove.o memchr.o \
>          checksum.o strlen.o div64.o div64-generic.o
>
>  # Extracted from libgcc
> -lib-y += movmem.o ashldi3.o ashrdi3.o lshrdi3.o \
> +obj-y += movmem.o ashldi3.o ashrdi3.o lshrdi3.o \
>          ashlsi3.o ashrsi3.o ashiftrt.o lshrsi3.o \
>          udiv_qrnnd.o
>
> --
> 1.7.0.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sh" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Nobuhiro Iwamatsu
