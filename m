Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482Ab3H1UdZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 16:33:25 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:54138 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755084Ab3H1Ucv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 16:32:51 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-serial@vger.kernel.org,
        David Brown <davidb@codeaurora.org>
Subject: [PATCH v4 2/2] ARM: dts: msm: Update uartdm compatible strings
Date: Wed, 28 Aug 2013 13:32:41 -0700
Message-Id: <1377721961-3508-3-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1377721961-3508-1-git-send-email-sboyd@codeaurora.org>
References: <1377721961-3508-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let's follow the ratified DT binding and use uartdm instead of
hsuart. This does break backwards compatibility but this
shouldn't be a problem because the uart driver isn't probing on
these devices without adding clock support (which isn't merged so
far).

Cc: David Brown <davidb@codeaurora.org>
Acked-by: Kumar Gala <galak@codeaurora.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/boot/dts/msm8660-surf.dts | 2 +-
 arch/arm/boot/dts/msm8960-cdp.dts  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/msm8660-surf.dts b/arch/arm/boot/dts/msm8660-surf.dts
index cdc010e..386d428 100644
--- a/arch/arm/boot/dts/msm8660-surf.dts
+++ b/arch/arm/boot/dts/msm8660-surf.dts
@@ -38,7 +38,7 @@
 	};
 
 	serial@19c40000 {
-		compatible = "qcom,msm-hsuart", "qcom,msm-uart";
+		compatible = "qcom,msm-uartdm-v1.3", "qcom,msm-uartdm";
 		reg = <0x19c40000 0x1000>,
 		      <0x19c00000 0x1000>;
 		interrupts = <0 195 0x0>;
diff --git a/arch/arm/boot/dts/msm8960-cdp.dts b/arch/arm/boot/dts/msm8960-cdp.dts
index db2060c..532050b 100644
--- a/arch/arm/boot/dts/msm8960-cdp.dts
+++ b/arch/arm/boot/dts/msm8960-cdp.dts
@@ -38,7 +38,7 @@
 	};
 
 	serial@16440000 {
-		compatible = "qcom,msm-hsuart", "qcom,msm-uart";
+		compatible = "qcom,msm-uartdm-v1.3", "qcom,msm-uartdm";
 		reg = <0x16440000 0x1000>,
 		      <0x16400000 0x1000>;
 		interrupts = <0 154 0x0>;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

