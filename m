Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178AbaKRMWj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 07:22:39 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:36037 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627AbaKRMWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 07:22:36 -0500
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: linux-tegra@vger.kernel.org
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        mikko.perttunen@kapsi.fi, acourbot@nvidia.com,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>, devicetree@vger.kernel.org,
        Joerg Roedel <jroedel@suse.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Mikko Perttunen <mperttunen@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <treding@nvidia.com>
Subject: [PATCH v5 00/14] Tegra124 EMC (external memory controller) support
Date: Tue, 18 Nov 2014 13:13:02 +0100
Message-Id: <1416312860-4446-1-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

in this v5 you can find these changes:

* Update EMC data to V5.0.17 version of the DVFS tables

* Add struct tegra_emc as a parameter in the EMC API, removing the need for a
global pointer.

* Also add a reference to the EMC driver to the CAR node, for the EMC clock to
use when calling the EMC API.

There's an outstanding issue with frequencies lower than 102MHz, as the MC IP
complains of EMEM arbitration errors when at those frequencies. Any suggestions
welcome.

It depends on Thierry's MC patches at [0] and a branch can be found at [1]. So
far it has been tested only on a Jetson TK1.

Patch 1: Removes the old EMC clock, that was unused and not functional

Patch 2: Documents bindings for the new long-ram-code property

Patch 3: Adds API for reading the ram code

Patches 4 to 7: Document OF additions

Patch 8: Adds EMC node to Tegra124 DT

Patch 9: Adds timings for Jetson TK1 board

Patch 10: Adds functions to the MC driver so the EMC driver can stay within its
own registers

Patch 11: Adds the actual EMC driver, making use of the new MC API

Patch 12: Adds EMC clock driver, making use of API provided by the EMC driver

Patch 13: Adds debugfs entry for getting and setting the EMC rate

Patch 14: On Tegra124, have the EMC clock be the parent of the MC clock

Regards,

Tomeu

[0] https://github.com/thierryreding/linux/commits/staging/iommu
[1] http://cgit.collabora.com/git/user/tomeu/linux.git/log/?h=emc-v5

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

Tomeu Vizoso (5):
  of: Document long-ram-code property in nvidia,tegra20-apbmisc
  of: document new emc-timings subnode in nvidia,tegra124-car
  of: Document timings subnode of nvidia,tegra-mc
  of: document external-memory-controller property in tegra124-car
  clk: tegra: Set the EMC clock as the parent of the MC clock

 .../bindings/clock/nvidia,tegra124-car.txt         |   44 +-
 .../memory-controllers/nvidia,tegra-mc.txt         |   84 +-
 .../bindings/memory-controllers/tegra-emc.txt      |  379 +++
 .../bindings/misc/nvidia,tegra20-apbmisc.txt       |    2 +
 arch/arm/boot/dts/tegra124-jetson-tk1-emc.dtsi     | 2469 ++++++++++++++++++++
 arch/arm/boot/dts/tegra124-jetson-tk1.dts          |    2 +
 arch/arm/boot/dts/tegra124.dtsi                    |    8 +
 drivers/clk/tegra/Makefile                         |    2 +-
 drivers/clk/tegra/clk-emc.c                        |  532 +++++
 drivers/clk/tegra/clk-tegra124.c                   |   18 +-
 drivers/clk/tegra/clk.h                            |    3 +
 drivers/memory/tegra/Kconfig                       |   11 +
 drivers/memory/tegra/Makefile                      |    2 +
 drivers/memory/tegra/mc.c                          |  136 ++
 drivers/memory/tegra/tegra124-emc.c                | 1164 +++++++++
 drivers/memory/tegra/tegra124.c                    |   44 +
 drivers/soc/tegra/fuse/tegra-apbmisc.c             |   19 +
 include/soc/tegra/emc.h                            |   19 +
 include/soc/tegra/fuse.h                           |    1 +
 include/soc/tegra/mc.h                             |   14 +-
 20 files changed, 4934 insertions(+), 19 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/memory-controllers/tegra-emc.txt
 create mode 100644 arch/arm/boot/dts/tegra124-jetson-tk1-emc.dtsi
 create mode 100644 drivers/clk/tegra/clk-emc.c
 create mode 100644 drivers/memory/tegra/tegra124-emc.c
 create mode 100644 include/soc/tegra/emc.h

-- 
1.9.3

