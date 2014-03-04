Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755074AbaCDQVq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 11:21:46 -0500
Received: from top.free-electrons.com ([176.31.233.9]:41985 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754847AbaCDQUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 11:20:51 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Emilio Lopez <emilio@elopez.com.ar>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-sunxi@googlegroups.com, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        zhuzhenhua@allwinnertech.com, andriy.shevchenko@intel.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH v3 0/7] Add support for the Allwinner A31 DMA Controller
Date: Tue,  4 Mar 2014 17:17:57 +0100
Message-Id: <1393949884-892-1-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patchset adds support for the DMA controller found in the
Allwinner A31 and A23 SoCs.

This has been tested using the newly introduced SPI driver on an A31
EVK. Support for DMA-driven SPI transfers will be the subject of
another patch serie.

Thanks,
Maxime

Changes from v2:
  - Removed the clk_put calls in the clock protection functions
  - Splitted out the sunxi machines into several files
  - Moved the clock protection code into these new machine files
  - Moved the PLL6 reparenting to the DMA driver
  - Addressed various comments from Andy Shevchenko: switched to using
    devm_kcalloc, used correct printk formats for physical and DMA
    addresses, etc.

Changes from v1:
  - Removed the clk_put call in the clocks protecting patches
  - Minor fixes here and there as suggested by Andy Shevchenko: switch
    to dmam_pool_create, switch to dev_dbg instead of pr_debug, etc.

Maxime Ripard (7):
  clk: sunxi: Remove calls to clk_put
  ARM: sunxi: Split out the various machines into separate files
  ARM: sunxi: Move the clock protection to machine hooks
  ARM: sun6i: Protect CPU clock
  ARM: sun6i: Protect SDRAM gating bit
  DMA: sun6i: Add driver for the Allwinner A31 DMA controller
  ARM: sun6i: dt: Add A31 DMA controller to DTSI

 .../devicetree/bindings/dma/sun6i-dma.txt          |  45 +
 arch/arm/boot/dts/sun6i-a31.dtsi                   |  29 +
 arch/arm/mach-sunxi/Makefile                       |   6 +-
 arch/arm/mach-sunxi/restart.c                      | 104 +++
 arch/arm/mach-sunxi/restart.h                      |  20 +
 arch/arm/mach-sunxi/sun4i.c                        |  45 +
 arch/arm/mach-sunxi/sun5i.c                        |  51 ++
 arch/arm/mach-sunxi/sun6i.c                        |  63 ++
 arch/arm/mach-sunxi/sun7i.c                        |  50 ++
 arch/arm/mach-sunxi/sunxi.c                        | 164 ----
 drivers/clk/sunxi/clk-sunxi.c                      |  28 -
 drivers/dma/Kconfig                                |   8 +
 drivers/dma/Makefile                               |   1 +
 drivers/dma/sun6i-dma.c                            | 979 +++++++++++++++++++++
 14 files changed, 1400 insertions(+), 193 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/dma/sun6i-dma.txt
 create mode 100644 arch/arm/mach-sunxi/restart.c
 create mode 100644 arch/arm/mach-sunxi/restart.h
 create mode 100644 arch/arm/mach-sunxi/sun4i.c
 create mode 100644 arch/arm/mach-sunxi/sun5i.c
 create mode 100644 arch/arm/mach-sunxi/sun6i.c
 create mode 100644 arch/arm/mach-sunxi/sun7i.c
 delete mode 100644 arch/arm/mach-sunxi/sunxi.c
 create mode 100644 drivers/dma/sun6i-dma.c

-- 
1.9.0

