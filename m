Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061Ab3HAO7B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 10:59:01 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:44633 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755623Ab3HAO67 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 10:58:59 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>, <rnayak@ti.com>
CC: <benoit.cousson@linaro.org>, <balbi@ti.com>, <george.cherian@ti.com>,
        <kishon@ti.com>, <dmurphy@ti.com>, <t-kristo@ti.com>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH 0/4] ARM: DRA7-evm: USB host adaptation
Date: Thu, 1 Aug 2013 17:58:50 +0300
Message-ID: <1375369134-26398-1-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

These patches adds support for USB host on the DRA7-evm board.
The USB host port (USB2) is tested and works fine.

The USB OTG port (USB1) is still not functional in OTG mode as it is missing
ID pin routing and mailbox write. However, you can get just the host mode to
work by explicitely setting this port to "host" mode.

Patches are based on v3.11-rc3 dra7 baseport tree [1], with balbi/next
merged on top and the control-usb multiple instance support [2].

NOTE: It also needs a patch [3] which allows us to operate at lower then
Super Speed mode. This patch is still in transition.

Patches in this series can be obtained from branch
 usbhost-dra7-3.11-rc3
in git tree
 git://github.com/rogerq/linux.git

cheers,
-roger

[1] - dra7 base tree
	https://github.com/lokeshvutla/linux/tree/dra7-3.11-rc3-base
[2] - multiple control-usb instances
	https://github.com/rogerq/linux/tree/usb-control-module
[3] - usb: dwc3: core: make USB3 PHY optional
	https://github.com/rogerq/linux/commit/290955f6b4d1f2d6d466732c6ec92d009500fb67

Roger Quadros (4):
  CLK: ti: dra7: Initialize USB_DPLL
  ARM: dts: dra7: Add USB related nodes
  dts: dra7-evm: add USB support
  ARM: DRA7: hwmod: Add SYSCONFIG for usb_otg_ss

 arch/arm/boot/dts/dra7-evm.dts            |   22 +++++
 arch/arm/boot/dts/dra7.dtsi               |  136 +++++++++++++++++++++++++++++
 arch/arm/mach-omap2/omap_hwmod_7xx_data.c |   12 +++
 drivers/clk/omap/clk-7xx.c                |   11 +++
 4 files changed, 181 insertions(+), 0 deletions(-)

-- 
1.7.4.1

