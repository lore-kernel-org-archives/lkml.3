Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751344Ab3LJXOs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 18:14:48 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:36868 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856Ab3LJXOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 18:14:46 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] ARM: dts: msm: Fix gpio interrupt and reg length
Date: Tue, 10 Dec 2013 15:14:43 -0800
Message-Id: <1386717283-30227-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.5.1.109.g3d252a9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The summary interrupt is #16 in the SPI space. Unfortunately,
when this device was translated from board files to DT we forgot
to subtract 16 from the interrupt number to translate it into a
SPI interrupt. Also, the register space is larger than 4k, increase
it appropriately so that the gpio driver doesn't try to access
registers outside of its mapping.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/boot/dts/qcom-msm8660-surf.dts | 4 ++--
 arch/arm/boot/dts/qcom-msm8960-cdp.dts  | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/qcom-msm8660-surf.dts b/arch/arm/boot/dts/qcom-msm8660-surf.dts
index 8632991..12439f5 100644
--- a/arch/arm/boot/dts/qcom-msm8660-surf.dts
+++ b/arch/arm/boot/dts/qcom-msm8660-surf.dts
@@ -30,11 +30,11 @@
 
 	msmgpio: gpio@800000 {
 		compatible = "qcom,msm-gpio";
-		reg = <0x00800000 0x1000>;
+		reg = <0x00800000 0x4000>;
 		gpio-controller;
 		#gpio-cells = <2>;
 		ngpio = <173>;
-		interrupts = <0 32 0x4>;
+		interrupts = <0 16 0x4>;
 		interrupt-controller;
 		#interrupt-cells = <2>;
 	};
diff --git a/arch/arm/boot/dts/qcom-msm8960-cdp.dts b/arch/arm/boot/dts/qcom-msm8960-cdp.dts
index cf0956c..3a84c9a 100644
--- a/arch/arm/boot/dts/qcom-msm8960-cdp.dts
+++ b/arch/arm/boot/dts/qcom-msm8960-cdp.dts
@@ -33,7 +33,7 @@
 		gpio-controller;
 		#gpio-cells = <2>;
 		ngpio = <150>;
-		interrupts = <0 32 0x4>;
+		interrupts = <0 16 0x4>;
 		interrupt-controller;
 		#interrupt-cells = <2>;
 		reg = <0x800000 0x4000>;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

