Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761592Ab3LIVT3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 16:19:29 -0500
Received: from gloria.sntech.de ([95.129.55.99]:46849 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752409Ab3LIVTZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 16:19:25 -0500
To: Alessandro Zummo <a.zummo@towertech.it>
Subject: [PATCH v4 0/2] Add support for hym8563 rtcs
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        devicetree@vger.kernel.org, Grant Likely <grant.likely@linaro.org>,
        linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        Mike Turquette <mturquette@linaro.org>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        Mark Brown <broonie@kernel.org>
From: Heiko =?iso-8859-1?q?St=FCbner?= <heiko@sntech.de>
Date: Mon, 9 Dec 2013 22:19:10 +0100
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201312092219.11342.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds support for the Haoyu Microelectronics HYM8563 rtc. This
chip is often used in designs around the Cortex-A9 SoCs from Rockchip to
provide rtc functionality and the 32kHz suspend clock the SoC needs.

changes since v3:
- follow suggestion from Mark Brown to use the interrupt without the gpio
changes since v2:
- get size for devm_kzalloc from struct not from pointer
changes since v1:
- add haoyu prefix to vendor-prefixes.txt
- use gpio_to_irq to get the alarm interrupt instead of specifying it
  separately to the gpio itself

Heiko Stuebner (2):
  dt-bindings: add hym8563 binding
  rtc: add hym8563 rtc-driver

 .../devicetree/bindings/rtc/haoyu,hym8563.txt      |   27 +
 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 drivers/rtc/Kconfig                                |   11 +
 drivers/rtc/Makefile                               |    1 +
 drivers/rtc/rtc-hym8563.c                          |  601 ++++++++++++++++++++
 5 files changed, 641 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/rtc/haoyu,hym8563.txt
 create mode 100644 drivers/rtc/rtc-hym8563.c

-- 
1.7.10.4

