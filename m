Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055AbaA1Xgg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 18:36:36 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:19772 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755045AbaA1Xge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 18:36:34 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 28 Jan 2014 15:35:30 -0800
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 0/6] efuse driver for Tegra
Date: Wed, 29 Jan 2014 01:36:10 +0200
Message-ID: <1390952176-30402-1-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver allows userspace to read the raw efuse data. Its userspace
interface is modelled after the sunxi_sid driver which provides similar
functionality for some Allwinner SoCs. It has been tested on
Tegra20 (ventana), Tegra30 (beaverboard) and Tegra114 (dalmore).

Changes since v1:

* Add documentation for sysfs interface
* Cleanup messages

Changes since v2:

* Incorporate early fuse code
* Remove module support
* Make driver always build when Tegra platform is selected
* Add DT binding document
* Address comments on v2

TODO:
* test on Tegra124 (venice2) 

Peter De Schrijver (6):
  ARM: tegra: export apb dma readl/writel
  ARM: tegra: Add chipid, revision and fuse init
  misc: fuse: Add efuse driver for Tegra
  ARM: tegra: Add efuse bindings
  misc: enable fuse drivers
  ARM: tegra: remove fuse files from mach-tegra

 Documentation/ABI/testing/sysfs-driver-tegra-fuse  |    8 +
 .../devicetree/bindings/fuse/fuse-tegra.txt        |   32 +++
 arch/arm/boot/dts/tegra114.dtsi                    |    7 +
 arch/arm/boot/dts/tegra124.dtsi                    |    7 +
 arch/arm/boot/dts/tegra20.dtsi                     |    7 +
 arch/arm/boot/dts/tegra30.dtsi                     |    7 +
 arch/arm/mach-tegra/Makefile                       |    4 -
 arch/arm/mach-tegra/apbio.c                        |   51 ++--
 arch/arm/mach-tegra/cpuidle.c                      |    2 +-
 arch/arm/mach-tegra/flowctrl.c                     |    2 +-
 arch/arm/mach-tegra/fuse.c                         |  252 -----------------
 arch/arm/mach-tegra/fuse.h                         |   79 ------
 arch/arm/mach-tegra/hotplug.c                      |    2 +-
 arch/arm/mach-tegra/platsmp.c                      |    2 +-
 arch/arm/mach-tegra/pm.c                           |    2 +-
 arch/arm/mach-tegra/pmc.c                          |    2 +-
 arch/arm/mach-tegra/powergate.c                    |    2 +-
 arch/arm/mach-tegra/reset-handler.S                |    2 +-
 arch/arm/mach-tegra/reset.c                        |    2 +-
 arch/arm/mach-tegra/sleep-tegra30.S                |    2 +-
 arch/arm/mach-tegra/tegra.c                        |    2 +-
 arch/arm/mach-tegra/tegra114_speedo.c              |  104 -------
 arch/arm/mach-tegra/tegra20_speedo.c               |  109 --------
 arch/arm/mach-tegra/tegra2_emc.c                   |    2 +-
 arch/arm/mach-tegra/tegra30_speedo.c               |  292 -------------------
 drivers/misc/Makefile                              |    1 +
 drivers/misc/fuse/Makefile                         |    1 +
 drivers/misc/fuse/tegra/Makefile                   |    7 +
 drivers/misc/fuse/tegra/fuse-tegra.c               |  228 +++++++++++++++
 drivers/misc/fuse/tegra/fuse-tegra20.c             |  136 +++++++++
 drivers/misc/fuse/tegra/fuse-tegra30.c             |  178 ++++++++++++
 drivers/misc/fuse/tegra/fuse.h                     |   82 ++++++
 drivers/misc/fuse/tegra/tegra114_speedo.c          |  110 ++++++++
 drivers/misc/fuse/tegra/tegra124_speedo.c          |  164 +++++++++++
 drivers/misc/fuse/tegra/tegra20_speedo.c           |  110 ++++++++
 drivers/misc/fuse/tegra/tegra30_speedo.c           |  294 ++++++++++++++++++++
 include/linux/tegra-soc.h                          |   39 +++
 37 files changed, 1461 insertions(+), 872 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-driver-tegra-fuse
 create mode 100644 Documentation/devicetree/bindings/fuse/fuse-tegra.txt
 delete mode 100644 arch/arm/mach-tegra/fuse.c
 delete mode 100644 arch/arm/mach-tegra/fuse.h
 delete mode 100644 arch/arm/mach-tegra/tegra114_speedo.c
 delete mode 100644 arch/arm/mach-tegra/tegra20_speedo.c
 delete mode 100644 arch/arm/mach-tegra/tegra30_speedo.c
 create mode 100644 drivers/misc/fuse/Makefile
 create mode 100644 drivers/misc/fuse/tegra/Makefile
 create mode 100644 drivers/misc/fuse/tegra/fuse-tegra.c
 create mode 100644 drivers/misc/fuse/tegra/fuse-tegra20.c
 create mode 100644 drivers/misc/fuse/tegra/fuse-tegra30.c
 create mode 100644 drivers/misc/fuse/tegra/fuse.h
 create mode 100644 drivers/misc/fuse/tegra/tegra114_speedo.c
 create mode 100644 drivers/misc/fuse/tegra/tegra124_speedo.c
 create mode 100644 drivers/misc/fuse/tegra/tegra20_speedo.c
 create mode 100644 drivers/misc/fuse/tegra/tegra30_speedo.c

-- 
1.7.7.rc0.72.g4b5ea.dirty

