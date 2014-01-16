Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142AbaAPRPZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 12:15:25 -0500
Received: from top.free-electrons.com ([176.31.233.9]:51917 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753094AbaAPRPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 12:15:05 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Mark Brown <broonie@kernel.org>, Mike Turquette <mturquette@linaro.org>,
        Emilio Lopez <emilio@elopez.com.ar>
Cc: linux-sunxi@googlegroups.com, linux-spi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        zhuzhenhua@allwinnertech.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 0/4] Add Allwinner A31 SPI controller support
Date: Thu, 16 Jan 2014 18:11:21 +0100
Message-Id: <1389892285-11745-1-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

This patchset brings support for the SPI controller found in the
Allwinner A31 SoC.

Even though the controller supports DMA, the driver only supports PIO
mode for now. This driver will be used to bring up and test DMA on the
SoC, so support for the DMA will come eventually.

It doesn't support transfer larger than the FIFO size (128 bytes) for
now, so this is kind of a blocker against inclusion, but I expect it
to be fixed by v2.

Thanks!
Maxime

Maxime Ripard (4):
  clk: sunxi: Add support for PLL6 on the A31
  ARM: sun6i: dt: Add PLL6 and SPI module clocks
  spi: sunxi: Add Allwinner A31 SPI controller driver
  ARM: sun6i: dt: Add SPI controllers to the A31 DTSI

 Documentation/devicetree/bindings/clock/sunxi.txt  |   1 +
 .../devicetree/bindings/spi/spi-sun6i.txt          |  23 +
 arch/arm/boot/dts/sun6i-a31.dtsi                   |  88 +++-
 drivers/clk/sunxi/clk-sunxi.c                      |  45 ++
 drivers/spi/Makefile                               |   1 +
 drivers/spi/spi-sun6i.c                            | 463 +++++++++++++++++++++
 6 files changed, 611 insertions(+), 10 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/spi/spi-sun6i.txt
 create mode 100644 drivers/spi/spi-sun6i.c

-- 
1.8.4.2

