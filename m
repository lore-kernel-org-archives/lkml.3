Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756596AbaGaKUV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 06:20:21 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:43602 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751850AbaGaKUR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 06:20:17 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <nsekhar@ti.com>, <robh+dt@kernel.org>
CC: <khilman@deeprootsystems.com>, <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>, <pawel.moll@arm.com>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/6] ARM: DTS: da850-evm: Enable McASP via DT boot
Date: Thu, 31 Jul 2014 13:18:52 +0300
Message-ID: <1406801934-23334-5-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <1406801934-23334-1-git-send-email-peter.ujfalusi@ti.com>
References: <1406801934-23334-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add pinctrl nodes for the McASP0 pins and configure McASP to the desired
mode for the board.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 arch/arm/boot/dts/da850-evm.dts | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/arch/arm/boot/dts/da850-evm.dts b/arch/arm/boot/dts/da850-evm.dts
index 1e11e5a5f723..09118c72e83f 100644
--- a/arch/arm/boot/dts/da850-evm.dts
+++ b/arch/arm/boot/dts/da850-evm.dts
@@ -17,6 +17,18 @@
 	soc {
 		pmx_core: pinmux@1c14120 {
 			status = "okay";
+
+			mcasp0_pins: pinmux_mcasp0_pins {
+				pinctrl-single,bits = <
+					/*
+					 * AHCLKX, ACLKX, AFSX, AHCLKR, ACLKR,
+					 * AFSR, AMUTE
+					 */
+					0x00 0x11111111 0xffffffff
+					/* AXR11, AXR12 */
+					0x04 0x00011000 0x000ff000
+				>;
+			};
 		};
 		serial0: serial@1c42000 {
 			status = "okay";
@@ -170,3 +182,22 @@
 		};
 	};
 };
+
+&mcasp0 {
+	#sound-dai-cells = <0>;
+	status = "okay";
+	pinctrl-names = "default";
+	pinctrl-0 = <&mcasp0_pins>;
+
+	op-mode = <0>;          /* MCASP_IIS_MODE */
+	tdm-slots = <2>;
+	/* 4 serializer */
+	serial-dir = <  /* 0: INACTIVE, 1: TX, 2: RX */
+		0 0 0 0
+		0 0 0 0
+		0 0 0 1
+		2 0 0 0
+	>;
+	tx-num-evt = <32>;
+	rx-num-evt = <32>;
+};
-- 
2.0.2

