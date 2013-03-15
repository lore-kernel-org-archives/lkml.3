Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505Ab3COG0h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 02:26:37 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:63784 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741Ab3COG0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 02:26:35 -0400
MIME-Version: 1.0
In-Reply-To: <1363298204-8014-4-git-send-email-arnd@arndb.de>
References: <1363298204-8014-1-git-send-email-arnd@arndb.de>
	<1363298204-8014-4-git-send-email-arnd@arndb.de>
Date: Fri, 15 Mar 2013 07:26:35 +0100
X-Google-Sender-Auth: M_fVlpqgUIdgSWN0M7xKT9iY9-U
Message-ID: <CAMuHMdVhjnX_hag5Y5VvDWVcjPK8tMM-qx-TQ2x=M88yTZQwYg@mail.gmail.com>
Subject: Re: [PATCH] isdn: hisax: netjet requires VIRT_TO_BUS
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Karsten Keil <isdn@linux-pingi.de>, netdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 14, 2013 at 10:56 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> Disabling CONFIG_VIRT_TO_BUS on ARM showed that the hisax netjet
> driver depends on this deprecated functionality but is not
> marked so in Kconfig.
>
> Rather than adding ARM to the already long list of architectures
> that this driver is broken on, this patch adds 'depends on
> VIRT_TO_BUS' and removes the dependency on !SPARC, which is
> also implied by that.

IIRC, the real "arch" dependency for this driver is !BIG_ENDIAN, but
unfortunately
we don't have a generic Kconfig symbol for that.
Perhaps we may want to introduce that?
Of course we prefer to make drivers work on all endianness instead...

> --- a/drivers/isdn/hisax/Kconfig
> +++ b/drivers/isdn/hisax/Kconfig
> @@ -237,7 +237,8 @@ config HISAX_MIC
>
>  config HISAX_NETJET
>         bool "NETjet card"
> -       depends on PCI && (BROKEN || !(SPARC || PPC || PARISC || M68K || (MIPS && !CPU_LITTLE_ENDIAN) || FRV || (XTENSA && !CPU_LITTLE_ENDIAN)))
> +       depends on PCI && (BROKEN || !(PPC || PARISC || M68K || (MIPS && !CPU_LITTLE_ENDIAN) || FRV || (XTENSA && !CPU_LITTLE_ENDIAN)))
> +       depends on VIRT_TO_BUS
>         help
>           This enables HiSax support for the NetJet from Traverse
>           Technologies.
> @@ -248,7 +249,8 @@ config HISAX_NETJET
>
>  config HISAX_NETJET_U
>         bool "NETspider U card"
> -       depends on PCI && (BROKEN || !(SPARC || PPC || PARISC || M68K || (MIPS && !CPU_LITTLE_ENDIAN) || FRV || (XTENSA && !CPU_LITTLE_ENDIAN)))
> +       depends on PCI && (BROKEN || !(PPC || PARISC || M68K || (MIPS && !CPU_LITTLE_ENDIAN) || FRV || (XTENSA && !CPU_LITTLE_ENDIAN)))
> +       depends on VIRT_TO_BUS

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
