Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752323Ab3FJTji (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 15:39:38 -0400
Received: from gloria.sntech.de ([95.129.55.99]:58144 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751462Ab3FJTjg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 15:39:36 -0400
To: Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH v2 0/2] pinctrl: common handling of generic pinconfig props in dt
Cc: Patrice Chotard <patrice.chotard.st@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
From: Heiko =?utf-8?q?St=C3=BCbner?= <heiko@sntech.de>
Date: Mon, 10 Jun 2013 21:39:32 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201306102139.32444.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

here is my second try ... after our talk today, hopefully more future proof
(and acceptable).

I hadn't found a way to have the phandle as a simple argument in the pins
property, so the example Rockchip driver now uses a second property
rockchip,config = <&phandle>; to hold the link to the config node.

Surprisingly everything still works ;-) .


Heiko Stuebner (2):
  pinctrl: add function to parse generic pinconfig properties from a dt node
  pinctrl: add pinctrl driver for Rockchip SoCs

 .../bindings/pinctrl/pinctrl-bindings.txt          |   38 +
 .../bindings/pinctrl/rockchip,pinctrl.txt          |   98 ++
 drivers/pinctrl/Kconfig                            |    6 +
 drivers/pinctrl/Makefile                           |    1 +
 drivers/pinctrl/pinconf-generic.c                  |   81 ++
 drivers/pinctrl/pinconf.h                          |    6 +
 drivers/pinctrl/pinctrl-rockchip.c                 | 1346 ++++++++++++++++++++
 include/dt-bindings/pinctrl/rockchip.h             |   32 +
 8 files changed, 1608 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/pinctrl/rockchip,pinctrl.txt
 create mode 100644 drivers/pinctrl/pinctrl-rockchip.c
 create mode 100644 include/dt-bindings/pinctrl/rockchip.h

-- 
1.7.2.3

