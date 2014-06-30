Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753694AbaF3Nas (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 09:30:48 -0400
Received: from top.free-electrons.com ([176.31.233.9]:54752 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751974AbaF3Nao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 09:30:44 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Dan Williams <dan.j.williams@intel.com>, Vinod Koul <vinod.koul@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-sunxi@googlegroups.com, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        zhuzhenhua@allwinnertech.com, Arnd Bergmann <arnd@arndb.de>,
        andriy.shevchenko@intel.com, dmaengine@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH v10 0/2] Add support for the Allwinner A31 DMA Controller
Date: Mon, 30 Jun 2014 15:20:52 +0200
Message-Id: <1404134454-25513-1-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.0.0
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

Changes from v9:
  - Rebased on top of 3.16-rc1
  - Fixed the whitespace error in the documentation

Changes from v8:
  - Drop the select on DMA_OF
  - Depend on COMPILE_TEST to get more build tests coverage

Changes from v7:
  - select DMA_OF, since we're only relying on DT
  - Properly kill the tasklet as suggested in
    https://lwn.net/Articles/588457/
  - Split up the dt bindings documentation into a separate patch

Changes from v6:
  - Dropped the merged patches and the clock patches that are pretty
    orthogonal to this driver

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


Maxime Ripard (2):
  Documentation: dt: Add Allwinner A31 DMA controller bindings
  dmaengine: sun6i: Add driver for the Allwinner A31 DMA controller

 .../devicetree/bindings/dma/sun6i-dma.txt          |   45 +
 drivers/dma/Kconfig                                |    8 +
 drivers/dma/Makefile                               |    1 +
 drivers/dma/sun6i-dma.c                            | 1058 ++++++++++++++++++++
 4 files changed, 1112 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/dma/sun6i-dma.txt
 create mode 100644 drivers/dma/sun6i-dma.c

-- 
2.0.0

