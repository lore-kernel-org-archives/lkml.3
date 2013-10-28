Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516Ab3J1NmW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 09:42:22 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:47159 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756072Ab3J1NmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 09:42:19 -0400
MIME-Version: 1.0
In-Reply-To: <1382365111-6533-1-git-send-email-t.stanislaws@samsung.com>
References: <1382365111-6533-1-git-send-email-t.stanislaws@samsung.com>
Date: Mon, 28 Oct 2013 22:42:18 +0900
X-Google-Sender-Auth: tz_8OjXdOBp24eJxAwMiyd-JSxY
Message-ID: <CAAQKjZNmmn0rs10456GQ20zZJLp0Qh3Q4i2_eRqERmxyhLZWSQ@mail.gmail.com>
Subject: Re: [RFC 00/12] Add DRM Exynos HDMI on SoCs from Exynos4 family
From: Inki Dae <inki.dae@samsung.com>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>, mturquette@linaro.org,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz,

I have merged the re-factoring patch set from Sean Paul. Can you
re-base your patch set at top of exynos-drm-next?

Thanks,
Inki Dae

2013/10/21 Tomasz Stanislawski <t.stanislaws@samsung.com>:
> This patchset adds support for HDMI at SoCs from Exynos4 family. The patches
> are rebased on kishon/next. Additionally, The patchset contains small fixes to
> PHY and CLK frameworks.  I preferred to keep all the patches together for the
> first version of the RFC.
>
> The interesting part might be 'propagation of clk_set_parent()'.  This feature
> allows to remove the usage of artificial clocks in drivers.  Such a situation
> happens for Exynos HDMI and 'mout_hdmi' where the clock is not even mentioned in
> some versions of SoC's documentation. Since enabling and setting rate can be
> propagated I think that clk_set_parent() should also be propagated. This would
> simplify driver's code and make it less dependant on SoC's version.
>
> Another interesting feature refers to simple PHY driver.  This driver register
> a PHY interface that operates by setting a special bit in platform register.
> This situation is very common in Exynos SoCs.  The current version supports
> only one phy per node.  The code might be modified to support multiple phys
> from single simple-phy provider to avoid creation of multiple nodes in DT.
>
> All comments are welcome.
>
> Regards,
> Tomasz Stanislawski
>
>
> Tomasz Stanislawski (12):
>   clk: propagate parent change up one level
>   clk: exynos4: export sclk_hdmiphy clock
>   clk: exynos4: enable clk_set_parent() propagation for sclk_hdmi and
>     sclk_mixer clocks
>   phy: Add simple-phy driver
>   phy: use of_phy_simple_xlate for NULL xlate function
>   Revert "drm/exynos: add mout_hdmi clock in hdmi driver to change
>     parent"
>   drm: exynos: hdmi: use hdmiphy as PHY
>   drm: exynos: hdmi: simplify extracting hpd-gpio from DT
>   drm: exynos: add compatibles for HDMI and Mixer chips and exynos4210
>     SoC
>   arm: dts: exynos4: add i2c controller for HDMIPHY
>   arm: dts: exynos4: add HDMI devices
>   arm: dts: universal_c210: add HDMI devices
>
>  .../devicetree/bindings/clock/exynos4-clock.txt    |    1 +
>  arch/arm/boot/dts/exynos4.dtsi                     |   43 +++++++
>  arch/arm/boot/dts/exynos4210-universal_c210.dts    |   53 ++++++++
>  arch/arm/boot/dts/exynos4210.dtsi                  |    4 +
>  drivers/clk/clk.c                                  |    6 +
>  drivers/clk/samsung/clk-exynos4.c                  |   10 +-
>  drivers/gpu/drm/exynos/exynos_hdmi.c               |   41 +++----
>  drivers/gpu/drm/exynos/exynos_mixer.c              |    3 +
>  drivers/phy/Kconfig                                |    5 +
>  drivers/phy/Makefile                               |    1 +
>  drivers/phy/phy-core.c                             |    2 +-
>  drivers/phy/phy-simple.c                           |  128 ++++++++++++++++++++
>  include/linux/clk-provider.h                       |    1 +
>  13 files changed, 269 insertions(+), 29 deletions(-)
>  create mode 100644 drivers/phy/phy-simple.c
>
> --
> 1.7.9.5
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
