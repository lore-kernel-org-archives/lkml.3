Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759284AbaDKOfT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 10:35:19 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:54295 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755051AbaDKOfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 10:35:12 -0400
From: Gabriel FERNANDEZ <gabriel.fernandez@st.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-input@vger.kernel.org, kernel@stlinux.com,
        Lee Jones <lee.jones@linaro.org>,
        Gabriel Fernandez <gabriel.fernandez@linaro.org>
Subject: [PATCH v3 0/7] Add ST Keyscan driver
Date: Fri, 11 Apr 2014 16:33:27 +0200
Message-Id: <1397226820-5604-1-git-send-email-gabriel.fernandez@linaro.org>
X-Mailer: git-send-email 1.9.1
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-04-11_04:2014-04-11,2014-04-11,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes in v3:
- add reset controller management
- rename 'st,debounce_us' into 'st,debounce-us' in dt binding

Changes in v2:
- use standard format for matrix keymap
- suppress __exit mark for keyscan_remove()
- Call to keyscan_stop() shoudl go into keyscan_close() implementation
- use of SIMPLE_DEV_PM_OPS()
- rename compatibility name into "st,sti-keyscan"
- suppress platform data management
- omit vendor information
- cosmetic change and renaming

The goal of this series is to add ST Keyscan support to ST SoCs.
The DT definition is added for STiH415 and STiH416 SoCs on
B2000 board.

Gabriel Fernandez (5):
  drivers: input: keyboard: st-keyscan: add keyscan driver
  ARM: STi: DT: add keyscan for stih415
  ARM: STi: DT: add keyscan for stih416
  ARM: STi: DT: add keyscan for stih41x-b2000
  ARM: multi_v7_defconfig: add ST Keyscan driver

Giuseppe CONDORELLI (2):
  driver: reset: sti: add keyscan for stih415
  driver: reset: sti: add keyscan for stih416

 .../devicetree/bindings/input/st-keyscan.txt       |  60 +++++
 arch/arm/boot/dts/stih415-pinctrl.dtsi             |  16 ++
 arch/arm/boot/dts/stih415.dtsi                     |  12 +
 arch/arm/boot/dts/stih416-pinctrl.dtsi             |  16 ++
 arch/arm/boot/dts/stih416.dtsi                     |  12 +
 arch/arm/boot/dts/stih41x-b2000.dtsi               |  23 ++
 arch/arm/configs/multi_v7_defconfig                |   1 +
 drivers/input/keyboard/Kconfig                     |  12 +
 drivers/input/keyboard/Makefile                    |   1 +
 drivers/input/keyboard/st-keyscan.c                | 260 +++++++++++++++++++++
 drivers/reset/sti/reset-stih415.c                  |   1 +
 drivers/reset/sti/reset-stih416.c                  |   1 +
 .../dt-bindings/reset-controller/stih415-resets.h  |   1 +
 .../dt-bindings/reset-controller/stih416-resets.h  |   1 +
 14 files changed, 417 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/input/st-keyscan.txt
 create mode 100644 drivers/input/keyboard/st-keyscan.c

-- 
1.9.1

