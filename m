Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751496Ab3IXIOy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 04:14:54 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:48091 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730Ab3IXIOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 04:14:49 -0400
Date: Tue, 24 Sep 2013 17:14:46 +0900
From: Simon Horman <horms@verge.net.au>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Tony Lindgren <tony@atomide.com>, Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Magnus Damm <magnus.damm@gmail.com>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, openezx-devel@lists.openezx.org,
        linux-samsung-soc@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 00/10] pwm-backlight: Add GPIO and power supply support
Message-ID: <20130924081446.GA11981@verge.net.au>
References: <1379972467-11243-1-git-send-email-treding@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379972467-11243-1-git-send-email-treding@nvidia.com>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Cc: Olof Johansson, Kevin Hilman and Arnd Bergman: arm-soc maintainers ]

On Mon, Sep 23, 2013 at 11:40:57PM +0200, Thierry Reding wrote:
> This series adds the ability to specify a GPIO and a power supply to
> enable a backlight.
> 
> Patch 1 refactors the power on and power off sequences into separate
> functions in preparation for subsequent patches.
> 
> Patch 2 adds an optional GPIO to enable a backlight. This patch only
> includes the field within the platform data so that it can be properly
> setup before actually being put to use.
> 
> Patches 3 to 7 convert all users of the pwm-backlight driver to use the
> new field. For most of them, this just initializes the field to -1,
> marking the field as unused.
>
> Patch 8 uses the new field within the pwm-backlight driver and at the
> same time allows it to be parsed from device tree.
> 
> Patch 9 implements support for an optional power supply. This relies on
> the regulator core to return a dummy regulator when no supply has been
> otherwise setup so the driver doesn't have to handle that specially nor
> require all users to be updated.
> 
> Patch 10 adds a way to keep a backlight turned off at boot. This is
> useful when hooking up a backlight with a subsystem such as DRM which
> has more explicit semantics as to when a backlight should be turned on.
> 
> Due to the dependencies within the series, I propose to take all these
> patches through the PWM tree, so I'll need acks from OMAP, PXA, Samsung,
> shmobile and Unicore32 maintainers.

I received some feedback regarding shmobile conflicts when
arm-soc was merged between v3.11 and v3.12-rc1. With this
in mind I now have a strong preference for changes inside
arch/arm/mach-shmobile/ to be taken through my renesas
tree and thus more importantly through arm-soc if possible.

> Thierry
> 
> Thierry Reding (10):
>   pwm-backlight: Refactor backlight power on/off
>   pwm-backlight: Add optional enable GPIO
>   ARM: OMAP: Initialize PWM backlight enable_gpio field
>   ARM: pxa: Initialize PWM backlight enable_gpio field
>   ARM: SAMSUNG: Initialize PWM backlight enable_gpio field
>   ARM: shmobile: Initialize PWM backlight enable_gpio field
>   unicore32: Initialize PWM backlight enable_gpio field
>   pwm-backlight: Use new enable_gpio field
>   pwm-backlight: Use an optional power supply
>   pwm-backlight: Allow backlight to remain disabled on boot
> 
>  .../bindings/video/backlight/pwm-backlight.txt     |   6 +
>  arch/arm/mach-omap2/board-zoom-peripherals.c       |   1 +
>  arch/arm/mach-pxa/cm-x300.c                        |   1 +
>  arch/arm/mach-pxa/colibri-pxa270-income.c          |   1 +
>  arch/arm/mach-pxa/ezx.c                            |   1 +
>  arch/arm/mach-pxa/hx4700.c                         |   1 +
>  arch/arm/mach-pxa/lpd270.c                         |   1 +
>  arch/arm/mach-pxa/magician.c                       |   1 +
>  arch/arm/mach-pxa/mainstone.c                      |   1 +
>  arch/arm/mach-pxa/mioa701.c                        |   1 +
>  arch/arm/mach-pxa/palm27x.c                        |   1 +
>  arch/arm/mach-pxa/palmtc.c                         |  35 +----
>  arch/arm/mach-pxa/palmte2.c                        |   1 +
>  arch/arm/mach-pxa/pcm990-baseboard.c               |   1 +
>  arch/arm/mach-pxa/raumfeld.c                       |   1 +
>  arch/arm/mach-pxa/tavorevb.c                       |   2 +
>  arch/arm/mach-pxa/viper.c                          |   1 +
>  arch/arm/mach-pxa/z2.c                             |   2 +
>  arch/arm/mach-pxa/zylonite.c                       |   1 +
>  arch/arm/mach-s3c24xx/mach-h1940.c                 |   1 +
>  arch/arm/mach-s3c24xx/mach-rx1950.c                |   1 +
>  arch/arm/mach-s3c64xx/mach-crag6410.c              |   1 +
>  arch/arm/mach-s3c64xx/mach-hmt.c                   |   1 +
>  arch/arm/mach-s3c64xx/mach-smartq.c                |   1 +
>  arch/arm/mach-s3c64xx/mach-smdk6410.c              |   1 +
>  arch/arm/mach-s5p64x0/mach-smdk6440.c              |   1 +
>  arch/arm/mach-s5p64x0/mach-smdk6450.c              |   1 +
>  arch/arm/mach-s5pc100/mach-smdkc100.c              |   1 +
>  arch/arm/mach-s5pv210/mach-smdkv210.c              |   1 +
>  arch/arm/mach-shmobile/board-armadillo800eva.c     |   1 +
>  arch/arm/plat-samsung/dev-backlight.c              |   5 +
>  arch/unicore32/kernel/puv3-nb0916.c                |   1 +
>  drivers/video/backlight/pwm_bl.c                   | 142 ++++++++++++++++-----
>  include/linux/pwm_backlight.h                      |   7 +
>  34 files changed, 162 insertions(+), 64 deletions(-)
> 
> -- 
> 1.8.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sh" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
