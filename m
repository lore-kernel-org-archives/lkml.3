Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932509Ab3GPMi4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 08:38:56 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:48814 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932346Ab3GPMix (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 08:38:53 -0400
Message-ID: <51E53EC2.5080401@ti.com>
Date: Tue, 16 Jul 2013 18:08:26 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "balbi@ti.com" <balbi@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
CC: Kishon Vijay Abraham I <kishon@ti.com>
Subject: [GIT PULL] PHY Framework for 3.12 merge window
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Here's the pull request for the PHY Framework which I've been working on for a
while.

I've applied these patches on the current linux mainline HEAD (which has one
commit after 3.11-rc1 is tagged).

Even before this framework is merged, quite a few people started using it. I've
queued those patches along with the PHY framework as well.

I'm also planning to maintain this framework henceforth and will be sending
pull requests for anything related to this framework or users of this framework.

Let me know if you want any changes on this pull request

Thanks
Kishon

The following changes since commit 47188d39b5deeebf41f87a02af1b3935866364cf:

  Merge tag 'ext4_for_linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4 (2013-07-14 21:47:51
-0700)

are available in the git repository at:


  git://gitorious.org/linuxphy/linuxphy.git tags/phy-for-v3.12

for you to fetch changes up to 827c292242da5723345e5649e38279c721125ca8:

  video: exynos_dp: Use the generic PHY driver (2013-07-16 14:37:04 +0530)

----------------------------------------------------------------
PHY: patches for 3.12 merge window

We're introducing a new kernel wide generic PHY framework.

This framework provides a set of APIs for the PHY drivers to
create/destroy a PHY and APIs for the PHY users to obtain a
reference to the PHY with or without using phandle.

This framework will be of use only to devices that uses external PHY (PHY
functionality is not embedded within the controller).

The intention of creating this framework is to bring the phy drivers spread
all over the Linux kernel to drivers/phy to increase code re-use and for
better code maintainability.

There are already quite a few users for this framework.
Samsung Exynos SoC Display Port PHY and MIPI PHY are some of the early users
of this framework in addition to OMAP-USB2 PHY and TWL4030-USB.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>

----------------------------------------------------------------
Jingoo Han (3):
      phy: Add driver for Exynos DP PHY
      video: exynos_dp: remove non-DT support for Exynos Display Port
      video: exynos_dp: Use the generic PHY driver

Kishon Vijay Abraham I (8):
      drivers: phy: add generic PHY framework
      usb: phy: omap-usb2: use the new generic PHY framework
      usb: phy: twl4030: use the new generic PHY framework
      ARM: OMAP: USB: Add phy binding information
      ARM: dts: omap: update usb_otg_hs data
      usb: musb: omap2430: use the new generic PHY framework
      usb: phy: omap-usb2: remove *set_suspend* callback from omap-usb2
      usb: phy: twl4030-usb: remove *set_suspend* and *phy_init* ops

Sylwester Nawrocki (4):
      phy: Add driver for Exynos MIPI CSIS/DSIM DPHYs
      video: exynos_mipi_dsim: Use the generic PHY driver
      exynos4-is: Use the generic MIPI CSIS PHY driver
      ARM: Samsung: Remove the MIPI PHY setup code

 .../devicetree/bindings/phy/phy-bindings.txt       |   66 +++
 .../devicetree/bindings/phy/samsung-phy.txt        |   22 +
 Documentation/devicetree/bindings/usb/omap-usb.txt |    5 +
 Documentation/devicetree/bindings/usb/usb-phy.txt  |    6 +
 .../devicetree/bindings/video/exynos_dp.txt        |   12 +-
 Documentation/phy.txt                              |  129 +++++
 MAINTAINERS                                        |    7 +
 arch/arm/boot/dts/omap3-beagle-xm.dts              |    2 +
 arch/arm/boot/dts/omap3-evm.dts                    |    2 +
 arch/arm/boot/dts/omap3-overo.dtsi                 |    2 +
 arch/arm/boot/dts/omap4.dtsi                       |    3 +
 arch/arm/boot/dts/twl4030.dtsi                     |    1 +
 arch/arm/mach-exynos/include/mach/regs-pmu.h       |    5 -
 arch/arm/mach-omap2/usb-musb.c                     |    3 +
 arch/arm/mach-s5pv210/include/mach/regs-clock.h    |    4 -
 arch/arm/plat-samsung/Kconfig                      |    5 -
 arch/arm/plat-samsung/Makefile                     |    1 -
 arch/arm/plat-samsung/setup-mipiphy.c              |   60 ---
 drivers/Kconfig                                    |    2 +
 drivers/Makefile                                   |    2 +
 drivers/media/platform/exynos4-is/mipi-csis.c      |   16 +-
 drivers/phy/Kconfig                                |   28 +
 drivers/phy/Makefile                               |    7 +
 drivers/phy/phy-core.c                             |  544 ++++++++++++++++++++
 drivers/phy/phy-exynos-dp-video.c                  |  111 ++++
 drivers/phy/phy-exynos-mipi-video.c                |  169 ++++++
 drivers/usb/musb/Kconfig                           |    1 +
 drivers/usb/musb/musb_core.c                       |    1 +
 drivers/usb/musb/musb_core.h                       |    3 +
 drivers/usb/musb/omap2430.c                        |   26 +-
 drivers/usb/phy/Kconfig                            |    1 +
 drivers/usb/phy/phy-omap-usb2.c                    |   60 ++-
 drivers/usb/phy/phy-twl4030-usb.c                  |   63 ++-
 drivers/video/exynos/Kconfig                       |    2 +-
 drivers/video/exynos/exynos_dp_core.c              |  132 ++---
 drivers/video/exynos/exynos_dp_core.h              |  110 ++++
 drivers/video/exynos/exynos_dp_reg.c               |    2 -
 drivers/video/exynos/exynos_mipi_dsi.c             |   19 +-
 include/linux/phy/phy.h                            |  344 +++++++++++++
 include/linux/platform_data/mipi-csis.h            |   11 +-
 include/linux/usb/musb.h                           |    3 +
 include/video/exynos_dp.h                          |  131 -----
 include/video/exynos_mipi_dsim.h                   |    6 +-
 43 files changed, 1746 insertions(+), 383 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/phy/phy-bindings.txt
 create mode 100644 Documentation/devicetree/bindings/phy/samsung-phy.txt
 create mode 100644 Documentation/phy.txt
 delete mode 100644 arch/arm/plat-samsung/setup-mipiphy.c
 create mode 100644 drivers/phy/Kconfig
 create mode 100644 drivers/phy/Makefile
 create mode 100644 drivers/phy/phy-core.c
 create mode 100644 drivers/phy/phy-exynos-dp-video.c
 create mode 100644 drivers/phy/phy-exynos-mipi-video.c
 create mode 100644 include/linux/phy/phy.h
 delete mode 100644 include/video/exynos_dp.h
