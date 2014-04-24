Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756969AbaDXOZK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 10:25:10 -0400
Received: from top.free-electrons.com ([176.31.233.9]:38715 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753757AbaDXOZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 10:25:07 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Dan Williams <dan.j.williams@intel.com>, Vinod Koul <vinod.koul@intel.com>
Cc: linux-arm-kernel@lists.infradead.org, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-sunxi@googlegroups.com, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        zhuzhenhua@allwinnertech.com, andriy.shevchenko@intel.com,
        Arnd Bergmann <arnd@arndb.de>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH v7] Add support for the Allwinner A31 DMA Controller
Date: Thu, 24 Apr 2014 16:22:43 +0200
Message-Id: <1398349364-10726-1-git-send-email-maxime.ripard@free-electrons.com>
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


Maxime Ripard (1):
  DMA: sun6i: Add driver for the Allwinner A31 DMA controller

 .../devicetree/bindings/dma/sun6i-dma.txt          |  45 +
 drivers/dma/Kconfig                                |   8 +
 drivers/dma/Makefile                               |   1 +
 drivers/dma/sun6i-dma.c                            | 987 +++++++++++++++++++++
 4 files changed, 1041 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/dma/sun6i-dma.txt
 create mode 100644 drivers/dma/sun6i-dma.c

-- 
1.9.1

