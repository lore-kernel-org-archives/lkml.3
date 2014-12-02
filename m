Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754401AbaLBRMS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 12:12:18 -0500
Received: from mail.kmu-office.ch ([178.209.48.109]:60843 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754187AbaLBRMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 12:12:16 -0500
From: Stefan Agner <stefan@agner.ch>
To: shawn.guo@linaro.org, kernel@pengutronix.de, linux@roeck-us.net,
        arnd@arndb.de, sre@kernel.org, fkan@apm.com, mark.rutland@arm.com
Cc: dbaryshkov@gmail.com, dwmw2@infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stefan@agner.ch
Subject: [PATCH v3 0/3] power: reset: vf610 system reset controller
Date: Tue,  2 Dec 2014 18:11:57 +0100
Message-Id: <1417540320-2385-1-git-send-email-stefan@agner.ch>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This third version does essentially the same as v1, but with a lot
less code due to the usage of syscon and syscon-reboot driver. My
earlier misgivings that it might be a problem for the suspend/resume
implementation later on did not hold true: I tested my prelinear
suspend code and in case the code really needs to access some
registers form assembler, it is possible to map temporarly the
relevant region again.

I refrained from adding POWER_RESET_SYSCON as a hard dependency for
Vybrid (SOC_VF610): In its dual-core configuration, one might want
have the Cortex-M4 in charge of the system reset... Hence the user
should be able to build a kernel without the system reset (beside
the option to create a board specific device tree with disabled
SRC node).

Shawn, the defconfig change is based on the latest (almost-merged?)
defconfig patch.

Changes since v2:
- Drop priority property for syscon-reboot
- Alter default priority of syscon-reboot, set it to 192

Changes since v1:
- Total rework using syscon/syscon-reboot capabilities
- Enhance syscon-reboot with priority capabilities

Stefan Agner (3):
  power: reset: adjust priority of simple syscon reboot driver
  ARM: dts: vf610: add system reset controller and syscon-reboot
  ARM: imx_v6_v7_defconfig: add POWER_RESET_SYSCON

 arch/arm/boot/dts/vf500.dtsi         |  4 ++++
 arch/arm/boot/dts/vfxxx.dtsi         | 12 ++++++++++++
 arch/arm/configs/imx_v6_v7_defconfig |  8 ++++----
 drivers/power/reset/syscon-reboot.c  |  2 +-
 4 files changed, 21 insertions(+), 5 deletions(-)

-- 
2.1.3

