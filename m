Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754375AbaFDQcI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 12:32:08 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:35045 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754279AbaFDQb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 12:31:27 -0400
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        chris@printf.net, ulf.hansson@linaro.org, maxime.coquelin@st.com,
        patrice.chotard@st.com, srinivas.kandagatla@gmail.com
Cc: peter.griffin@linaro.org, kernel@stlinux.com, linux-mmc@vger.kernel.org,
        devicetree@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>
Subject: [PATCH v3 08/10] ARM: STi: DT: Enable second sdhci controller for stih416 b2020 boards.
Date: Wed,  4 Jun 2014 17:30:22 +0100
Message-Id: <1401899424-1365-9-git-send-email-peter.griffin@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401899424-1365-1-git-send-email-peter.griffin@linaro.org>
References: <1401899424-1365-1-git-send-email-peter.griffin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The second controller is only present on the stih416 SoC. Also
mark this as non-removeable as its eMMC.

Signed-off-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
Acked-by: Lee Jones <lee.jones@linaro.org>
Acked-by: Maxime Coquelin <maxime.coquelin@st.com>
---
 arch/arm/boot/dts/stih416-b2020-revE.dts | 6 ++++++
 arch/arm/boot/dts/stih416-b2020.dts      | 8 ++++++++
 2 files changed, 14 insertions(+)

diff --git a/arch/arm/boot/dts/stih416-b2020-revE.dts b/arch/arm/boot/dts/stih416-b2020-revE.dts
index ba0fa2c..68dfdaf 100644
--- a/arch/arm/boot/dts/stih416-b2020-revE.dts
+++ b/arch/arm/boot/dts/stih416-b2020-revE.dts
@@ -31,5 +31,11 @@
 		ethernet1: dwmac@fef08000 {
 			snps,reset-gpio = <&PIO0 7>;
 		};
+
+		mmc1: sdhci@fe81f000 {
+			status       = "okay";
+			bus-width    = <8>;
+			non-removable;
+		};
 	};
 };
diff --git a/arch/arm/boot/dts/stih416-b2020.dts b/arch/arm/boot/dts/stih416-b2020.dts
index 4e2df66..d42ff1d 100644
--- a/arch/arm/boot/dts/stih416-b2020.dts
+++ b/arch/arm/boot/dts/stih416-b2020.dts
@@ -12,4 +12,12 @@
 / {
 	model = "STiH416 B2020";
 	compatible = "st,stih416-b2020", "st,stih416";
+
+	soc {
+		mmc1: sdhci@fe81f000 {
+			status       = "okay";
+			bus-width    = <8>;
+			non-removable;
+		};
+	};
 };
-- 
1.9.1

