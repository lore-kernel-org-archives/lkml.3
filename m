Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752512AbaIKRJd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 13:09:33 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:46033 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835AbaIKRJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 13:09:31 -0400
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kishon@ti.com, maxime.coquelin@st.com, srinivas.kandagatla@gmail.com,
        b.zolnierkie@samsung.com, patrice.chotard@st.com, arnd@arndb.de
Cc: peter.griffin@linaro.org, lee.jones@linaro.org, devicetree@vger.kernel.org,
        peppe.cavallaro@st.com
Subject: [PATCH v3 0/4]   Add picoPHY usb phy driver found on stih407 family SoC's
Date: Thu, 11 Sep 2014 18:02:43 +0100
Message-Id: <1410454967-21500-1-git-send-email-peter.griffin@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds support for the picoPHY usb phy which is used by the usb2
and usb3 host controllers when controlling usb2/1.1 devices. It is found on
stih407 family SoC's from the consumer electronics devision of STMicroelectronics.

Changes since v2:
 - Remove .data and hardcode phy ops in devm_phy_create call (arndb)
 - Add COMPILE_TEST in kconfig (arndb)
 - Add depends on RESET_CONTROLLER in kconfig so COMPILE_TEST works
 - select GENERIC_PHY instead of depends on (Bartlomiej)

Changes since v1:
 - Remove reference to stih410 in dt documentation (kishon)
 - Fix alignment issue in dt example (kishon)
 - usbpicophy@f8 since you have a reg property (kishon)
 - Enable driver in multi_v7_defconfig

Peter Griffin (4):
  phy: phy-stih407-usb: Add usb picoPHY driver found on stih407 SoC
    family
  phy: phy-stih407-usb: Add dt documentation for USB picophy found on
    stih407 SoC family
  MAINTAINERS: Add phy-stih407-usb.c file to ARCH/STI architecture
  ARM: multi_v7_defconfig: Enable stih407 usb picophy

 .../devicetree/bindings/phy/phy-stih407-usb.txt    |  30 ++++
 MAINTAINERS                                        |   1 +
 arch/arm/configs/multi_v7_defconfig                |   1 +
 drivers/phy/Kconfig                                |   9 ++
 drivers/phy/Makefile                               |   2 +
 drivers/phy/phy-stih407-usb.c                      | 177 +++++++++++++++++++++
 6 files changed, 220 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/phy/phy-stih407-usb.txt
 create mode 100644 drivers/phy/phy-stih407-usb.c

-- 
1.9.1

