Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757453Ab3DWQca (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 12:32:30 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:60430 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757113Ab3DWQc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 12:32:28 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Chris Ball <cjb@laptop.org>, Dave Airlie <airlied@linux.ie>,
        David Woodhouse <dwmw2@infradead.org>, Felipe Balbi <balbi@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@kernel.org>, Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Stephen Warren <swarren@nvidia.com>, Tony Lindgren <tony@atomide.com>,
        Viresh Kumar <viresh.kumar@st.com>, alsa-devel@alsa-project.org,
        dri-devel@lists.freedesktop.org, linux-mtd@lists.infradead.org,
        linux-usb@vger.kernel.org, spi-devel-general@lists.sourceforge.net
Subject: [PATCH 00/21] ARM build fixes for 3.10
Date: Tue, 23 Apr 2013 18:30:32 +0200
Message-Id: <1366734653-488286-1-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
X-Provags-ID: V02:K0:rs34SXipk5UobjRSdhWX0INEvceyY+It/lq+VNlg4eD
 ATGkd+v8mer1Ikxjxpxsqpd7u9400Mqf3huvkIFrXVhhL4fbh4
 7Phyr4xhuVvxMKN1RBNIVJdYUb8AS8y6Sh1X8agMgwCFLCYOXX
 rkmqpBMKD3mLvvavIhawmgZZNmL1LIG7Mh+8AVZ5YLpTzmVwAo
 GZjQk0pyr6sJM4nEM9f62H4MSb9FU0nxYD0AyOhrTsumrhFiC6
 J2cfwBJN2kJ0xGKZaCMIvXoEeOQb4OZFLPp8AZ7I27KTgKN1af
 h9JjvXBZfrxxFz7JHKeMe2tHazM5McrfdfO4P+2QW8uTvugG80
 g5zkC4qDr2b+IAAfUrBAsB3Ndv6qqgNUmkpiki9fI
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

This is a set of bug fixes for build errors and warnings I am
seeing in the various defconfigs and/or allmodconfig builds
on linux-next. The majority of these showed up because we now
include a lot more platforms in allmodconfig than we used to.

Please apply to appropriate maintainer trees or provide
feedback, I can take care of the rest sending those through
arm-soc that I get no feedback on.

	Arnd

Arnd Bergmann (21):
  Turn off -Wmaybe-uninitialized when building with -Os
  ARM: compressed/head.S: work around new binutils warning
  ARM: use optimized do_div only for EABI
  ARM: kvm: define KVM_ARM_MAX_VCPUS unconditionally
  ARM: OMAP2+: add dependencies on ARCH_MULTI_V6/V7
  ARM: tegra: call cpu_do_idle from C code
  ARM: tegra: unify tegra_idle_device definitions
  ASoC: ux500: forward declare msp_i2s_platform_data
  spi/sirf: fix MODULE_DEVICE_TABLE
  ssb: fix alignment of struct bcma_device_id
  drm/tilcdc: use only a single module device table
  mmc: sdhci-tegra: fix MODULE_DEVICE_TABLE
  misc: mark spear13xx-pcie-gadget as broken
  staging: nvec: allow modular build
  staging: comedi/dawboard2000: use mdelay for large delays
  staging/zsmalloc: don't use pgtable-mapping from modules
  tty/serial/sirf: fix MODULE_DEVICE_TABLE
  usb: phy: tegra: don't call into tegra-ehci directly
  usb: phy: don't mark usb_bind_phy as __init
  MFD: ab8500: export ab8500_gpadc_sw_hw_convert properly
  mtd: omap2: allow bulding as a module

 Makefile                                      |  2 +-
 arch/arm/boot/compressed/Makefile             |  2 +-
 arch/arm/boot/compressed/head.S               | 12 ++++++++++++
 arch/arm/include/asm/div64.h                  |  2 +-
 arch/arm/kvm/Kconfig                          |  6 +++---
 arch/arm/mach-omap2/Kconfig                   |  5 +++++
 arch/arm/mach-tegra/cpuidle-tegra114.c        |  5 ++---
 arch/arm/mach-tegra/cpuidle-tegra20.c         |  4 +---
 arch/arm/mach-tegra/cpuidle-tegra30.c         |  4 +---
 arch/arm/mach-tegra/cpuidle.c                 |  2 ++
 arch/arm/mach-tegra/cpuidle.h                 |  4 ++++
 arch/arm/mach-tegra/pm.c                      |  5 +++++
 arch/arm/mach-tegra/sleep-tegra20.S           |  2 +-
 drivers/gpu/drm/tilcdc/tilcdc_panel.c         |  1 -
 drivers/gpu/drm/tilcdc/tilcdc_slave.c         |  1 -
 drivers/gpu/drm/tilcdc/tilcdc_tfp410.c        |  1 -
 drivers/mfd/ab8500-gpadc.c                    |  2 +-
 drivers/misc/Kconfig                          |  2 +-
 drivers/mmc/host/sdhci-tegra.c                |  2 +-
 drivers/mtd/nand/Kconfig                      |  2 +-
 drivers/spi/spi-sirf.c                        |  2 +-
 drivers/staging/comedi/drivers/daqboard2000.c | 14 +++++++-------
 drivers/staging/nvec/Kconfig                  | 10 +++++-----
 drivers/staging/zsmalloc/zsmalloc-main.c      |  2 +-
 drivers/tty/serial/sirfsoc_uart.c             |  2 +-
 drivers/usb/host/ehci-tegra.c                 | 10 +++++-----
 drivers/usb/otg/otg.c                         |  2 +-
 drivers/usb/phy/tegra_usb_phy.c               | 13 +++++++++----
 include/linux/mod_devicetable.h               |  5 +++--
 include/linux/usb/tegra_usb_phy.h             | 10 +++++-----
 sound/soc/ux500/ux500_msp_i2s.h               |  1 +
 31 files changed, 82 insertions(+), 55 deletions(-)

-- 
1.8.1.2

Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: Chris Ball <cjb@laptop.org>
Cc: Dave Airlie <airlied@linux.ie>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Stephen Warren <swarren@nvidia.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Viresh Kumar <viresh.kumar@st.com>
Cc: alsa-devel@alsa-project.org
Cc: dri-devel@lists.freedesktop.org
Cc: linux-mtd@lists.infradead.org
Cc: linux-usb@vger.kernel.org
Cc: spi-devel-general@lists.sourceforge.net
