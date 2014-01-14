Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752021AbaANK6E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 05:58:04 -0500
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:50948 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751974AbaANK56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 05:57:58 -0500
From: Srinivas Kandagatla <srinivas.kandagatla@st.com>
To: <linux-arm-kernel@lists.infradead.org>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Stuart Menefy <stuart.menefy@st.com>,
        Grant Likely <grant.likely@linaro.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stephen.gallimore@st.com>, <kernel@stlinux.com>,
        <lee.jones@linaro.com>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>
Subject: [PATCH v1 0/6] STi reset controller suppport
Date: Tue, 14 Jan 2014 10:50:13 +0000
Message-ID: <1389696613-19683-1-git-send-email-srinivas.kandagatla@st.com>
X-Mailer: git-send-email 1.7.6.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.65.51.147]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

This patch series adds reset controller support for STi SOC series STiH415 and
STiH416. It adds support for both regular reset and soft reset controllers.
On STi series SOCs reset lines are wired up to system configuration registers.

Patch 01: Adds reset controller based on system configuration registers via
regmap.

Patch 02, 03: adds STiH415 and STiH416 reset controller drivers.

Patch 04, 05: adds STiH415 and STiH416 soft reset controllers.

The final patch 06 selects reset controller in mach-sti Kconfig.

This reset controller will be used by gmac, i2c and st-ir drivers.

Comments?

Thanks,
srini

Srinivas Kandagatla (2):
  drivers: reset: stih415: add softreset controller
  drivers: reset: stih416: add softreset controller

Stephen Gallimore (4):
  drivers: reset: STi SoC system configuration reset controller support
  drivers: reset: Reset controller driver for STiH415
  drivers: reset: Reset controller driver for STiH416
  ARM: STi: Add reset controller support to mach-sti Kconfig

 .../devicetree/bindings/reset/st,sti-powerdown.txt |   46 +++++
 .../devicetree/bindings/reset/st,sti-softreset.txt |   45 +++++
 arch/arm/boot/dts/stih415.dtsi                     |   11 ++
 arch/arm/boot/dts/stih416.dtsi                     |   11 ++
 arch/arm/mach-sti/Kconfig                          |    3 +
 drivers/reset/Kconfig                              |    2 +
 drivers/reset/Makefile                             |    3 +
 drivers/reset/sti/Kconfig                          |   15 ++
 drivers/reset/sti/Makefile                         |    4 +
 drivers/reset/sti/reset-stih415.c                  |   99 +++++++++++
 drivers/reset/sti/reset-stih416.c                  |  101 +++++++++++
 drivers/reset/sti/reset-syscfg.c                   |  186 ++++++++++++++++++++
 drivers/reset/sti/reset-syscfg.h                   |   69 +++++++
 .../dt-bindings/reset-controller/stih415-resets.h  |   23 +++
 .../dt-bindings/reset-controller/stih416-resets.h  |   25 +++
 15 files changed, 643 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/reset/st,sti-powerdown.txt
 create mode 100644 Documentation/devicetree/bindings/reset/st,sti-softreset.txt
 create mode 100644 drivers/reset/sti/Kconfig
 create mode 100644 drivers/reset/sti/Makefile
 create mode 100644 drivers/reset/sti/reset-stih415.c
 create mode 100644 drivers/reset/sti/reset-stih416.c
 create mode 100644 drivers/reset/sti/reset-syscfg.c
 create mode 100644 drivers/reset/sti/reset-syscfg.h
 create mode 100644 include/dt-bindings/reset-controller/stih415-resets.h
 create mode 100644 include/dt-bindings/reset-controller/stih416-resets.h

-- 
1.7.6.5

