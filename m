Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756482AbaD1QRl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 12:17:41 -0400
Received: from top.free-electrons.com ([176.31.233.9]:50030 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751522AbaD1QRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 12:17:39 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Thierry Reding <thierry.reding@gmail.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: linux-pwm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCHv3 0/7] Add Allwinner SoCs PWM support
Date: Mon, 28 Apr 2014 18:17:07 +0200
Message-Id: <1398701834-3719-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch set adds support for the PWM controller found on the Allwinner SoCs.

The first patch adds the driver itself.
The second patch adds the DT binding documentation
The third patch adds the bindings to the sun7i-a20 DTS include.
And finally, the la patch adds support for the PWMs to the cubietruck which is
the board I used to test.

Changes in v3:
 - added COMPILE_TEST as a dependency
 - fixed indentation
 - modified the macros like suggested by Maxime

Changes in v2:
 - changed the compatible string
 - documented the clocks property
 - Added support in the A10 dtsi
 - split the patch adding pinctrl
 - a few cosmetic changes (removed empty lines, PWM_PRESCAL_MASK, ...)
 - fixed the period register calculation (the period is actually N + 1 cycles)
   so write prd - 1
 - properly locked accesses to PWM_CTRL_REG with a mutex

Alexandre Belloni (7):
  pwm: Add Allwinner SoC support
  pwm: sunxi: document OF bindings
  ARM: sun4i: dt: add pinmux configuration for the PWM
  ARM: sun4i: dt: add PWM support
  ARM: sun7i: dt: add pinmux configuration for the PWM
  ARM: sun7i: dt: add PWM support
  ARM: sunxi: dt: add PWM support for the cubietruck

 .../devicetree/bindings/pwm/pwm-sunxi.txt          |  20 ++
 arch/arm/boot/dts/sun4i-a10.dtsi                   |  22 ++
 arch/arm/boot/dts/sun7i-a20-cubietruck.dts         |   6 +
 arch/arm/boot/dts/sun7i-a20.dtsi                   |  22 ++
 drivers/pwm/Kconfig                                |   9 +
 drivers/pwm/Makefile                               |   1 +
 drivers/pwm/pwm-sunxi.c                            | 345 +++++++++++++++++++++
 7 files changed, 425 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/pwm/pwm-sunxi.txt
 create mode 100644 drivers/pwm/pwm-sunxi.c

-- 
1.9.1

