Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933641AbaLED6Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 22:58:24 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:55422 "EHLO
	mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933269AbaLED6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 22:58:22 -0500
X-Listener-Flag: 11101
From: Flora Fu <flora.fu@mediatek.com>
To: Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        <arm@kernel.org>
CC: Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <srv_heupstream@mediatek.com>, Sascha Hauer <kernel@pengutronix.de>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Flora Fu <flora.fu@mediatek.com>,
        Eddie Huang <eddie.huang@mediatek.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Dongdong Cheng <dongdong.cheng@mediatek.com>,
        HenryC Chen <henryc.cheng@mediatek.com>,
        Menghui Lin <menghui.lin@mediatek.com>
Subject: [PATCH v3 0/8] Add Support for MediaTek PMIC MT6397 MFD Core and Regulator
Date: Fri, 5 Dec 2014 11:57:39 +0800
Message-ID: <1417751867-13235-1-git-send-email-flora.fu@mediatek.com>
X-Mailer: git-send-email 1.8.1.1.dirty
MIME-Version: 1.0
Content-Type: text/plain
X-MTK: N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The patch sets add support for MediaTek PMIC MT6397 MFD core and its regulator driver.
This is hardware layout for access PMIC MT6397 from AP SoC MT8135.
Between PMIC MT6397 and MT8135, the physical signal channel is SPI bus.
A specific hardware called PMIC Wrapper or PWRAP to handle access protocols in both PMIC and AP side.

+-----------------+           +---------------+
|                 |           |               |
| Mediatek AP SoC |           |               |
| (ex. MT8135)    |           |    MT6397     |
|                 |           |               |
|      +--------+ | (SPI bus) | +--------+    |
|      |        | |-----------| |        |    |
|      |  PMIC  | |-----------| |  PMIC  |    |
|      | Wrapper| |-----------| | Wrapper|    |
|      |        | |-----------| |        |    |
|      +--------+ |           | +--------+    |
|                 |           |               |
+-----------------+           +---------------+

Changes since v2
================
(1) Patch 1/8: Update kernel config of MT8135 PMIC Wrapper. It needs to select REGMAP.
(2) Patch 2/8: Update patch of MT6397 MFD driver to fix defeat of coding styles.
(3) Patch 3/8: Update MT6397 regulator driver
	- use standard helpers for ops ".set_voltage_sel", ".get_voltage_sel" and ".is_enabled"
	- remove regulator's DT matching codes in the driver.  
	- fix defeat of coding styles.
(4) Patch 4/8: Update document for MT8135 PMIC wrapper.
(5) Patch 5/8: Update document for MT6397 MFD.
(6) Patch 6/8: Update document for MT6397 regulators.
(7) Patch 7/8: Update device tree for MT8135 PMIC wrapper in mt8135.dtsi.
(8) Patch 8/8: Add device tree for MT6397 MFD and regulators in mt8135-evbp1.dts board file.
Second version (v2):
http://lists.infradead.org/pipermail/linux-arm-kernel/2014-November/307069.html

Changes since v1
================
(1) Patch 1/8: Add MT8135 PMIC wrapper driver for SoC's proprietary hardware.
(2) Patch 2/8: Update patch of MT6397 MFD driver to contain only MFD related codes and fix defeat of coding styles.
(3) Patch 3/8: Update MT6397 regulator driver
	- use helpers and standard ways for specifying data in regulator description.
	- add more comments to explaining why the driver implement its own regulator_ops for ".is_enabled", ".set_voltage_sel" and ".get_voltage_sel".
	- update driver implement for coding styles.
(4) Patch 4/8: Add document for MT8135 PMIC wrapper.
(5) Patch 5/8: Update document for MT6397 MFD.
(6) Patch 6/8: Update document for MT6397 regulators.
(7) Patch 7/8: Add device tree for MT6397 MFD in mt8135.dtsi.
(8) Patch 8/8: Update device tree for MT6397 regulators in mt8135.dtsi.
Initial version (v1):
http://lists.infradead.org/pipermail/linux-arm-kernel/2014-November/302984.html

This driver is based on 3.18-rc1.

Flora Fu (8):
  soc: mediatek: Add PMIC wrapper for MT8135 and MT6397 SoC
  mfd: MT6397: Add support for PMIC MT6397 MFD
  regulator: MT6397: Add support for MT6397 regulator
  dt-bindings:: Add document for MT8135 PMIC Wrapper
  dt-bindings: Add document for MT6397 MFD
  dt-bindings: Add document for MT6397 regulator
  ARM: dts: mt8135: Add support for MT8135 PMIC wrapper
  ARM: dts: mt8135: Add support for MT6397 MFD and regulator

 Documentation/devicetree/bindings/mfd/mt6397.txt   |  75 ++
 .../bindings/regulator/mt6397-regulator.txt        | 217 ++++++
 .../soc/mediatek/mediatek,mt8135-pwrap.txt         |  51 ++
 arch/arm/boot/dts/mt8135-evbp1.dts                 | 193 +++++
 arch/arm/boot/dts/mt8135.dtsi                      |  14 +
 drivers/mfd/Kconfig                                |  10 +
 drivers/mfd/Makefile                               |   1 +
 drivers/mfd/mt6397-core.c                          |  87 +++
 drivers/regulator/Kconfig                          |   9 +
 drivers/regulator/Makefile                         |   1 +
 drivers/regulator/mt6397-regulator.c               | 332 ++++++++
 drivers/soc/Kconfig                                |   1 +
 drivers/soc/Makefile                               |   1 +
 drivers/soc/mediatek/Kconfig                       |  12 +
 drivers/soc/mediatek/Makefile                      |   1 +
 drivers/soc/mediatek/mt8135-pmic-wrap.c            | 844 +++++++++++++++++++++
 drivers/soc/mediatek/mt8135-pmic-wrap.h            | 138 ++++
 include/linux/mfd/mt6397/core.h                    |  23 +
 include/linux/mfd/mt6397/registers.h               | 362 +++++++++
 include/linux/regulator/mt6397-regulator.h         |  49 ++
 include/linux/soc/mediatek/mtk-pmic-wrap.h         |  25 +
 21 files changed, 2446 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mfd/mt6397.txt
 create mode 100644 Documentation/devicetree/bindings/regulator/mt6397-regulator.txt
 create mode 100644 Documentation/devicetree/bindings/soc/mediatek/mediatek,mt8135-pwrap.txt
 create mode 100644 drivers/mfd/mt6397-core.c
 create mode 100644 drivers/regulator/mt6397-regulator.c
 create mode 100644 drivers/soc/mediatek/Kconfig
 create mode 100644 drivers/soc/mediatek/Makefile
 create mode 100644 drivers/soc/mediatek/mt8135-pmic-wrap.c
 create mode 100644 drivers/soc/mediatek/mt8135-pmic-wrap.h
 create mode 100644 include/linux/mfd/mt6397/core.h
 create mode 100644 include/linux/mfd/mt6397/registers.h
 create mode 100644 include/linux/regulator/mt6397-regulator.h
 create mode 100644 include/linux/soc/mediatek/mtk-pmic-wrap.h

--
1.8.1.1.dirty


