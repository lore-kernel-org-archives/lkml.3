Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161047AbaDQIud (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 04:50:33 -0400
Received: from top.free-electrons.com ([176.31.233.9]:54455 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755472AbaDQIuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 04:50:19 -0400
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
        Arnd Bergmann <arnd@arndb.de>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH v6 0/8] Add support for the Allwinner A31 DMA Controller
Date: Thu, 17 Apr 2014 10:46:11 +0200
Message-Id: <1397724379-15398-1-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patchset adds support for the DMA controller found in the
Allwinner A31 and A23 SoCs.

This has been tested using the newly introduced SPI driver on an A31
EVK. Support for DMA-driven SPI transfers will be the subject of
another patch serie.

Since this serie has been sent for the first time about 2 monthes ago,
and I never got any comments from the DMA maintainer, yet gathering
some Acked-by, I expect this to be merged quite quickly.

Thanks,
Maxime

Changes from v5:
  - Rebased on top of 3.15-rc1

Changes from v4:
  - Removed the packed attribute on the LLI
  - Switched to using a NULL device pointer in clk_get on PLL6 and
    AHB1 mux to make explicit that we are getting global clocks
  - Switched from spin_lock_irqsave to spin_lock in the interrupt
    handler
  - Various nitpicks from Andy Shevchenko:
    + Switched to using %p printk formats for pointers
    + Inverted some tests to lose a level of indentation
    + Dropped ifdef DEBUG protecting calls to dev_dbg

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

Maxime Ripard (8):
  clk: sunxi: Remove calls to clk_put
  ARM: sunxi: Split out the various machines into separate files
  ARM: sunxi: Move the clock protection to machine hooks
  ARM: sun6i: Protect CPU clock
  ARM: sun6i: Protect SDRAM gating bit
  ARM: sun6i: Sort the NMI node by physical address
  DMA: sun6i: Add driver for the Allwinner A31 DMA controller
  ARM: sun6i: dt: Add A31 DMA controller to DTSI

 .../devicetree/bindings/dma/sun6i-dma.txt          |  45 +
 arch/arm/boot/dts/sun6i-a31.dtsi                   |  41 +-
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
 drivers/dma/sun6i-dma.c                            | 987 +++++++++++++++++++++
 14 files changed, 1414 insertions(+), 199 deletions(-)
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
1.9.1

