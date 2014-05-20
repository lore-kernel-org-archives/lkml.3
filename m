Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751273AbaETU2V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 16:28:21 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:39573 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbaETU2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 16:28:18 -0400
From: Matt Porter <mporter@linaro.org>
To: Devicetree List <devicetree@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
Cc: Tim Kryger <tim.kryger@linaro.org>, Markus Mayer <markus.mayer@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH RESEND v2 0/4] Support additional regulators on BCM590xx
Date: Tue, 20 May 2014 16:28:02 -0400
Message-Id: <1400617686-9701-1-git-send-email-mporter@linaro.org>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes since v1:
	- Fix a several commit log typos and capitalization
	- Drop use of addmap[0|1] in favor of i2c_[pri|sec]
	- Replace regmap[0|1] with regmap_[pri|sec]

This series enables support for 7 additional regulators on the BCM59056
PMU. These regulators are accessed via a secondary I2C slave address.
The MFD driver exposes an additional regmap descriptor for the additional
address space and the regulator implements support for GPLDO1-6 and VBUS
regulators.

Matt Porter (4):
  mfd: bcm590xx: update binding with additional BCM59056 regulators
  mfd: bcm590xx: add support for secondary I2C slave address
  regulator: bcm590xx: add support for regulators on secondary I2C slave
  ARM: dts: bcm590xx: add support for GPLDO and VBUS regulators

 Documentation/devicetree/bindings/mfd/bcm590xx.txt |  4 +-
 arch/arm/boot/dts/bcm59056.dtsi                    | 21 +++++
 drivers/mfd/bcm590xx.c                             | 60 ++++++++++----
 drivers/regulator/bcm590xx-regulator.c             | 92 +++++++++++++++++++---
 include/linux/mfd/bcm590xx.h                       |  9 ++-
 5 files changed, 158 insertions(+), 28 deletions(-)

-- 
1.8.4

