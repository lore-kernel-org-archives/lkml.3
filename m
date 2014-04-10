Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030541AbaDJMZz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 08:25:55 -0400
Received: from top.free-electrons.com ([176.31.233.9]:38576 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030282AbaDJMZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 08:25:53 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Randy Dunlap <rdunlap@infradead.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        =?UTF-8?q?Emilio=20L=C3=B3pez?= <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>, Chen-Yu Tsai <wens@csie.org>,
        Hans de Goede <hdegoede@redhat.com>
Cc: Shuge <shuge@allwinnertech.com>, kevin@allwinnertech.com,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        dev@linux-sunxi.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH v2 0/5] ARM: sunxi: add multi pin controller support
Date: Thu, 10 Apr 2014 14:25:42 +0200
Message-Id: <1397132747-13917-1-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This series rework the sunxi pinctrl driver to support the PL and PM
pins available on the A31 SoC, which are controlled using the R_PIO
block.

This series add support for multi pin controller which was previously
impossible for several reasons:
1) the pinctrl instance was registering a static instance of the gpio
   chip, which means, in case you were probing 2 devices, the gpio chip
   was added twice to the gpiochip list
2) the base pin of the gpio chip was always set to 0, and thus the 2
   gpiochip pin numbers were overlapping

I still haven't reworked the interrupt part (to handle the "per bank
interrupt" instead of the "one interrupt for the whole gpio" chip
approach), but this will be part of another series.

Best Regards,

Boris

Changes since v1:
 - rework the pinctrl driver to support multiple pin controller instances
 - removed reset and clock gate patches from the series
 - removed A31 DT modifications from the series (we need to get the PRCM
 reset and clk drivers before being able to declare the r_pio node, and
 we're still discussing how this should be implemented)

Boris BREZILLON (5):
  pinctrl: sunxi: add PL and PM pin definitions
  pinctrl: sunxi: support multiple pin controller
  pinctrl: sunxi: define A31 R_PIO pin functions
  pinctrl: sunxi: add reset control support
  ARM: sunxi: update the default ARCH_NR_GPIO for sunxi arch

 .../bindings/pinctrl/allwinner,sunxi-pinctrl.txt   |  1 +
 arch/arm/Kconfig                                   |  2 +-
 drivers/pinctrl/pinctrl-sunxi-pins.h               | 74 ++++++++++++++++++++++
 drivers/pinctrl/pinctrl-sunxi.c                    | 40 +++++++-----
 drivers/pinctrl/pinctrl-sunxi.h                    | 69 ++++++++++++++++++++
 5 files changed, 169 insertions(+), 17 deletions(-)

-- 
1.8.3.2

