Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751148Ab3LRFVU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 00:21:20 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:13260 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853Ab3LRFVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 00:21:17 -0500
From: Wenyou Yang <wenyou.yang@atmel.com>
To: <broonie@kernel.org>
CC: <lgirdwood@gmail.com>, <linux-kernel@vger.kernel.org>,
        <grant.likely@linaro.org>, <rob.herring@calxeda.com>,
        <linux-doc@vger.kernel.org>, <vpalatin@chromium.org>,
        <nicolas.ferre@atmel.com>, <plagnioj@jcrosoft.com>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <wenyou.yang@atmel.com>
Subject: [PATCH v3 0/3] regulator: act8865: add PMIC driver
Date: Wed, 18 Dec 2013 13:14:48 +0800
Message-ID: <1387343691-18985-1-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

Thanks a lot for your direction.

According to your advice, I prepared this version.

The patch set is to add act8865 PMIC driver.

The active-semi act8865 is designed as a PMIC for Atmel sama5d3x and at91sam9 series.
Its datasheet is available at: http://www.active-semi.com/sheets/ACT8865_Datasheet.pdf.

The patches is based on the branch: for-next of git respository, 
	git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git
and [PATCH] regulator: read low power states configuration from device tree from Vincent Palatin
	https://patchwork.kernel.org/patch/2833667/

Thanks.

Best Regards,
Wenyou Yang

v3 changelog:
 1./ Add map_voltage() operation which missed.
 2./ Remove regulator_unregister statement which no need.
 3./ Remvoe memset statement.
 4./ Change the device tree regulator-name with the supply name in the schematic.
 5./ List all theregulator name in the binding doc.

v2 changelog:
 1./ Using regmap for register I/O instead of i2c function directly.
 2./ Using the helpers provided by the core.
 3./ Remove noisy logging.
 4./ Using the latest regulator register API.
 5./ Using module_i2c_driver helper macro replace module_init and module_exit.
 6./ Remove the vsel-state-low dt property which is not used now.


Wenyou Yang (3):
  regulator: act8865: add PMIC act8865 driver
  regulator: act8865: add device tree binding doc
  ARM: dts: sama5d3xcm: add the regulator device node

 .../bindings/regulator/act8865-regulator.txt       |   58 +++
 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 arch/arm/boot/dts/sama5d3xcm.dtsi                  |   46 +++
 drivers/regulator/Kconfig                          |    8 +
 drivers/regulator/Makefile                         |    1 +
 drivers/regulator/act8865-regulator.c              |  381 ++++++++++++++++++++
 include/linux/regulator/act8865.h                  |   53 +++
 7 files changed, 548 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/regulator/act8865-regulator.txt
 create mode 100644 drivers/regulator/act8865-regulator.c
 create mode 100644 include/linux/regulator/act8865.h

-- 
1.7.9.5

