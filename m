Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969AbaCGKPq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 05:15:46 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:49529 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751055AbaCGKPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 05:15:41 -0500
From: Roger Quadros <rogerq@ti.com>
To: <balbi@ti.com>, <tony@atomide.com>
CC: <kishon@ti.com>, <george.cherian@ti.com>, <balajitk@ti.com>,
        <hdegoede@redhat.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <rogerq@ti.com>
Subject: [PATCH v3 0/8] ARM: OMAP: SATA support for OMAP5 & DRA7
Date: Fri, 7 Mar 2014 12:15:00 +0200
Message-ID: <1394187308-19622-1-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony & Felipe,

Kishon has pulled in the relevant PHY patches into his tree.
These are the remaining patches from the series.

Patches 1 to 3 need to go through Felipe's USB tree.
Patches 4 to 8 need to go through Tony's OMAP tree.

Thanks.

Patches are based on 3.14-rc4 with balbi/next, linux-phy/next and
omap-for-v3.15/dt merged on top.

To test SATA you will also need [1].

[1] - http://article.gmane.org/gmane.comp.hardware.netbook.arm.sunxi/7285

Changelog:
v3
- Removed PHY patches and rebased.

v2
- use 'depends on' instead of 'select' OCP2SCP bus driver.
- Changed DT bindings for dra7-usb2 and am437-usb2 phy.

cheers,
-roger

---
Balaji T K (2):
  ARM: dts: omap5: add sata node
  ARM: dts: dra7: add OCP2SCP3 and SATA nodes

Keshava Munegowda (1):
  ARM: OMAP5: hwmod: Add ocp2scp3 and sata hwmods

Nikhil Devshatwar (1):
  ARM: DRA7: hwmod: Add ocp2scp3 and sata hwmods

Roger Quadros (4):
  phy: omap-control: update dra7 and am437 usb2 Documentation bindings
  phy: ti-pipe3: Add clocks to PIPE3 PHY Documentation binding
  phy: ti-pipe3: Add SATA compatible to Documentation binding
  ARM: dts: omap5: Add clocks to USB3 PHY node

 Documentation/devicetree/bindings/phy/ti-phy.txt | 19 +++++-
 arch/arm/boot/dts/dra7.dtsi                      | 39 +++++++++++++
 arch/arm/boot/dts/omap5.dtsi                     | 46 +++++++++++++++
 arch/arm/mach-omap2/omap_hwmod_54xx_data.c       | 73 ++++++++++++++++++++++++
 arch/arm/mach-omap2/omap_hwmod_7xx_data.c        | 31 ++++++++--
 5 files changed, 200 insertions(+), 8 deletions(-)

-- 
1.8.3.2

