Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968AbaETNYR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 09:24:17 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:51539 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752660AbaETNYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 09:24:03 -0400
From: Gabriel FERNANDEZ <gabriel.fernandez@st.com>
To: Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
        Maxime Coquelin <maxime.coquelin@st.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, olof@lixom.net
Cc: linux-arm-kernel@lists.infradead.org, kernel@stlinux.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Gabriel Fernandez <gabriel.fernandez@linaro.org>
Subject: [PATCH v3 00/11] ARM: STi: Add Clock driver support STiH415 & STiH416
Date: Tue, 20 May 2014 15:22:44 +0200
Message-Id: <1400592175-13176-1-git-send-email-gabriel.fernandez@linaro.org>
X-Mailer: git-send-email 1.9.1
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-05-20_02:2014-05-20,2014-05-20,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes in v2:
 - cosmetic changes (lower case of clock nodes and names)

Changes in v2:
 - move stih415-clks.h & stih416-clks.h to include/dt-bindings/clock/
 - add clk_ignore_unused to bootargs. Interconnect clocks are not yet
   managed at the init, then we have to start the kernel with 
   clk_ignore_unused.

The goal of this series is to add DT definition for STiH415 
and STiH416 SoCs on B2000 and B2020 boards.

Gabriel Fernandez (11):
  ARM: STi: DT: STiH41x: Rename CLK_SYSIN into clk_sysin
  ARM: STi: DT: STiH416: 416 DT Entry for clockgen A0/1/10/11/12
  ARM: STi: DT: STiH416: Remove unused CLK_S_ICN_REG_0 fixed clock
  ARM: STi: DT: STiH416: Remove unused CLK_S_GMAC0_PHY & CLK_S_ETH1_PHY
    fixed clocks
  ARM: STi: DT: STiH416: 416 DT Entry for clockgen B/C/D/E/F
  ARM: STi: DT: STiH416: 416 DT Entry for clockgen A9/DDR/GPU
  ARM: STi: DT: STiH415: 415 DT Entry for clockgen A0/1/10/11/12
  ARM: STi: DT: STiH415: Remove unused CLK_S_ICN_REG_0 fixed clock
  ARM: STi: DT: STiH415: Remove unused CLK_S_GMAC0_PHY & CLK_S_ETH1_PHY
    fixed clocks
  ARM: STi: DT: STiH415: 415 DT Entry for clockgen A9
  ARM: STi: DT: STiH41x Add clk_ignore_unused to bootargs

 arch/arm/boot/dts/stih415-clock.dtsi     | 519 +++++++++++++++++++++-
 arch/arm/boot/dts/stih415.dtsi           |  18 +-
 arch/arm/boot/dts/stih416-clock.dtsi     | 735 ++++++++++++++++++++++++++++++-
 arch/arm/boot/dts/stih416.dtsi           |  18 +-
 arch/arm/boot/dts/stih41x-b2000.dtsi     |   2 +-
 arch/arm/boot/dts/stih41x-b2020.dtsi     |   2 +-
 include/dt-bindings/clock/stih415-clks.h |  15 +
 include/dt-bindings/clock/stih416-clks.h |  15 +
 8 files changed, 1268 insertions(+), 56 deletions(-)
 create mode 100644 include/dt-bindings/clock/stih415-clks.h
 create mode 100644 include/dt-bindings/clock/stih416-clks.h

-- 
1.9.1

