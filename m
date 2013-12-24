Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255Ab3LXNcV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 08:32:21 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:3874 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677Ab3LXNcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 08:32:19 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 24 Dec 2013 05:33:58 -0800
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 0/6] efuse driver for Tegra
Date: Tue, 24 Dec 2013 15:32:05 +0200
Message-ID: <1387891931-9854-1-git-send-email-pdeschrijver@nvidia.com>
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

TODO:
* test on Tegra124 (venice2) 

Peter De Schrijver (6):
  ARM: tegra: export apb dma readl/writel
  misc: fuse: Add efuse driver for Tegra
  ARM: tegra: Add efuse bindings
  ARM: tegra: rework fuse.c
  ARM: Tegra: remove speedo files
  misc: enable fuse drivers

 Documentation/ABI/testing/sysfs-driver-tegra-fuse |    8 +
 arch/arm/boot/dts/tegra114.dtsi                   |    6 +
 arch/arm/boot/dts/tegra124.dtsi                   |    6 +
 arch/arm/boot/dts/tegra20.dtsi                    |    6 +
 arch/arm/boot/dts/tegra30.dtsi                    |    6 +
 arch/arm/mach-tegra/Makefile                      |    3 -
 arch/arm/mach-tegra/apbio.c                       |   51 +++--
 arch/arm/mach-tegra/fuse.c                        |  147 +----------
 arch/arm/mach-tegra/tegra114_speedo.c             |  104 --------
 arch/arm/mach-tegra/tegra20_speedo.c              |  109 --------
 arch/arm/mach-tegra/tegra30_speedo.c              |  292 --------------------
 drivers/misc/Kconfig                              |    1 +
 drivers/misc/Makefile                             |    1 +
 drivers/misc/fuse/Kconfig                         |   12 +
 drivers/misc/fuse/Makefile                        |    1 +
 drivers/misc/fuse/tegra/Makefile                  |    7 +
 drivers/misc/fuse/tegra/fuse-tegra.c              |   97 +++++++
 drivers/misc/fuse/tegra/fuse-tegra20.c            |  154 +++++++++++
 drivers/misc/fuse/tegra/fuse-tegra30.c            |  196 ++++++++++++++
 drivers/misc/fuse/tegra/fuse.h                    |   87 ++++++
 drivers/misc/fuse/tegra/tegra114_speedo.c         |  109 ++++++++
 drivers/misc/fuse/tegra/tegra124_speedo.c         |  164 ++++++++++++
 drivers/misc/fuse/tegra/tegra20_speedo.c          |  109 ++++++++
 drivers/misc/fuse/tegra/tegra30_speedo.c          |  293 +++++++++++++++++++++
 include/linux/tegra-soc.h                         |   17 ++
 25 files changed, 1317 insertions(+), 669 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-driver-tegra-fuse
 delete mode 100644 arch/arm/mach-tegra/tegra114_speedo.c
 delete mode 100644 arch/arm/mach-tegra/tegra20_speedo.c
 delete mode 100644 arch/arm/mach-tegra/tegra30_speedo.c
 create mode 100644 drivers/misc/fuse/Kconfig
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

