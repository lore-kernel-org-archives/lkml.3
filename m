Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035AbaKLH6S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 02:58:18 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:44883 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbaKLH6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 02:58:16 -0500
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: linux-tegra@vger.kernel.org
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        mikko.perttunen@kapsi.fi, acourbot@nvidia.com,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Mikko Perttunen <mperttunen@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <treding@nvidia.com>
Subject: [PATCH v4 00/13] Tegra124 EMC (external memory controller) support
Date: Wed, 12 Nov 2014 08:56:23 +0100
Message-Id: <1415779051-26410-1-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

in this v4 you can find these changes:

* Adapt to changes in the latest version of Thierry's IOMMU series

* OF bindings don't specify any unit-address or naming for the timings and timing subnodes. This is
in line with how the display timings are specified.

* Misc improvements on error handling and reporting

* Misc style fixes

* Adds a bit more information on the registers that need to be specified for each timing, and points
to the TRM for more details.

It depends on Thierry's MC patches at [0] and a branch can be found at [1]. So
far it has been tested only on a Jetson TK1.

Patch 1: Removes the old EMC clock, that was unused and not functional

Patch 2: Documents bindings for the new long-ram-code property

Patch 3: Adds API for reading the ram code

Patches 4 to 6: Document OF additions

Patch 7: Adds EMC node to Tegra124 DT

Patch 8: Adds timings for Jetson TK1 board

Patch 9: Adds functions to the MC driver so the EMC driver can stay within its
own registers

Patch 10: Adds the actual EMC driver, making use of the new MC API

Patch 11: Adds EMC clock driver, making use of API provided by the EMC driver

Patch 12: Adds debugfs entry for getting and setting the EMC rate

Patch 13: On Tegra124, have the EMC clock be the parent of the MC clock

Regards,

Tomeu

[0] https://github.com/thierryreding/linux/commits/staging/iommu
[1] http://cgit.collabora.com/git/user/tomeu/linux.git/log/?h=emc-v4

Mikko Perttunen (9):
  clk: tegra124: Remove old emc clock
  soc/tegra: Add ram code reader helper
  of: Add Tegra124 EMC bindings
  ARM: tegra: Add EMC to Tegra124 device tree
  ARM: tegra: Add EMC timings to Jetson TK1 device tree
  memory: tegra: Add API needed by the EMC driver
  memory: tegra: Add EMC (external memory controller) driver
  clk: tegra: Add EMC clock driver
  memory: tegra: Add debugfs entry for getting and setting the EMC rate

Tomeu Vizoso (4):
  of: Document long-ram-code property in nvidia,tegra20-apbmisc
  of: document new emc-timings subnode in nvidia,tegra124-car
  of: Document timings subnode of nvidia,tegra-mc
  clk: tegra: Set the EMC clock as the parent of the MC clock

 .../bindings/clock/nvidia,tegra124-car.txt         |   44 +-
 .../memory-controllers/nvidia,tegra-mc.txt         |   84 +-
 .../bindings/memory-controllers/tegra-emc.txt      |  376 +++
 .../bindings/misc/nvidia,tegra20-apbmisc.txt       |    2 +
 arch/arm/boot/dts/tegra124-jetson-tk1-emc.dtsi     | 2412 ++++++++++++++++++++
 arch/arm/boot/dts/tegra124-jetson-tk1.dts          |    2 +
 arch/arm/boot/dts/tegra124.dtsi                    |    7 +
 drivers/clk/tegra/Makefile                         |    2 +-
 drivers/clk/tegra/clk-emc.c                        |  468 ++++
 drivers/clk/tegra/clk-tegra124.c                   |   18 +-
 drivers/clk/tegra/clk.h                            |    2 +
 drivers/memory/tegra/Kconfig                       |   10 +
 drivers/memory/tegra/Makefile                      |    2 +
 drivers/memory/tegra/mc.c                          |  130 ++
 drivers/memory/tegra/mc.h                          |   12 +
 drivers/memory/tegra/tegra124-emc.c                | 1157 ++++++++++
 drivers/memory/tegra/tegra124.c                    |   44 +
 drivers/soc/tegra/fuse/tegra-apbmisc.c             |   19 +
 include/soc/tegra/fuse.h                           |    1 +
 include/soc/tegra/memory.h                         |   19 +
 20 files changed, 4793 insertions(+), 18 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/memory-controllers/tegra-emc.txt
 create mode 100644 arch/arm/boot/dts/tegra124-jetson-tk1-emc.dtsi
 create mode 100644 drivers/clk/tegra/clk-emc.c
 create mode 100644 drivers/memory/tegra/tegra124-emc.c
 create mode 100644 include/soc/tegra/memory.h

-- 
1.9.3

