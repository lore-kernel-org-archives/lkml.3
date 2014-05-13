Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759372AbaEMIUP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 04:20:15 -0400
Received: from top.free-electrons.com ([176.31.233.9]:36191 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758901AbaEMIUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 04:20:12 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Emilio Lopez <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>, stern@rowland.harvard.edu,
        kishon@ti.com, hdegoede@redhat.com
Cc: Boris Brezillon <boris@free-electrons.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, zhuzhenhua@allwinnertech.com,
        linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH v4 0/8] Add Allwinner A31 USB support
Date: Tue, 13 May 2014 10:18:57 +0200
Message-Id: <1399969145-11642-1-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

This patchset adds support for the USB controllers found in the
Allwinner A31.

While the design is similar to the earlier Allwinner SoCs that are
already supported, a few details here and there change, like the fact
that the PHYs now have one clock per phy, while it used to be only one
for all the PHYs.

Thanks,
Maxime

Changes from v3:
  - Asserted back the ECHI/OHCI in reset if probe fails
  - Drop of the redundant NULL assignent for the PMU in the PHY rework

Changes from v2:
  - Fixed indentation and used the reset framework in all case and not
    just in DT case
  - Added a default value to the dedicated_clocks variable. Setting it
    actually started triggering a gcc warning for no reason. Ended up
    reworking a bit the code to avoid it.

Changes from v1:
  - Moved the reset assertion/deassertion to probe/remove
  - Moved the dedicated_clocks to the probe function instead of the
    private structure since it was the only user

Boris BREZILLON (2):
  usb: ehci-platform: add optional reset controller retrieval
  ARM: sunxi: dt: add APP4-EVB1 board support

Maxime Ripard (6):
  clk: sunxi: Implement A31 USB clock
  ARM: sun6i: Add the USB clocks to the DTSI
  phy: sunxi: Rework phy initialization
  phy: usb: sunxi: Introduce Allwinner A31 USB PHY support
  usb: ohci-platform: Enable optional use of reset controller
  ARM: sun6i: dt: Add support for the USB controllers

 Documentation/devicetree/bindings/usb/usb-ehci.txt |  1 +
 Documentation/devicetree/bindings/usb/usb-ohci.txt |  1 +
 arch/arm/boot/dts/Makefile                         |  1 +
 arch/arm/boot/dts/sun6i-a31-app4-evb1.dts          | 57 ++++++++++++++
 arch/arm/boot/dts/sun6i-a31.dtsi                   | 88 ++++++++++++++++++++++
 drivers/clk/sunxi/clk-sunxi.c                      |  6 ++
 drivers/phy/phy-sun4i-usb.c                        | 75 +++++++++---------
 drivers/usb/host/ehci-platform.c                   | 26 ++++++-
 drivers/usb/host/ohci-platform.c                   | 27 ++++++-
 9 files changed, 241 insertions(+), 41 deletions(-)
 create mode 100644 arch/arm/boot/dts/sun6i-a31-app4-evb1.dts

-- 
1.9.3

