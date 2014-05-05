Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565AbaEEF1f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 01:27:35 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35582 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754354AbaEEF1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 01:27:34 -0400
From: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com, linus.walleij@linaro.org
Cc: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/7] ARM: berlin: add pinctrl support
Date: Mon,  5 May 2014 07:27:22 +0200
Message-Id: <1399267649-20218-1-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds support for the Marvell Berlin pin-controller, allowing
to configure the pin muxing from the device tree.

The Berlin pin-controller support is divided into 3 drivers, each
driving one Berlin SoC. These drivers use a Berlin common part.

This series applies on top of patches introducing the Marvell Berlin
BG2Q you can find on Sebastian's berlin/for-next branch[1] and the patch
allowing not to define the get_group_pins() function[2].

Tested on the Berlin BG2Q.

[1] https://github.com/shesselba/linux-berlin/commits/berlin/for-next
[2] https://patchwork.kernel.org/patch/3964491/

Changes since v2:
	- added the uart2 pin muxing node for BG2
	- cosmetic fixes

Changes since v1:
        - moved the driver to a specific berlin/ directory
        - divided the pin-controller driver into three (one per SoC) and
          reworked the driver dependencies accordingly
        - reworked the device tree bindings
        - removed the reg-names and reworked the driver to allow
          splitting the two pin-controllers into two separate nodes in
          the device tree
        - updated the documentation
        - removed unnecessary checks
        - added support to mux multiple groups with the same function
        - added BG2, BG2 and BG2CD function definitions

Antoine Ténart (7):
  pinctrl: berlin: add the core pinctrl driver for Marvell Berlin SoCs
  pinctrl: berlin: add the BG2Q pinctrl driver
  pinctrl: berlin: add the BG2 pinctrl driver
  pinctrl: berlin: add the BG2CD pinctrl driver
  ARM: berlin: add the pinctrl dependency for the Marvell Berlin SoCs
  Documentation: add the Marvell Berlin pinctrl documentation
  ARM: dts: berlin: add the pinctrl node and muxing setup for uarts

 .../bindings/pinctrl/marvell,berlin-pinctrl.txt    |  45 +++
 arch/arm/boot/dts/berlin2.dtsi                     |  31 ++
 arch/arm/boot/dts/berlin2cd.dtsi                   |  17 +
 arch/arm/boot/dts/berlin2q.dtsi                    |  24 ++
 arch/arm/mach-berlin/Kconfig                       |   4 +
 drivers/pinctrl/Kconfig                            |   1 +
 drivers/pinctrl/Makefile                           |   1 +
 drivers/pinctrl/berlin/Kconfig                     |  19 +
 drivers/pinctrl/berlin/Makefile                    |   4 +
 drivers/pinctrl/berlin/berlin-bg2.c                | 251 +++++++++++++
 drivers/pinctrl/berlin/berlin-bg2cd.c              | 194 ++++++++++
 drivers/pinctrl/berlin/berlin-bg2q.c               | 413 +++++++++++++++++++++
 drivers/pinctrl/berlin/berlin.c                    | 346 +++++++++++++++++
 drivers/pinctrl/berlin/berlin.h                    |  71 ++++
 14 files changed, 1421 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/pinctrl/marvell,berlin-pinctrl.txt
 create mode 100644 drivers/pinctrl/berlin/Kconfig
 create mode 100644 drivers/pinctrl/berlin/Makefile
 create mode 100644 drivers/pinctrl/berlin/berlin-bg2.c
 create mode 100644 drivers/pinctrl/berlin/berlin-bg2cd.c
 create mode 100644 drivers/pinctrl/berlin/berlin-bg2q.c
 create mode 100644 drivers/pinctrl/berlin/berlin.c
 create mode 100644 drivers/pinctrl/berlin/berlin.h

-- 
1.8.3.2

