Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101AbaB1QlY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 11:41:24 -0500
Received: from top.free-electrons.com ([176.31.233.9]:53009 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752728AbaB1QkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 11:40:10 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Emilio Lopez <emilio@elopez.com.ar>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-sunxi@googlegroups.com, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        zhuzhenhua@allwinnertech.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH v2 0/5] Add support for the Allwinner A31 DMA Controller
Date: Fri, 28 Feb 2014 17:37:15 +0100
Message-Id: <1393605440-14643-1-git-send-email-maxime.ripard@free-electrons.com>
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

Changes from v1:
  - Removed the clk_put call in the clocks protecting patches
  - Minor fixes here and there as suggested by Andy Shevchenko: switch
    to dmam_pool_create, switch to dev_dbg instead of pr_debug, etc.

Maxime Ripard (5):
  clk: sun6i: Protect CPU clock
  clk: sun6i: Reparent AHB clock on PLL6
  clk: sun6i: Protect SDRAM gating bit
  DMA: sun6i: Add driver for the Allwinner A31 DMA controller
  ARM: sun6i: dt: Add A31 DMA controller to DTSI

 .../devicetree/bindings/dma/sun6i-dma.txt          |  45 +
 arch/arm/boot/dts/sun6i-a31.dtsi                   |  29 +
 drivers/clk/sunxi/clk-sunxi.c                      |  29 +-
 drivers/dma/Kconfig                                |   8 +
 drivers/dma/Makefile                               |   1 +
 drivers/dma/sun6i-dma.c                            | 959 +++++++++++++++++++++
 6 files changed, 1070 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/dma/sun6i-dma.txt
 create mode 100644 drivers/dma/sun6i-dma.c

-- 
1.9.0

