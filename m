Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794Ab3AXLMA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 06:12:00 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:16415 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754378Ab3AXLK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 06:10:56 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 24 Jan 2013 03:10:53 -0800
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: <linux-tegra@vger.kernel.org>
CC: Hiroshi Doyu <hdoyu@nvidia.com>, Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Olof Johansson <olof@lixom.net>, Jason Cooper <jason@lakedaemon.net>,
        Shawn Guo <shawn.guo@linaro.org>, Andrew Lunn <andrew@lunn.ch>,
        Kukjin Kim <kgene.kim@samsung.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [v4 0/6] ARM: Initial support for Tegra114 SoC
Date: Thu, 24 Jan 2013 13:10:20 +0200
Message-ID: <1359025829-22306-1-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patchset adds initial support for NVIDIA's new Tegra114 SoC
(T114) based on the ARM Cortex-A15 MP. This has the minimal support to
allow the kernel to boot up into shell console. This can be used as a
basis for adding other device drivers for this SoC. Currently there
are 2 evaluation boards available, "Dalmore" and "Pluto".

For those who want to try:

  $ make ARCH=arm tegra_defconfig
  $ scripts/config -e ARCH_TEGRA_114_SOC -d SMP -d DRM -d SUSPEND \
    	-d PM_RUNTIME -d CPU_FREQ -d CPU_IDLE -d HOTPLUG_CPU
  $ make ARCH=arm menuconfig # if needed to configure more
  $ make ARCH=arm all -j9

You may also want to enable CONFIG_ARM_APPENDED_DTB and
CONFIG_ARM_ATAG_DTB_COMPAT if the bootloader doesn't support DT yet.

Verified that this single image booted up with "Dalmore(T114)",
"Pluto(T114)" and "Cardhu(T30)". For "Cardhu(T30)" with this single
image, SPI driver doesn't seem to afford the above configuration , it
hangs at boot-up. With SPI disabled, it's ok.

The following changes since commit ac8963ed5d41573c724ce6c1e17f5182d476f2e6:

  ARM: tegra: Add CPU nodes to Tegra30 device tree (2013-01-23 10:16:18 -0700)

are available in the git repository at:

  git://nv-tegra.nvidia.com/user/hdoyu/linux.git tegra114-base

for you to fetch changes up to ce08503daaffdffd00e8ebdea8c425d68f287efb:

  ARM: tegra: Add initial support for Tegra114 SoC. (2013-01-24 10:10:12 +0200)

----------------------------------------------------------------
v4:
Rebased onto Stephen's for-3.9/soc(inc. CCF)
Removed SCU related pathces.

v3:
Rebased onto next-20130115.
Dropped TSC/arch timer patch.
Use /cpus entry in DT to detect cpu core #.

v2:
Rebased against the latest Stephen Warren's linux-next_common
Add /cpus entry in DT
Add comment to initialize TSC only in secure mode.

Hiroshi Doyu (6):
      ARM: tegra: Use DT /cpu node to detect number of CPU core
      ARM: tegra: fuse: Add chip ID Tegra114 0x35
      ARM: dt: tegra114: Add new SoC base, Tegra114 SoC
      ARM: dt: tegra114: Add new board, Dalmore
      ARM: dt: tegra114: Add new board, Pluto
      ARM: tegra: Add initial support for Tegra114 SoC.

 arch/arm/boot/dts/Makefile              |    4 +-
 arch/arm/boot/dts/tegra114-dalmore.dts  |   21 ++++++
 arch/arm/boot/dts/tegra114-pluto.dts    |   21 ++++++
 arch/arm/boot/dts/tegra114.dtsi         |  114 +++++++++++++++++++++++++++++++
 arch/arm/mach-tegra/Kconfig             |   10 +++
 arch/arm/mach-tegra/Makefile            |    1 +
 arch/arm/mach-tegra/board-dt-tegra114.c |   48 +++++++++++++
 arch/arm/mach-tegra/common.c            |    1 +
 arch/arm/mach-tegra/fuse.h              |    1 +
 arch/arm/mach-tegra/platsmp.c           |   15 ----
 10 files changed, 220 insertions(+), 16 deletions(-)
 create mode 100644 arch/arm/boot/dts/tegra114-dalmore.dts
 create mode 100644 arch/arm/boot/dts/tegra114-pluto.dts
 create mode 100644 arch/arm/boot/dts/tegra114.dtsi
 create mode 100644 arch/arm/mach-tegra/board-dt-tegra114.c
