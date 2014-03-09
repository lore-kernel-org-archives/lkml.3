Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752278AbaCIR2m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 13:28:42 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:35281 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703AbaCIR2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 13:28:41 -0400
Date: Sun, 9 Mar 2014 10:28:46 -0700
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: olof@lixom.net, arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] ARM: SoC fixes for 3.14-rc
Message-ID: <20140309172846.GA20640@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit cfbf8d4857c26a8a307fb7cd258074c9dcd8c691:

  Linux 3.14-rc4 (2014-02-23 17:40:03 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/fixes-for-linus

for you to fetch changes up to 10554647b488f58f2c36c78368e9bab4b93da721:

  Merge tag 'omap-for-v3.14/fixes-dt-rc4' of git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap into fixes (2014-03-08 22:56:31 -0800)

----------------------------------------------------------------

ARM: SoC fixes for 3.14-rc

A collection of fixes for ARM platforms. A little large due to us missing to
do one last week, but there's nothing in particular here that is in itself
large and scary.

Mostly a handful of smaller fixes all over the place. The majority is made
up of fixes for OMAP, but there are a few for others as well. In particular,
there was a decision to rename a binding for the Broadcom pinctrl block that
we need to go in before the final release since we then treat it as ABI.

----------------------------------------------------------------
Arnd Bergmann (1):
      Merge tag 'omap-for-v3.14/fixes-rc4' of git://git.kernel.org/.../tmlind/linux-omap into fixes

Christian Daudt (1):
      pinctrl: refer to updated dt binding string.

Illia Smyrnov (1):
      ARM: OMAP4: hwmod: Fix SOFTRESET logic for OMAP4

Javier Martinez Canillas (1):
      ARM: dts: omap3-igep: fix boot fail due wrong compatible match

Marek Belisko (1):
      ARM: dts: omap3-gta04: Add ti,omap36xx to compatible property to avoid problems with booting

Maxime Ripard (2):
      ARM: sun7i: dt: Fix interrupt trigger types
      ARM: sunxi: dt: Change the touchscreen compatibles

Olof Johansson (3):
      Merge tag 'sunxi-fixes-for-3.14' of https://github.com/mripard/linux into fixes
      Merge tag 'bcm-for-3.14-pinctrl-reduced-rename' of git://github.com/broadcom/bcm11351 into fixes
      Merge tag 'omap-for-v3.14/fixes-dt-rc4' of git://git.kernel.org/.../tmlind/linux-omap into fixes

Santosh Shilimkar (1):
      ARM: OMAP: Kill warning in CPUIDLE code with !CONFIG_SMP

Sebastian Reichel (1):
      ARM: OMAP2+: Add support for thumb mode on DT booted N900

Sherman Yin (2):
      Update dtsi with new pinctrl compatible string
      pinctrl: Rename Broadcom Capri pinctrl binding

Stephen Warren (1):
      ARM: tegra: add LED options back into tegra_defconfig

Suman Anna (1):
      ARM: DRA7: hwmod data: correct the sysc data for spinlock

Tomi Valkeinen (1):
      ARM: OMAP2+: clock: fix clkoutx2 with CLK_SET_RATE_PARENT

Tony Lindgren (2):
      Merge tag 'for-v3.14-rc/omap-fixes-a' of git://git.kernel.org/.../pjw/omap-pending into omap-for-v3.14/fixes
      ARM: OMAP3: Fix pinctrl interrupts for core2

Vaibhav Bedia (1):
      ARM: OMAP5: PRM: Fix reboot handling

 ...capri-pinctrl.txt => brcm,bcm11351-pinctrl.txt} |  8 +-
 arch/arm/boot/dts/bcm11351.dtsi                    |  2 +-
 arch/arm/boot/dts/omap3-gta04.dts                  |  2 +-
 arch/arm/boot/dts/omap3-igep0020.dts               |  2 +-
 arch/arm/boot/dts/omap3-igep0030.dts               |  2 +-
 arch/arm/boot/dts/sun4i-a10.dtsi                   |  2 +-
 arch/arm/boot/dts/sun5i-a10s.dtsi                  |  2 +-
 arch/arm/boot/dts/sun5i-a13.dtsi                   |  2 +-
 arch/arm/boot/dts/sun7i-a20.dtsi                   | 12 +--
 arch/arm/configs/tegra_defconfig                   |  3 +
 arch/arm/mach-omap2/cclock3xxx_data.c              |  2 +
 arch/arm/mach-omap2/cpuidle44xx.c                  |  8 +-
 arch/arm/mach-omap2/dpll3xxx.c                     | 92 ++++++++++++++++++----
 arch/arm/mach-omap2/omap_hwmod.c                   | 20 ++---
 arch/arm/mach-omap2/omap_hwmod_7xx_data.c          |  9 +--
 arch/arm/mach-omap2/pdata-quirks.c                 | 21 ++++-
 arch/arm/mach-omap2/prminst44xx.c                  |  4 +-
 drivers/pinctrl/pinctrl-capri.c                    |  2 +-
 include/linux/clk/ti.h                             |  4 +
 19 files changed, 146 insertions(+), 53 deletions(-)
 rename Documentation/devicetree/bindings/pinctrl/{brcm,capri-pinctrl.txt => brcm,bcm11351-pinctrl.txt} (98%)
