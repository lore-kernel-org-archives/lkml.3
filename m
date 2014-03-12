Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996AbaCLJaa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 05:30:30 -0400
Received: from mx08-00178001.pphosted.com ([62.209.51.94]:51879 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751804AbaCLJa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 05:30:28 -0400
From: Maxime COQUELIN <maxime.coquelin@st.com>
To: Rob Landley <rob@landley.net>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        Stuart Menefy <stuart.menefy@st.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Maxime Coquelin <maxime.coquelin@st.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@stlinux.com
Cc: lee.jones@linaro.org
Subject: [PATCH v4 0/6] Add STiH407 SoC and reference board support
Date: Wed, 12 Mar 2014 09:50:04 +0100
Message-Id: <1394614210-15698-1-git-send-email-maxime.coquelin@st.com>
X-Mailer: git-send-email 1.9.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-03-12_03:2014-03-11,2014-03-12,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds basic support to the STMicroelectronics STiH407 SoC and its
B2120 reference board. The STiH407 is a dual-core ARM Cortex-A9 CPU aimed at
STB market.

Changes since v3:
-----------------
	- Removed SOC_STIH407 as unused for now
	- Cosmetic changes in DT
	- Added new lines in pinctrl-st around if:s
	- Use ARRAY_SIZE instead of raw values

Changes since v2:
-----------------
    - Reordered the pinctrl patches
    - Moved stih407_flashdata to stih407 pinctrl patch

Changes since v1:
-----------------
	- Changed patch 2 commit title
	- Rebased pinctrl patches to linux-pinctrl/devel
	- Rebased ARM patches to arm_soc/for-next

Giuseppe Cavallaro (2):
  pinctrl: st: Enhance the controller to manage unavailable registers
  pinctrl: st: add pinctrl support for the STiH407 SoC

Maxime Coquelin (4):
  ARM: STi: Add STiH407 SoC support
  pinctrl: st: Use ARRAY_SIZE instead of raw value for number of delays
  ARM: dts: Add STiH407 SoC support
  ARM: dts: STiH407: Add B2120 board support

 Documentation/arm/sti/stih407-overview.txt    |  18 +
 Documentation/devicetree/bindings/arm/sti.txt |  15 +
 arch/arm/boot/dts/Makefile                    |   3 +-
 arch/arm/boot/dts/stih407-b2120.dts           |  78 ++++
 arch/arm/boot/dts/stih407-clock.dtsi          |  40 ++
 arch/arm/boot/dts/stih407-pinctrl.dtsi        | 615 ++++++++++++++++++++++++++
 arch/arm/boot/dts/stih407.dtsi                | 263 +++++++++++
 arch/arm/mach-sti/board-dt.c                  |   1 +
 drivers/pinctrl/pinctrl-st.c                  | 125 ++++--
 9 files changed, 1112 insertions(+), 46 deletions(-)
 create mode 100644 Documentation/arm/sti/stih407-overview.txt
 create mode 100644 Documentation/devicetree/bindings/arm/sti.txt
 create mode 100644 arch/arm/boot/dts/stih407-b2120.dts
 create mode 100644 arch/arm/boot/dts/stih407-clock.dtsi
 create mode 100644 arch/arm/boot/dts/stih407-pinctrl.dtsi
 create mode 100644 arch/arm/boot/dts/stih407.dtsi

-- 
1.9.0

