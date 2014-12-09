Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993AbaLIVYQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 16:24:16 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:64445 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729AbaLIVYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 16:24:14 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL 1/9] ARM: SoC non-critical bug fixes for 3.19
Date: Tue, 09 Dec 2014 22:22:21 +0100
Message-ID: <4358286.jYCatVeXCJ@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <4491193.a6KEQb1tZH@wuerfel>
References: <4491193.a6KEQb1tZH@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:CC+wXBSJUlLQnarlVML+wcKQxMbVZ9tGELcsE89qGb/CQCjs9XO
 VqTuLDFv2hZpW6Pm7mWi9jP3YIb1LvZ9WV7iWWZOZ9xU90PrPS4jkKstqUdeOC4jr1VoB+s
 txfXbmMlsg5pkR+ORprP3KPPm+uYWZ8QKLDVj1jMN2iYMAf9Eyjcd/CzLcXsUBg0ulWtIUh
 gmf2MFcXdffYMtFQpYg0w==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 0df1f2487d2f0d04703f142813d53615d62a1da4:

  Linux 3.18-rc3 (2014-11-02 15:01:51 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/fixes-nc-for-linus

for you to fetch changes up to 65bb688aab9424849e94f74d555542fa76cd3d5a:

  ARM: imx6: fix bogus use of irq_get_irq_data (2014-12-04 23:24:51 -0800)

----------------------------------------------------------------
ARM: SoC non-critical bug fixes for 3.19

These are bug fixes for harmless problems that were not important
enough to get fixed in 3.19. This contains updates to the MAINTAINERS
file, in particular:

- Ben Dooks stepped down as Samsung co-maintainer (thanks Ben for
  long years of maintaining this). Kukjin Kim, who has been
  doing the work de-facto by himself recently is now the
  only maintainer.
- Liviu, Sudeep and Lorenzo from ARM now officially maintain the
  Versatile Express platform, which was orphaned (thanks for
- Gregory Fong and Florian Fainelli help out on the Broadcom BCM7XXX
  platform
- Ray Jui and Scott Branden are the future maintainers for the
  newly merged Broadcom Cygnus platform. Welcome!

In terms of actual fixes, we have the usual set of OMAP bug fixes,
which Tony Lindgren separates out well from the other OMAP changes,
one really ep93xx regression fix against 3.11 that didn't make it for
3.18, a few GIC changes from Marc Zyngier as a preparation for
later rework (the current code is wrong in a harmless way), on
Tegra regression and one samsung spelling fix.

----------------------------------------------------------------
Arnd Bergmann (4):
      Merge tag 'omap-for-v3.19/fixes-not-urgent-part1' of git://git.kernel.org/.../tmlind/linux-omap into next/fixes-non-critical
      Merge tag 'arm-soc/for-3.19/cygnus-maintainers-v2' of http://github.com/brcm/linux into next/fixes-non-critical
      Merge tag 'samsung-fixes-v3.19' of git://git.kernel.org/.../kgene/linux-samsung into next/fixes-non-critical
      Merge tag 'tegra-for-3.19-soc' of git://git.kernel.org/.../tegra/linux into next/fixes-non-critical

Dmitry Osipenko (1):
      ARM: tegra: Re-add removed SoC id macro to tegra_resume()

Florian Fainelli (2):
      MAINTAINERS: update brcmstb entries
      MAINTAINERS: add entry for the GISB arbiter driver

H Hartley Sweeten (1):
      arm: ep93xx: add dma_masks for the M2P and M2M DMA controllers

Kukjin Kim (1):
      MAINTAINERS: update email address and cleanup for exynos entry

Marc Zyngier (2):
      ARM: imx: irq: fix buggy usage of irq_data irq field
      ARM: imx6: fix bogus use of irq_get_irq_data

Masanari Iida (1):
      ARM: OMAP2: Remove unnecessary KERN_* in omap_phy_internal.c

NeilBrown (1):
      ARM: OMAP: serial: remove last vestige of DTR_gpio support.

Pankaj Dubey (1):
      ARM: EXYNOS: fix typo in static struct name "exynos5_list_diable_wfi_wfe"

Pawel Moll (2):
      MAINTAINERS: ARM Versatile Express platform
      MAINTAINERS: ARM Versatile Express platform, add missing pattern

Peter Griffin (1):
      MAINTAINERS: Add ahci_st.c to ARCH/STI architecture

Roger Quadros (1):
      ARM: OMAP2+: gpmc: Get rid of "ti,elm-id not found" warning

Scott Branden (1):
      MAINTAINERS: Entry for Cygnus/iproc arm architecture

Tony Lindgren (5):
      ARM: OMAP3: Fix errors for omap_l3_smx when booted with device tree
      ARM: dts: Fix NAND last partition size on LDP
      ARM: dts: Add twl keypad map for LDP
      ARM: dts: Add twl keypad map for omap3 EVM
      ARM: OMAP4+: Remove unused omap_l3_noc platform init

 MAINTAINERS                               | 47 +++++++++++++++++++++++--------
 arch/arm/boot/dts/omap3-evm-common.dtsi   | 21 ++++++++++++++
 arch/arm/boot/dts/omap3-ldp.dts           | 23 ++++++++++++++-
 arch/arm/boot/dts/omap3.dtsi              |  2 +-
 arch/arm/mach-ep93xx/dma.c                | 12 ++++++--
 arch/arm/mach-exynos/pmu.c                |  8 +++---
 arch/arm/mach-imx/common.h                |  4 +--
 arch/arm/mach-imx/gpc.c                   | 42 ++++++++++++++++-----------
 arch/arm/mach-imx/pm-imx6.c               |  5 ++--
 arch/arm/mach-omap2/devices.c             | 36 +----------------------
 arch/arm/mach-omap2/gpmc.c                |  2 --
 arch/arm/mach-omap2/omap_phy_internal.c   |  8 ++++--
 arch/arm/mach-omap2/serial.c              |  3 --
 arch/arm/mach-tegra/reset-handler.S       |  1 +
 drivers/bus/omap_l3_smx.c                 | 26 +++++++++++++----
 include/linux/platform_data/serial-omap.h |  3 --
 16 files changed, 151 insertions(+), 92 deletions(-)

