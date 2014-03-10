Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057AbaCJOpR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 10:45:17 -0400
Received: from top.free-electrons.com ([176.31.233.9]:49591 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754032AbaCJOpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 10:45:14 -0400
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
Subject: [PATCH v4 0/7] Add support for the Allwinner A31 DMA Controller
Date: Mon, 10 Mar 2014 15:41:45 +0100
Message-Id: <1394462512-11620-1-git-send-email-maxime.ripard@free-electrons.com>
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

Changes from v3:
  - A few other comments made by Andy Shevchenko were fixed:
    + Used references in %pa* printk formats
    + Used is_slave_direction in prep_slave_sg to make sure we were
      actually called for something, and to avoid making assumptions
      that we were actually called with the expected directions
    + A few others minor fixes: s/pr_err/dev_err/, etc.

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
 drivers/dma/sun6i-dma.c                            | 986 +++++++++++++++++++++
 14 files changed, 1407 insertions(+), 193 deletions(-)
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

