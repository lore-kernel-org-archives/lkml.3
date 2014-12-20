Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892AbaLTOK7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 09:10:59 -0500
Received: from mail-oi0-f46.google.com ([209.85.218.46]:49748 "EHLO
	mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163AbaLTOKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 09:10:55 -0500
MIME-Version: 1.0
Date: Sat, 20 Dec 2014 15:10:54 +0100
X-Google-Sender-Auth: Dck2FQbr-XATWuxBjzHB61s_NqQ
Message-ID: <CAJZ5v0g=pxQKs0MhBETm9jL6cBF-hE8Mt=z4U=7AU7oZoELYxw@mail.gmail.com>
Subject: [GIT PULL] CONFIG_PM_RUNTIME elimination for 3.19-rc1
From: "Rafael J. Wysocki" <rafael@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from

 git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git \
 pm-config-3.19-rc1

to receive material that finalizes the CONFIG_PM_RUNTIME elimination
for v3.19-rc1 with top-most commit 464ed18ebdb6236fcff59d2a35d4d2e28

 PM: Eliminate CONFIG_PM_RUNTIME

on top of commit c0f486fde3f353232c1cc2fd4d62783ac782a467

 Merge tag 'pm+acpi-3.19-rc1-2' of
git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm

This removes the last few uses of CONFIG_PM_RUNTIME introduced
recently and makes that config option finally go away.

CONFIG_PM will be available directly from the menu now and
also it will be selected automatically if CONFIG_SUSPEND or
CONFIG_HIBERNATION is set.

Thanks!

---------------

Rafael J. Wysocki (4):
      spi: Replace CONFIG_PM_RUNTIME with CONFIG_PM
      sound: sst-haswell-pcm: Replace CONFIG_PM_RUNTIME with CONFIG_PM
      tty: 8250_omap: Replace CONFIG_PM_RUNTIME with CONFIG_PM
      PM: Eliminate CONFIG_PM_RUNTIME

---------------

 arch/arm/configs/ape6evm_defconfig         |  2 +-
 arch/arm/configs/armadillo800eva_defconfig |  2 +-
 arch/arm/configs/bcm_defconfig             |  2 +-
 arch/arm/configs/bockw_defconfig           |  2 +-
 arch/arm/configs/davinci_all_defconfig     |  2 +-
 arch/arm/configs/exynos_defconfig          |  2 +-
 arch/arm/configs/ezx_defconfig             |  1 -
 arch/arm/configs/hisi_defconfig            |  2 +-
 arch/arm/configs/imote2_defconfig          |  1 -
 arch/arm/configs/imx_v6_v7_defconfig       |  2 +-
 arch/arm/configs/keystone_defconfig        |  2 +-
 arch/arm/configs/kzm9g_defconfig           |  2 +-
 arch/arm/configs/lager_defconfig           |  2 +-
 arch/arm/configs/mackerel_defconfig        |  1 -
 arch/arm/configs/marzen_defconfig          |  2 +-
 arch/arm/configs/omap1_defconfig           |  1 -
 arch/arm/configs/prima2_defconfig          |  2 +-
 arch/arm/configs/sama5_defconfig           |  2 +-
 arch/arm/configs/shmobile_defconfig        |  2 +-
 arch/arm/configs/sunxi_defconfig           |  2 +-
 arch/arm/configs/tegra_defconfig           |  2 +-
 arch/arm/configs/u8500_defconfig           |  2 +-
 arch/arm/configs/vt8500_v6_v7_defconfig    |  2 +-
 arch/arm/mach-omap2/Kconfig                |  6 +++---
 arch/mips/configs/db1xxx_defconfig         |  2 +-
 arch/mips/configs/lemote2f_defconfig       |  1 -
 arch/mips/configs/loongson3_defconfig      |  2 +-
 arch/mips/configs/nlm_xlp_defconfig        |  2 +-
 arch/mips/configs/nlm_xlr_defconfig        |  2 +-
 arch/powerpc/configs/ps3_defconfig         |  2 +-
 arch/sh/Kconfig                            |  2 +-
 arch/sh/configs/apsh4ad0a_defconfig        |  2 +-
 arch/sh/configs/sdk7786_defconfig          |  2 +-
 drivers/spi/spi-img-spfi.c                 |  4 ++--
 drivers/spi/spi-meson-spifc.c              |  4 ++--
 drivers/tty/serial/8250/8250_omap.c        | 14 +++++++-------
 drivers/usb/host/isp1760-hcd.c             |  2 +-
 drivers/usb/host/oxu210hp-hcd.c            |  2 +-
 include/linux/devfreq.h                    |  2 +-
 kernel/power/Kconfig                       | 16 ++++++----------
 sound/soc/intel/sst-haswell-pcm.c          |  4 ++--
 41 files changed, 52 insertions(+), 61 deletions(-)
