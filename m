Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751296AbaLEMxK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 07:53:10 -0500
Received: from lucky1.263xmail.com ([211.157.147.133]:46030 "EHLO
	lucky1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbaLEMxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 07:53:03 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 1
X-MAIL-DELIVERY: 0
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: lyz@rock-chips.com
X-FST-TO: heiko@sntech.de
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: lyz@rock-chips.com
X-UNIQUE-TAG: <e06193797c2543aa8cb4af1f91814d96>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From: Yunzhi Li <lyz@rock-chips.com>
To: heiko@sntech.de, dianders@chromium.org
Cc: olof@lixom.net, huangtao@rock-chips.com, ulrich.prinz@googlemail.com,
        zyw@rock-chips.com, cf@rock-chips.com,
        linux-rockchip@lists.infradead.org, Yunzhi Li <lyz@rock-chips.com>,
        devicetree@vger.kernel.org, Paul Zimmerman <paulz@synopsys.com>,
        linux-usb@vger.kernel.org, Kumar Gala <galak@codeaurora.org>,
        linux-kernel@vger.kernel.org, Grant Likely <grant.likely@linaro.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH v2 0/5] 
Date: Fri,  5 Dec 2014 20:52:16 +0800
Message-Id: <1417783941-2418-1-git-send-email-lyz@rock-chips.com>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patches to add support for Rockchip usb phys.Add a new Rockchip
usb phy driver and modify dwc2 controller driver to make dwc2
platform devices support a generic PHY framework driver. This
patch set has been tested on my rk3288-evb and power off the usb
phys would reduce about 60mW power budget in total during sustem
suspend.


Yunzhi Li (5):
  phy: add a driver for the Rockchip SoC internal USB2.0 PHY.
  Documentation: bindings: add doc for the Rockchip usb PHY
  usb: dwc2: Add generic PHY framework support for dwc2 usb    
    controler platform driver.
  ARM: dts: add rk3288 usb PHY
  ARM: dts: Enable usb PHY on rk3288-evb board

 .../devicetree/bindings/phy/rockchip-usb-phy.txt   |  22 +++
 arch/arm/boot/dts/rk3288-evb.dtsi                  |   4 +
 arch/arm/boot/dts/rk3288.dtsi                      |  13 ++
 drivers/phy/Kconfig                                |   7 +
 drivers/phy/Makefile                               |   1 +
 drivers/phy/phy-rockchip-usb.c                     | 179 +++++++++++++++++++++
 drivers/usb/dwc2/gadget.c                          |  33 ++--
 drivers/usb/dwc2/platform.c                        |  34 ++++
 8 files changed, 272 insertions(+), 21 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/phy/rockchip-usb-phy.txt
 create mode 100644 drivers/phy/phy-rockchip-usb.c

-- 
2.0.0


