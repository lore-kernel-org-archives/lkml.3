Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778AbaLHJrI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 04:47:08 -0500
Received: from lucky1.263xmail.com ([211.157.147.133]:53969 "EHLO
	lucky1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512AbaLHJrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 04:47:03 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 1
X-MAIL-DELIVERY: 0
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: lyz@rock-chips.com
X-FST-TO: heiko@sntech.de
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: lyz@rock-chips.com
X-UNIQUE-TAG: <d7d415357cfd12e151b10421a3c73c1d>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
From: Yunzhi Li <lyz@rock-chips.com>
To: heiko@sntech.de, dianders@chromium.org, romain.perier@gmail.com
Cc: olof@lixom.net, huangtao@rock-chips.com, zyw@rock-chips.com,
        cf@rock-chips.com, linux-rockchip@lists.infradead.org,
        Yunzhi Li <lyz@rock-chips.com>, devicetree@vger.kernel.org,
        Paul Zimmerman <paulz@synopsys.com>, linux-usb@vger.kernel.org,
        Kumar Gala <galak@codeaurora.org>, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH v3 0/5] 
Date: Mon,  8 Dec 2014 17:46:23 +0800
Message-Id: <1418031988-2700-1-git-send-email-lyz@rock-chips.com>
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

Changes in v3:
- Use BIT macro instead of bit shift ops.
- Rename the config entry to PHY_ROCKCHIP_USB.
- Fix coding style: both branches of the if() which only one
  branch of the conditional statement is a single statement should
  have braces.
- No need to test dwc2->phy for NULL before calling generic phy
  APIs.
- Add more context about the changes in the long description.

Yunzhi Li (5):
  phy: add a driver for the Rockchip SoC internal USB2.0 PHY
  Documentation: bindings: add doc for the Rockchip usb PHY
  usb: dwc2: add generic PHY framework support for dwc2 usb    
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
 drivers/usb/dwc2/platform.c                        |  36 ++++-
 8 files changed, 272 insertions(+), 23 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/phy/rockchip-usb-phy.txt
 create mode 100644 drivers/phy/phy-rockchip-usb.c

-- 
2.0.0


