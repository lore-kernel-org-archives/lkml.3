Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103AbaHAGOb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 02:14:31 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:49597 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753511AbaHAGOQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 02:14:16 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <nsekhar@ti.com>, <robh+dt@kernel.org>
CC: <khilman@deeprootsystems.com>, <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>, <pawel.moll@arm.com>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 4/6] ARM: DTS: da850-evm: Enable McASP via DT boot
Date: Fri, 1 Aug 2014 09:13:28 +0300
Message-ID: <1406873610-5037-5-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <1406873610-5037-1-git-send-email-peter.ujfalusi@ti.com>
References: <1406873610-5037-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add pinctrl nodes for the McASP0 pins and configure McASP to the desired
mode for the board.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 arch/arm/boot/dts/da850-evm.dts | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/arch/arm/boot/dts/da850-evm.dts b/arch/arm/boot/dts/da850-evm.dts
index 1e11e5a5f723..1422c311af4c 100644
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
@@ -170,3 +182,21 @@
 		};
 	};
 };
+
+&mcasp0 {
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

