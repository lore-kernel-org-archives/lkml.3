Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751268Ab3IJSkl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 14:40:41 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:61913 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873Ab3IJSkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 14:40:39 -0400
MIME-Version: 1.0
In-Reply-To: <CACxGe6v8hO4sRX_KGcH=YBAMrF8mQHqWdxXEvVwoC2pVS5Yv9Q@mail.gmail.com>
References: <CACxGe6v8hO4sRX_KGcH=YBAMrF8mQHqWdxXEvVwoC2pVS5Yv9Q@mail.gmail.com>
Date: Tue, 10 Sep 2013 11:40:39 -0700
Message-ID: <CA+bK7J5cAWFPLTBR2afNLm2JaKFH4_dJO_NpVL5gom0iX+L2dQ@mail.gmail.com>
Subject: Re: [GIT PULL] Device tree updates for v3.12
From: Tim Bird <tbird20d@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

How much time does it add to boot to feed the device tree into the
random number pool.

Some of the device trees are expected to get pretty big.  If it's over
a millisecond,
IMHO, it should be configurable (but this is not).
 -- Tim

On Tue, Sep 10, 2013 at 11:00 AM, Grant Likely
<grant.likely@secretlab.ca> wrote:
> Hi Linus,
>
> Pretty minor stuff here. Please pull.
>
> g.
>
> The following changes since commit d8dfad3876e4386666b759da3c833d62fb8b2267:
>
>   Linux 3.11-rc7 (2013-08-25 17:43:22 -0700)
>
> are available in the git repository at:
>
>   git://git.secretlab.ca/git/linux tags/devicetree-for-linus
>
> for you to fetch changes up to 2bc552df76d83cf1455ac8cf4c87615bfd15df74:
>
>   of/platform: add error reporting to of_amba_device_create()
> (2013-09-09 17:04:52 +0100)
>
> ----------------------------------------------------------------
> Device tree core updates for v3.12
>
> Generally minor changes. A bunch of bug fixes, particularly for
> initialization and some refactoring. Most notable change if feeding the
> entire flattened tree into the random pool at boot. May not be
> significant, but shouldn't hurt either.
>
> ----------------------------------------------------------------
> Alexander Shiyan (1):
>       dt: Typo fix
>
> Anton Blanchard (1):
>       of: Feed entire flattened device tree into the random pool
>
> Bartlomiej Zolnierkiewicz (1):
>       of/platform: add error reporting to of_amba_device_create()
>
> Geert Uytterhoeven (1):
>       of: Make of_get_phy_mode() return int i.s.o. const int
>
> Grant Likely (5):
>       Merge tag 'v3.11-rc7' into devicetree/next
>       of: consolidate definition of early_init_dt_alloc_memory_arch()
>       of: Fix missing memory initialization on FDT unflattening
>       of/fdt: Remove duplicate memory clearing on FDT unflattening
>       of/fdt: Clean up casting in unflattening path
>
> Laxman Dewangan (1):
>       include: dt-binding: input: create a DT header defining key codes.
>
> Mark Brown (1):
>       of/platform: Staticize of_platform_device_create_pdata()
>
> Santosh Shilimkar (1):
>       of: Specify initrd location using 64-bit
>
> Sebastian Andrzej Siewior (1):
>       OF: make of_property_for_each_{u32|string}() use parameters if
> OF is not enabled
>
> Stephen Warren (5):
>       of: move documentation of of_parse_phandle_with_args
>       of: move of_parse_phandle()
>       of: introduce of_parse_phandle_with_fixed_args
>       of: call __of_parse_phandle_with_args from of_parse_phandle
>       gpio: implement gpio-ranges binding document fix
>
> Yijing Wang (1):
>       irq/of: Fix comment typo for irq_of_parse_and_map
>
>  .../devicetree/bindings/net/can/sja1000.txt        |   2 +-
>  arch/arc/kernel/devtree.c                          |   6 -
>  arch/arc/mm/init.c                                 |   5 +-
>  arch/arm/mm/init.c                                 |   2 +-
>  arch/arm64/kernel/setup.c                          |   5 -
>  arch/arm64/mm/init.c                               |   3 +-
>  arch/c6x/kernel/devicetree.c                       |   8 +-
>  arch/metag/mm/init.c                               |   5 +-
>  arch/microblaze/kernel/prom.c                      |   8 +-
>  arch/mips/kernel/prom.c                            |   3 +-
>  arch/openrisc/kernel/prom.c                        |   8 +-
>  arch/powerpc/kernel/prom.c                         |   8 +-
>  arch/x86/kernel/devicetree.c                       |   3 +-
>  arch/xtensa/kernel/setup.c                         |   3 +-
>  drivers/gpio/gpiolib-of.c                          |   4 +-
>  drivers/of/base.c                                  | 200 +++++---
>  drivers/of/fdt.c                                   |  98 ++--
>  drivers/of/irq.c                                   |   2 +-
>  drivers/of/of_net.c                                |   2 +-
>  drivers/of/platform.c                              |  21 +-
>  include/dt-bindings/input/input.h                  | 525 +++++++++++++++++++++
>  include/linux/of.h                                 |  49 +-
>  include/linux/of_fdt.h                             |   3 +-
>  include/linux/of_net.h                             |   4 +-
>  24 files changed, 787 insertions(+), 190 deletions(-)
>  create mode 100644 include/dt-bindings/input/input.h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
 -- Tim Bird
Senior Software Engineer, Sony Mobile
Architecture Group Chair, CE Workgroup, Linux Foundation
