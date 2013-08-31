Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280Ab3HaRhj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 13:37:39 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:62675 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753501Ab3HaRhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 13:37:36 -0400
MIME-Version: 1.0
In-Reply-To: <52210AB9.2090104@infradead.org>
References: <20130829200013.d9dde1eb64686a32c661b5d3@canb.auug.org.au>
	<52210AB9.2090104@infradead.org>
Date: Sat, 31 Aug 2013 19:37:36 +0200
X-Google-Sender-Auth: Qh-fjX6rc44IQPDfBfXdIhKYNzA
Message-ID: <CAMuHMdXFmWyiUJF+4HbD=6oGPVXHBAVx=rOC7u=motTQFCKn7g@mail.gmail.com>
Subject: Re: linux-next: Tree for Aug 30 (brcmfmac)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux-Next <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        brcm80211-dev-list@broadcom.com,
        linux-kbuild <linux-kbuild@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 30, 2013 at 11:12 PM, Randy Dunlap <rdunlap@infradead.org> wrote:
> This bool kconfig symbol:
>
> config BRCMFMAC_SDIO
>         bool "SDIO bus interface support for FullMAC driver"
>         depends on MMC
>
> allows BRCMFMAC_SDIO to be y even when MMC=m.
>
> Is there a reasonable solution to this?

In order of preference:
1. Make it tristate
2. depends on MMC=y

However, the first solution cannot be used as there are several
"#ifdef CONFIG_BRCMFMAC_SDIO" in the code itself.

Note that there's a similar issue with BRCMFMAC_USB and USB.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
