Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055Ab3LQFhh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 00:37:37 -0500
Received: from nasmtp01.atmel.com ([192.199.1.246]:63101 "EHLO
	DVREDG02.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750901Ab3LQFhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 00:37:36 -0500
From: Wenyou Yang <wenyou.yang@atmel.com>
To: <broonie@kernel.org>
CC: <lgirdwood@gmail.com>, <linux-kernel@vger.kernel.org>,
        <grant.likely@linaro.org>, <rob.herring@calxeda.com>,
        <linux-doc@vger.kernel.org>, <vpalatin@chromium.org>,
        <nicolas.ferre@atmel.com>, <plagnioj@jcrosoft.com>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <wenyou.yang@atmel.com>
Subject: [PATCH 0/3 v2] regulator: act8865: add PMIC driver
Date: Tue, 17 Dec 2013 13:36:34 +0800
Message-ID: <1387258597-21866-1-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

Thanks a lot for quickly feedbacks. According to your advice, I prepared the new version.

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

 .../bindings/regulator/act8865-regulator.txt       |   56 +++
 arch/arm/boot/dts/sama5d3xcm.dtsi                  |   46 +++
 drivers/regulator/Kconfig                          |    8 +
 drivers/regulator/Makefile                         |    1 +
 drivers/regulator/act8865-regulator.c              |  381 ++++++++++++++++++++
 include/linux/regulator/act8865.h                  |   55 +++
 6 files changed, 547 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/regulator/act8865-regulator.txt
 create mode 100644 drivers/regulator/act8865-regulator.c
 create mode 100644 include/linux/regulator/act8865.h

-- 
1.7.9.5

