Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961AbaGIPIY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 11:08:24 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:65106 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932578AbaGIPIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 11:08:20 -0400
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        ulf.hansson@linaro.org, chris@printf.net, maxime.coquelin@st.com,
        patrice.chotard@st.com, srinivas.kandagatla@gmail.com
Cc: peter.griffin@linaro.org, lee.jones@linaro.org, linux-mmc@vger.kernel.org,
        devicetree@vger.kernel.org, peppe.cavallaro@st.com
Subject: [PATCH v4 07/10] ARM: STi: DT: Enable mmc0 for both stih415 and stih416 SoCs
Date: Wed,  9 Jul 2014 16:07:38 +0100
Message-Id: <1404918461-25390-8-git-send-email-peter.griffin@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404918461-25390-1-git-send-email-peter.griffin@linaro.org>
References: <1404918461-25390-1-git-send-email-peter.griffin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because the first sdhci controller is present on both stih415 and
stih416 SoC which can both populate the b2020 board, it can be
enabled in the generic DT file.

Signed-off-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
Acked-by: Lee Jones <lee.jones@linaro.org>
Acked-by: Maxime Coquelin <maxime.coquelin@st.com>
---
 arch/arm/boot/dts/stih41x-b2020.dtsi  | 4 ++++
 arch/arm/boot/dts/stih41x-b2020x.dtsi | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/arch/arm/boot/dts/stih41x-b2020.dtsi b/arch/arm/boot/dts/stih41x-b2020.dtsi
index d8a8429..5c2df46 100644
--- a/arch/arm/boot/dts/stih41x-b2020.dtsi
+++ b/arch/arm/boot/dts/stih41x-b2020.dtsi
@@ -74,5 +74,9 @@
 
 			pinctrl-0	= <&pinctrl_rgmii1>;
 		};
+
+		mmc0: sdhci@fe81e000 {
+			bus-width = <8>;
+		};
 	};
 };
diff --git a/arch/arm/boot/dts/stih41x-b2020x.dtsi b/arch/arm/boot/dts/stih41x-b2020x.dtsi
index df01c12..f797a06 100644
--- a/arch/arm/boot/dts/stih41x-b2020x.dtsi
+++ b/arch/arm/boot/dts/stih41x-b2020x.dtsi
@@ -8,6 +8,10 @@
  */
 / {
 	soc {
+		mmc0: sdhci@fe81e000 {
+			status = "okay";
+		};
+
 		spifsm: spifsm@fe902000 {
 			#address-cells = <1>;
 			#size-cells    = <1>;
-- 
1.9.1

