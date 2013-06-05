Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932730Ab3FEVYU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 17:24:20 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:64955 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932475Ab3FEVYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:24:16 -0400
MIME-Version: 1.0
In-Reply-To: <51AFA6DD.3000202@wwwdotorg.org>
References: <CAPweEDx3mAy40BZrzrKPRbvg7vKMj7KevDQ3m_v4p6Yo50eSGg@mail.gmail.com>
	<CAKON4OxDD5orX2w-_+d5kawTGXbE3KKj2QLERo9m7=NiUSXhgQ@mail.gmail.com>
	<51AFA6DD.3000202@wwwdotorg.org>
Date: Wed, 5 Jun 2013 22:24:15 +0100
X-Google-Sender-Auth: Pj2uWyJfkrM0pOh75sQAaSqlvKg
Message-ID: <CAPweEDz=hFxXW3XF9CSNZpEFSjayb5an1E8Xze1_uQcCZONVxg@mail.gmail.com>
Subject: Re: getting allwinner SoC support upstream (was Re: Uploading linux (3.9.4-1))
From: Luke Kenneth Casson Leighton <lkcl@lkcl.net>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: "jonsmirl@gmail.com" <jonsmirl@gmail.com>,
        devicetree-discuss <devicetree-discuss@ozlabs.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        debian-arm@lists.debian.org,
        Linux on small ARM machines 
	<arm-netbook@lists.phcomp.co.uk>,
        ARM Linux Mailing List <linux-arm-kernel@lists.infradead.org>,
        debian-kernel@lists.debian.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ please remove debian-release from future replies!  my mistake -
please don't propagate it, thanks ]

On Wed, Jun 5, 2013 at 10:00 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 06/05/2013 02:46 PM, jonsmirl@gmail.com wrote:
>> On Wed, Jun 5, 2013 at 3:46 PM, Luke Kenneth Casson Leighton
>> <lkcl@lkcl.net <mailto:lkcl@lkcl.net>> wrote:
> ...
>>     the detect line, which is the write-protect line, to setting the DRAM
>>     clock timings, saying which kernel driver must be loaded to support
>>     the touchscreen, enabling debugging, JTAG, naming the GPIOs for easy
>>     and convenient use in the kernel code: basically there isn't a single
>>     piece of hardware on the allwinner SoC family which *isn't*
>>     reconfigureable through script.fex... and they've even integrated it
>>     into u-boot *and* their low-level (early) bootloader as well [which
>>
>>
>> Device tree support has been integrated into uboot for about five years now.
>
> There are two aspects to DT support in U-Boot:
>
> 1) Having U-Boot pass a DT to the kernel, possibly manipulating a few
> properties on the way, e.g. RAM size. As you say, this has been around a
> while.
>
> 2) Having U-Boot itself read a DT and configure itself, just like the
> kernel does. This is relatively new, and only supported by a few boards
> (all Tegra to some extent, and a couple each Samsung Exynos and Xilinx
> boards). I suspect/guess this is the kind of thing that Luke was
> referring to re: U-Boot fex integration.

  https://github.com/linux-sunxi/u-boot-sunxi

 And Then Some, stephen.  there are two versions of u-boot being used:
one is the community-assembled [GPL-compliant] one, and the other
includes a [as-of-a-few-days-ago-but-no-longer, yay!]
formerly-GPL-violating one from allwinner.

 the community-based one *doesn't* have fex integration (i don't
think, but henrik will know for sure), but the allwinner one
definitely does.

 .... and then there's the boot0 and boot1 loaders, these *do* have
fex integration: they're absolutely tiny and they're designed to fit
into the 1st level cache.  the job of these bootloaders is to set up
the DDR3 RAM timings (so that you can access DRAM!!) and to then
decide whether to load from NAND, SD/MMC etc. and many other things.

 these boot0 and boot1 loaders are themselves configureable so that
you can specify, through script.fex, what GPIO is to be the "reset
key" and so on.  that's a much simplified story btw.

 so the point is: if anyone wishes me to propose to allwinner that
they convert over to devicetree, or any other proposal which involves
significant low-level changes to their working practices that could
potentially have a massive knock-on effect onto their
multi-million-dollar clients, it had better be a damn good story.

l.
