Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756589AbaGaKT4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 06:19:56 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:55644 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751850AbaGaKTx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 06:19:53 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <nsekhar@ti.com>, <robh+dt@kernel.org>
CC: <khilman@deeprootsystems.com>, <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>, <pawel.moll@arm.com>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 6/6] ARM: DTS: da850-evm: Enable audio via simple-card
Date: Thu, 31 Jul 2014 13:18:54 +0300
Message-ID: <1406801934-23334-7-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <1406801934-23334-1-git-send-email-peter.ujfalusi@ti.com>
References: <1406801934-23334-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The audio on the board is using McASP <-> tlv320aic3106 codec and we have
LineIn and LineOut jacks.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 arch/arm/boot/dts/da850-evm.dts | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/arch/arm/boot/dts/da850-evm.dts b/arch/arm/boot/dts/da850-evm.dts
index b9ef2be0b145..031117a4a797 100644
--- a/arch/arm/boot/dts/da850-evm.dts
+++ b/arch/arm/boot/dts/da850-evm.dts
@@ -143,6 +143,33 @@
 		regulator-max-microvolt = <5000000>;
 		regulator-boot-on;
 	};
+
+	sound {
+		compatible = "simple-audio-card";
+		simple-audio-card,name = "DA850/OMAP-L138 EVM";
+		simple-audio-card,widgets =
+			"Line", "Line In",
+			"Line", "Line Out";
+		simple-audio-card,routing =
+			"LINE1L", "Line In",
+			"LINE1R", "Line In",
+			"Line Out", "LLOUT",
+			"Line Out", "RLOUT";
+		simple-audio-card,format = "dsp_b";
+		simple-audio-card,bitclock-master = <&link0_codec>;
+		simple-audio-card,frame-master = <&link0_codec>;
+		simple-audio-card,bitclock-inversion;
+
+		simple-audio-card,cpu {
+			sound-dai = <&mcasp0>;
+			system-clock-frequency = <24576000>;
+		};
+
+		link0_codec: simple-audio-card,codec {
+			sound-dai = <&tlv320aic3106>;
+			system-clock-frequency = <24576000>;
+		};
+	};
 };
 
 /include/ "tps6507x.dtsi"
-- 
2.0.2

