Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756624AbaGaKUw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 06:20:52 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:55953 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756532AbaGaKTk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 06:19:40 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <nsekhar@ti.com>, <robh+dt@kernel.org>
CC: <khilman@deeprootsystems.com>, <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>, <pawel.moll@arm.com>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/6] ARM: DTS: da850-evm: Add node for tlv320aic3106 codec
Date: Thu, 31 Jul 2014 13:18:53 +0300
Message-ID: <1406801934-23334-6-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <1406801934-23334-1-git-send-email-peter.ujfalusi@ti.com>
References: <1406801934-23334-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The board uses aic3106 for audio.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 arch/arm/boot/dts/da850-evm.dts | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/arm/boot/dts/da850-evm.dts b/arch/arm/boot/dts/da850-evm.dts
index 09118c72e83f..b9ef2be0b145 100644
--- a/arch/arm/boot/dts/da850-evm.dts
+++ b/arch/arm/boot/dts/da850-evm.dts
@@ -51,6 +51,20 @@
 			tps: tps@48 {
 				reg = <0x48>;
 			};
+			tlv320aic3106: tlv320aic3106@1b {
+				#sound-dai-cells = <0>;
+				compatible = "ti,tlv320aic3106";
+				reg = <0x18>;
+				status = "okay";
+
+				/* Regulators */
+				IOVDD-supply = <&vdcdc2_reg>;
+				/* Derived from VBAT: Baseboard 3.3V / 1.8V */
+				AVDD-supply = <&vbat>;
+				DRVDD-supply = <&vbat>;
+				DVDD-supply = <&vbat>;
+			};
+
 		};
 		wdt: wdt@1c21000 {
 			status = "okay";
-- 
2.0.2

