Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161028AbaDJNIL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 09:08:11 -0400
Received: from top.free-electrons.com ([176.31.233.9]:38933 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030696AbaDJNIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 09:08:07 -0400
From: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com, linus.walleij@linaro.org
Cc: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH RESEND 0/5] ARM: berlin: add pinctrl support
Date: Thu, 10 Apr 2014 15:07:49 +0200
Message-Id: <1397135274-10764-1-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I made a typo in the LAKML address, so resend it.

This series add support for the Marvell Berlin pinctrl, allowing to
configure the pinmuxing from the device tree.

This is a group based pinmux and only group informations are defined.
For this to work a modification in the pinctrl framework is needed so
that get_group_pin could not be defined. Please have a look on patches
1/5 and 2/5 commit logs.

This serie applies on top of patches introducing the Marvell Berlin
BG2Q you can find on Sebastian's for-next branch[1] and Alexandre's
BG2Q symbol introduction[2].

Tested on the Berlin BG2Q.

[1] https://github.com/shesselba/linux-berlin/commits/for-next
[2] https://patchwork.kernel.org/patch/3876141/

Antoine Ténart (5):
  pinctrl: allows not to define the get_group_pins operation
  pinctrl: berlin: add a pinctrl driver for Marvell Berlin SoCs
  ARM: berlin: add the pinctrl dependency for the Marvell Berlin SoCs
  Documentation: add the Marvell Berlin pinctrl documentation
  ARM: dts: berlin: add the pinctrl node and muxing setup for uarts

 .../bindings/pinctrl/marvell,berlin-pinctrl.txt    |  43 ++
 arch/arm/boot/dts/berlin2.dtsi                     |  20 +
 arch/arm/boot/dts/berlin2cd.dtsi                   |  13 +
 arch/arm/boot/dts/berlin2q.dtsi                    |  20 +
 arch/arm/mach-berlin/Kconfig                       |   2 +
 drivers/pinctrl/Kconfig                            |   4 +
 drivers/pinctrl/Makefile                           |   1 +
 drivers/pinctrl/core.c                             |  17 +-
 drivers/pinctrl/pinctrl-berlin.c                   | 498 +++++++++++++++++++++
 drivers/pinctrl/pinctrl-berlin.h                   |  72 +++
 drivers/pinctrl/pinmux.c                           |  23 +-
 11 files changed, 696 insertions(+), 17 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/pinctrl/marvell,berlin-pinctrl.txt
 create mode 100644 drivers/pinctrl/pinctrl-berlin.c
 create mode 100644 drivers/pinctrl/pinctrl-berlin.h

-- 
1.8.3.2

