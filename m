Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756477Ab3IZJwF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 05:52:05 -0400
Received: from eu1sys200aog108.obsmtp.com ([207.126.144.125]:40839 "EHLO
	eu1sys200aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750933Ab3IZJwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 05:52:02 -0400
From: Alexandre TORGUE <alexandre.torgue@st.com>
To: Wolfram Sang <wsa@the-dreams.de>, srinivas.kandagatla@st.com,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-i2c@vger.kernel.org
Cc: stephen.gallimore@st.com, stuart.menefy@st.com,
        Lee Jones <lee.jones@linaro.org>, gabriel.fernandez@st.com,
        kernel@stlinux.com, Maxime Coquelin <maxime.coquelin@st.com>
Subject: [PATCH v2 0/4] Add I2C support to ST SoCs
Date: Thu, 26 Sep 2013 11:51:12 +0200
Message-Id: <1380189072-5551-1-git-send-email-maxime.coquelin@st.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The goal of this series is to add I2C support to ST SoCs.
The DT definition is added for STiH415 and STiH416 SoCs on
B2000 and B2020 boards.

The series has been tested working on STiH416-B2020 board.
It applies on top of v3.12-rc1.

Changes since v1:
  - Anti-glitch filtering simplified (Only HW Anti-glitch is kept)
  - Update I2C timings to comply with I2C specification
  - Handle spurious interrupts properly
  - DT binding updates taking into account Stephen's comments
  - Use "clock-names" property to comply with GCF
  - DT cosmetic changes reported by Lee and Gabriel 

Signed-off-by: Maxime Coquelin <maxime.coquelin@st.com>

Maxime Coquelin (4):
  i2c: busses: i2c-st: Add ST I2C controller
  ARM: STi: Supply I2C configuration to STiH416 SoC
  ARM: STi: Supply I2C configuration to STiH415 SoC
  ARM: STi: Add I2C config to B2000 and B2020 boards

 Documentation/devicetree/bindings/i2c/i2c-st.txt |   37 ++
 arch/arm/boot/dts/stih415-pinctrl.dtsi           |   36 ++
 arch/arm/boot/dts/stih415.dtsi                   |   65 ++
 arch/arm/boot/dts/stih416-pinctrl.dtsi           |   35 ++
 arch/arm/boot/dts/stih416.dtsi                   |   65 ++
 arch/arm/boot/dts/stih41x-b2000.dtsi             |    7 +
 arch/arm/boot/dts/stih41x-b2020.dtsi             |   20 +
 drivers/i2c/busses/Kconfig                       |   10 +
 drivers/i2c/busses/Makefile                      |    1 +
 drivers/i2c/busses/i2c-st.c                      |  691 ++++++++++++++++++++++
 drivers/i2c/busses/i2c-st.h                      |  208 +++++++
 11 files changed, 1175 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/i2c/i2c-st.txt
 create mode 100644 drivers/i2c/busses/i2c-st.c
 create mode 100644 drivers/i2c/busses/i2c-st.h

-- 
1.7.9.5

