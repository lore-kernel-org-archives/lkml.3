Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755126Ab3AKHqu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 02:46:50 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:15106 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754431Ab3AKHqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 02:46:47 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Thu, 10 Jan 2013 23:45:54 -0800
From: Prashant Gaikwad <pgaikwad@nvidia.com>
To: <swarren@wwwdotorg.org>, <mturquette@linaro.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Prashant Gaikwad <pgaikwad@nvidia.com>
Subject: [PATCH v4 0/9] Migrate Tegra to common clock framework
Date: Fri, 11 Jan 2013 13:16:18 +0530
Message-ID: <1357890387-23245-1-git-send-email-pgaikwad@nvidia.com>
X-Mailer: git-send-email 1.7.4.1
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset does following:
1. Decompose single tegra clock structure into multiple clocks.
2. Try to use standard clock types supported by common clock framework.
3. Use dynamic initialization.
4. Move all clock code to drivers/clk/tegra from mach-tegra.
5. Add device tree support for Tegra20 and Tegra30 clocks.
6. Remove all legacy clock code from mach-tegra.

Tested on Tegra30 (Cardhu) and Tegra20 (Ventana).

This patch series is rebased on Tegra's for-3.9/soc and for-3.9/cleanup branch.

Changes from V3:
Fixed issued reported by Stephen Warren.

Changes from v2:
Removed APB MISC node.
Fixed some issues reported by Joseph Lo.
Added function to read chip id revision register.

Changes from v1:
Rebased on linux-next for 20121224.

Prashant Gaikwad (8):
  ARM: tegra: Add function to read chipid
  clk: tegra: Add tegra specific clocks
  arm: tegra: Move tegra_cpu_car.h to linux/clk/tegra.h
  ARM: Tegra: Define Tegra30 CAR binding
  clk: tegra: add clock support for tegra20
  clk: tegra: add clock support for tegra30
  arm: tegra: Migrate to new clock code
  arm: tegra: Remove legacy clock code

Stephen Warren (1):
  ARM: tegra: Define Tegra20 CAR binding

 .../bindings/clock/nvidia,tegra20-car.txt          |  205 ++
 .../bindings/clock/nvidia,tegra30-car.txt          |  262 ++
 arch/arm/boot/dts/tegra20.dtsi                     |    6 +
 arch/arm/boot/dts/tegra30.dtsi                     |    6 +
 arch/arm/mach-tegra/Makefile                       |    5 -
 arch/arm/mach-tegra/board-dt-tegra20.c             |   30 -
 arch/arm/mach-tegra/board-dt-tegra30.c             |   31 -
 arch/arm/mach-tegra/clock.c                        |  166 --
 arch/arm/mach-tegra/clock.h                        |  153 --
 arch/arm/mach-tegra/common.c                       |   44 +-
 arch/arm/mach-tegra/cpu-tegra.c                    |    2 +-
 arch/arm/mach-tegra/cpuidle-tegra30.c              |    2 +-
 arch/arm/mach-tegra/fuse.c                         |    8 +-
 arch/arm/mach-tegra/hotplug.c                      |    2 +-
 arch/arm/mach-tegra/include/mach/clk.h             |   44 -
 arch/arm/mach-tegra/pcie.c                         |    2 +-
 arch/arm/mach-tegra/platsmp.c                      |    2 +-
 arch/arm/mach-tegra/pm.c                           |    2 +-
 arch/arm/mach-tegra/powergate.c                    |    2 +-
 arch/arm/mach-tegra/tegra20_clocks.c               | 1623 -------------
 arch/arm/mach-tegra/tegra20_clocks.h               |   42 -
 arch/arm/mach-tegra/tegra20_clocks_data.c          | 1143 ---------
 arch/arm/mach-tegra/tegra30_clocks.c               | 2506 --------------------
 arch/arm/mach-tegra/tegra30_clocks.h               |   54 -
 arch/arm/mach-tegra/tegra30_clocks_data.c          | 1425 -----------
 drivers/clk/Makefile                               |    1 +
 drivers/clk/tegra/Makefile                         |   11 +
 drivers/clk/tegra/clk-audio-sync.c                 |   89 +
 drivers/clk/tegra/clk-divider.c                    |  188 ++
 drivers/clk/tegra/clk-periph-gate.c                |  182 ++
 drivers/clk/tegra/clk-periph.c                     |  228 ++
 drivers/clk/tegra/clk-pll-out.c                    |  124 +
 drivers/clk/tegra/clk-pll.c                        |  676 ++++++
 drivers/clk/tegra/clk-super.c                      |  154 ++
 drivers/clk/tegra/clk-tegra20.c                    | 1255 ++++++++++
 drivers/clk/tegra/clk-tegra30.c                    | 2041 ++++++++++++++++
 drivers/clk/tegra/clk.c                            |   85 +
 drivers/clk/tegra/clk.h                            |  488 ++++
 drivers/dma/tegra20-apb-dma.c                      |    2 +-
 drivers/gpu/drm/tegra/dc.c                         |    3 +-
 drivers/gpu/drm/tegra/drm.c                        |    1 -
 drivers/gpu/drm/tegra/hdmi.c                       |    3 +-
 drivers/i2c/busses/i2c-tegra.c                     |    3 +-
 drivers/input/keyboard/tegra-kbc.c                 |    2 +-
 drivers/spi/spi-tegra20-sflash.c                   |    2 +-
 drivers/spi/spi-tegra20-slink.c                    |    2 +-
 drivers/staging/nvec/nvec.c                        |    3 +-
 .../tegra_cpu_car.h => include/linux/clk/tegra.h   |   13 +-
 include/linux/tegra-soc.h                          |   22 +
 sound/soc/tegra/tegra30_ahub.c                     |    2 +-
 50 files changed, 6056 insertions(+), 7291 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/clock/nvidia,tegra20-car.txt
 create mode 100644 Documentation/devicetree/bindings/clock/nvidia,tegra30-car.txt
 delete mode 100644 arch/arm/mach-tegra/clock.c
 delete mode 100644 arch/arm/mach-tegra/clock.h
 delete mode 100644 arch/arm/mach-tegra/include/mach/clk.h
 delete mode 100644 arch/arm/mach-tegra/tegra20_clocks.c
 delete mode 100644 arch/arm/mach-tegra/tegra20_clocks.h
 delete mode 100644 arch/arm/mach-tegra/tegra20_clocks_data.c
 delete mode 100644 arch/arm/mach-tegra/tegra30_clocks.c
 delete mode 100644 arch/arm/mach-tegra/tegra30_clocks.h
 delete mode 100644 arch/arm/mach-tegra/tegra30_clocks_data.c
 create mode 100644 drivers/clk/tegra/Makefile
 create mode 100644 drivers/clk/tegra/clk-audio-sync.c
 create mode 100644 drivers/clk/tegra/clk-divider.c
 create mode 100644 drivers/clk/tegra/clk-periph-gate.c
 create mode 100644 drivers/clk/tegra/clk-periph.c
 create mode 100644 drivers/clk/tegra/clk-pll-out.c
 create mode 100644 drivers/clk/tegra/clk-pll.c
 create mode 100644 drivers/clk/tegra/clk-super.c
 create mode 100644 drivers/clk/tegra/clk-tegra20.c
 create mode 100644 drivers/clk/tegra/clk-tegra30.c
 create mode 100644 drivers/clk/tegra/clk.c
 create mode 100644 drivers/clk/tegra/clk.h
 rename arch/arm/mach-tegra/tegra_cpu_car.h => include/linux/clk/tegra.h (91%)
 create mode 100644 include/linux/tegra-soc.h

-- 
1.7.4.1

