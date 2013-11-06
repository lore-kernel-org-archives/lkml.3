Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155Ab3KFI1a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 03:27:30 -0500
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:33879 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756066Ab3KFI1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 03:27:25 -0500
From: Maxime COQUELIN <maxime.coquelin@st.com>
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
        Lee Jones <lee.jones@linaro.org>, gabriel.fernandez@st.com
Subject: [PATCH v6 0/4] Add I2C support to ST SoCs
Date: Wed,  6 Nov 2013 09:25:11 +0100
Message-Id: <1383726315-27534-1-git-send-email-maxime.coquelin@st.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The goal of this series is to add I2C support to ST SoCs.
The DT definition is added for STiH415 and STiH416 SoCs on
B2000 and B2020 boards.

The series has been tested working on STiH416-B2020 board.
It applies on top of v3.12.

Changes since v5:
  - Fix pinctrl properties description in DT binding documentation
  - Add a new compatible string. It is now compatible with "st,comms-ssc-i2c"
    and "st,comms-ssc4-i2c"
  - Revert back to generic DT properties for Anti-glitch filtering as "unstable"
    properties are not yet in place
  - Use threaded irq
  - Use readl_relaxed/writel_relaxed instead of readl/writel
  - Remove st_i2c_deglitch struct
  - Various cosmetics changes
  - Remove I2C class-based instantiation

Changes since v4:
  - Fixed IRQ flags to level high triggering as reported by Stephen Gallimore
  - Revert back to generic DT properties for Anti-glitch filtering. Their DT
    binding documentation will be updated when i2c DT binding docuementation
    will be created (In Wolfram's ToDo list)
  - Rebased on v3.12-rc5

Changes since v3:
  - Switch back to vendor specific DT properties regarding the anti-glitch
    filter configuration, as this IP is the only one having such a filter
  - Add DT binding documentation regarding pinctrl-related properties
  - Move recommended properties to optional properties in DT binding
    documentation
  - Rebased on v3.12-rc4

Changes since v2:
  - Create generic DT property for Anti-glitch filtering configuration
  - Sort i2c-st entries in Makefile and Kconfig
  - Various cosmetics changes
  - Return IRQ_NONE in case of spurious interrupt
  - Use INIT_COMPLETION instead of init_completion in st_i2c_xfer_msg
  - Simplify st_i2c_xfer as proposed by Wolfram
  - Fix PM ops issues
  - Change author name to myself and fix license to GPL v2
  - Include .h file content into the .c file

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

 Documentation/devicetree/bindings/i2c/i2c-st.txt |   41 +
 arch/arm/boot/dts/stih415-pinctrl.dtsi           |   36 +
 arch/arm/boot/dts/stih415.dtsi                   |   53 ++
 arch/arm/boot/dts/stih416-pinctrl.dtsi           |   35 +
 arch/arm/boot/dts/stih416.dtsi                   |   53 ++
 arch/arm/boot/dts/stih41x-b2000.dtsi             |    9 +
 arch/arm/boot/dts/stih41x-b2020.dtsi             |   22 +
 drivers/i2c/busses/Kconfig                       |   10 +
 drivers/i2c/busses/Makefile                      |    1 +
 drivers/i2c/busses/i2c-st.c                      |  872 ++++++++++++++++++++++
 10 files changed, 1132 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/i2c/i2c-st.txt
 create mode 100644 drivers/i2c/busses/i2c-st.c

-- 
1.7.9.5

