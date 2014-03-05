Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958AbaCEHQF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 02:16:05 -0500
Received: from mail-oa0-f42.google.com ([209.85.219.42]:44334 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbaCEHQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 02:16:03 -0500
MIME-Version: 1.0
In-Reply-To: <20140305173559.0b50971a1ab88a16bee8819c@canb.auug.org.au>
References: <20140305173559.0b50971a1ab88a16bee8819c@canb.auug.org.au>
Date: Wed, 5 Mar 2014 15:16:02 +0800
Message-ID: <CACRpkda8qHQRu-JCgdVOHAh+QvjfJB5ftJEEQ66tjePrRCuYzA@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the final tree (gpio
 tree related)
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Fabian Vogt <fabian@ritter-vogt.de>
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 5, 2014 at 2:35 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
>
> drivers/gpio/gpio-zevio.c: In function 'zevio_gpio_port_get':
> drivers/gpio/gpio-zevio.c:70:2: error: implicit declaration of function 'IOMEM' [-Werror=implicit-function-declaration]
>   return readl(IOMEM(c->chip.regs + section_offset + port_offset));
>   ^
> drivers/gpio/gpio-zevio.c:70:2: warning: passing argument 1 of 'readl' makes pointer from integer without a cast [enabled by default]
> In file included from include/linux/io.h:22:0,
>                  from drivers/gpio/gpio-zevio.c:15:
> arch/powerpc/include/asm/io-defs.h:6:16: note: expected 'const volatile void *' but argument is of type 'int'
>  DEF_PCI_AC_RET(readl, u32, (const PCI_IO_ADDR addr), (addr), mem, addr)
>                 ^

Fabian can you suggest a patch adding the proper depends added to
the Kconfig. Check what things bring in the IOMEM etc that is needed
to compile this.

Yours,
Linus Walleij
