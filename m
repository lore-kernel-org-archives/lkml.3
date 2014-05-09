Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755981AbaEILMB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 07:12:01 -0400
Received: from top.free-electrons.com ([176.31.233.9]:44741 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753784AbaEILL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 07:11:58 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: =?UTF-8?q?Emilio=20L=C3=B3pez?= <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: Chen-Yu Tsai <wens@csie.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Shuge <shuge@allwinnertech.com>, kevin@allwinnertech.com,
        Hans de Goede <hdegoede@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, dev@linux-sunxi.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH v3 0/7] mfd: add basic sun6i A31 PRCM support
Date: Fri,  9 May 2014 13:11:44 +0200
Message-Id: <1399633911-7094-1-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patch series adds support for some functions provided by the PRCM
(Power/Reset/Clock Management) unit:
- AR100, AHB0 and APB0 clocks
- APB0 reset controller

These functions are needed to get the P2WI driver working, but more
subdevices might be added later.

Best Regards,

Boris

Changes since v2:
- use devm_ioremap_resource instead of devm_request_and_ioremap
- remove unnecessary header inclusions
- remove info trace when the probe succeed
- rename apb0_timer01 clk into apb0_timer
Changes since v1:
- fix prcm and prcm-clks DT documentation
- remove unneeded iounmap and kfree calls from sunxi_reset_remove function
- rework the AR100 clk implementation

Boris BREZILLON (7):
  reset: sunxi: document sunxi's reset controllers bindings
  reset: sunxi: allow MFD subdevices probe
  mfd: add support for sun6i PRCM (Power/Reset/Clock Management) unit
  mfd: sun6i-prcm: document DT bindings
  clk: sunxi: add PRCM (Power/Reset/Clock Management) clks support
  clk: sunxi: document PRCM clock compatible strings
  ARM: sunxi: dt: add PRCM clk and reset controller subdevices

 Documentation/devicetree/bindings/clock/sunxi.txt  |   4 +
 .../devicetree/bindings/mfd/sun6i-prcm.txt         |  59 ++++
 .../bindings/reset/allwinner,sunxi-clock-reset.txt |  21 ++
 arch/arm/boot/dts/sun6i-a31.dtsi                   |  37 +++
 drivers/clk/sunxi/Makefile                         |   2 +
 drivers/clk/sunxi/clk-sun6i-prcm.c                 | 343 +++++++++++++++++++++
 drivers/mfd/Kconfig                                |   8 +
 drivers/mfd/Makefile                               |   1 +
 drivers/mfd/sun6i-prcm.c                           | 134 ++++++++
 drivers/reset/reset-sunxi.c                        |  21 +-
 10 files changed, 627 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/sun6i-prcm.txt
 create mode 100644 Documentation/devicetree/bindings/reset/allwinner,sunxi-clock-reset.txt
 create mode 100644 drivers/clk/sunxi/clk-sun6i-prcm.c
 create mode 100644 drivers/mfd/sun6i-prcm.c

-- 
1.8.3.2

