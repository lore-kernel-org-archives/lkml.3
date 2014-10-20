Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668AbaJTHSU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 03:18:20 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:47145 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498AbaJTHSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 03:18:17 -0400
MIME-Version: 1.0
In-Reply-To: <1413740594-15579-1-git-send-email-stefan.hengelein@fau.de>
References: <1413740594-15579-1-git-send-email-stefan.hengelein@fau.de>
Date: Mon, 20 Oct 2014 09:18:15 +0200
X-Google-Sender-Auth: 3T5RL7B41iKuzZoU3ocCEblimOQ
Message-ID: <CAMuHMdV3cGsW3iONgHHsMgVcoOqjLDoiE5u-+62M=6+fOYsj4Q@mail.gmail.com>
Subject: Re: [PATCH] MIPS: ath79: fix compilation error when CONFIG_PCI is disabled
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Stefan Hengelein <stefan.hengelein@fau.de>
Cc: Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 19, 2014 at 7:43 PM, Stefan Hengelein
<stefan.hengelein@fau.de> wrote:
> When CONFIG_PCI is disabled, 'db120_pci_init()' had a different
> signature than when was enabled. Therefore, compilation failed when
> CONFIG_PCI was not present.
>
> arch/mips/ath79/mach-db120.c:132: error: too many arguments to function 'db120_pci_init'
>
> Signed-off-by: Stefan Hengelein <stefan.hengelein@fau.de>
> ---
>  arch/mips/ath79/mach-db120.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/mips/ath79/mach-db120.c b/arch/mips/ath79/mach-db120.c
> index 4d661a1..d1a783d 100644
> --- a/arch/mips/ath79/mach-db120.c
> +++ b/arch/mips/ath79/mach-db120.c
> @@ -112,8 +112,6 @@ static void __init db120_pci_init(u8 *eeprom)
>         ath79_pci_set_plat_dev_init(db120_pci_plat_dev_init);
>         ath79_register_pci();
>  }
> -#else
> -static inline void db120_pci_init(void) {}

Please fix the prototype above, instead of removing it and its caller.

>  #endif /* CONFIG_PCI */
>
>  static void __init db120_setup(void)
> @@ -129,7 +127,9 @@ static void __init db120_setup(void)
>                            ARRAY_SIZE(db120_spi_info));
>         ath79_register_usb();
>         ath79_register_wmac(art + DB120_WMAC_CALDATA_OFFSET);
> +#ifdef CONFIG_PCI
>         db120_pci_init(art + DB120_PCIE_CALDATA_OFFSET);
> +#endif
>  }

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
