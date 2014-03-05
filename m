Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752AbaCEPmJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 10:42:09 -0500
Received: from moutng.kundenserver.de ([212.227.17.13]:59670 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478AbaCEPmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 10:42:06 -0500
From: Fabian Vogt <fabian@ritter-vogt.de>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the final tree (gpio tree related)
Date: Wed, 05 Mar 2014 17:42:06 +0100
Message-ID: <8059814.9s1EQsUgo4@fabians-laptop.fritz.box>
User-Agent: KMail/4.10.5 (Linux/3.7.10-1.28-desktop; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CACRpkda8qHQRu-JCgdVOHAh+QvjfJB5ftJEEQ66tjePrRCuYzA@mail.gmail.com>
References: <20140305173559.0b50971a1ab88a16bee8819c@canb.auug.org.au> <CACRpkda8qHQRu-JCgdVOHAh+QvjfJB5ftJEEQ66tjePrRCuYzA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="ISO-8859-1"
X-Provags-ID: V02:K0:lxBXwVXWvodeS78JV7BcxxmJ6mDrs3JQ3BHuvr0TUnO
 /cz1ytH2IPBD8i9Ep+D1YgRw1nBpjX/gOHsMN60YQMdqv1SXtp
 e6uD11dYUVcK/3AfqjO31fnouXSdsUXAii1v47cVGLbagF+zRU
 UPyhXZo9QSFG6A8wiHIMKxBf6TL7+nY2YxGDll3uTyECtfvPMJ
 SVcOhjzB8lmIFc2jh7WX0GveR8QBA5iAh3ZsRl++StvRmM1bxC
 D9058xawJLWsRjAXs2MJtrF9iw5yRP0a2vl41pLz6vQUQZSGnW
 oAakpLPafD08B9Nrxk+Lg8ixK8KQFTuRxshrhRQ8hcOQ0CMFQ7
 QwzI6PnQNjRxW+cT+cTj3ZXLEAoMO0XsyXnPHdSke+mkGWRCfZ
 sUA4ho2HYj69w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Mar 5, 2014, 3:16 PM, Linus Walleij wrote:
> On Wed, Mar 5, 2014 at 2:35 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> 
> > After merging the final tree, today's linux-next build (powerpc
> > allyesconfig) failed like this:
> >
> > drivers/gpio/gpio-zevio.c: In function 'zevio_gpio_port_get':
> > drivers/gpio/gpio-zevio.c:70:2: error: implicit declaration of function 'IOMEM' [-Werror=implicit-function-declaration]
> >   return readl(IOMEM(c->chip.regs + section_offset + port_offset));
> >   ^
> > drivers/gpio/gpio-zevio.c:70:2: warning: passing argument 1 of 'readl' makes pointer from integer without a cast [enabled by default]
> > In file included from include/linux/io.h:22:0,
> >                  from drivers/gpio/gpio-zevio.c:15:
> > arch/powerpc/include/asm/io-defs.h:6:16: note: expected 'const volatile void *' but argument is of type 'int'
> >  DEF_PCI_AC_RET(readl, u32, (const PCI_IO_ADDR addr), (addr), mem, addr)
> >                 ^
> 
> Fabian can you suggest a patch adding the proper depends added to
> the Kconfig. Check what things bring in the IOMEM etc that is needed
> to compile this.

It looks like powerpc doesn't have the IOMEM macro (which just casts to "void __iomem*").
Would "depends on ARM && OF_GPIO" be ok?

> Yours,
> Linus Walleij

Bye,
Fabian
