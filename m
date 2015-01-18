Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752025AbbARTPQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 14:15:16 -0500
Received: from v1ros.org ([109.234.34.72]:57346 "EHLO smtp.v1ros.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751410AbbARTPM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 14:15:12 -0500
From: Roman Volkov <v1ron@v1ros.org>
To: Alexey Charkov <alchark@gmail.com>
Cc: vt8500-wm8505-linux-kernel@googlegroups.com, linux-kernel@vger.kernel.org,
        Roman Volkov <v1ron@mail.ru>, Roman Volkov <v1ron@v1ros.org>
Subject: [PATCH v2] dts: vt8500: Add SDHC node to DTS file for WM8650
Date: Sun, 18 Jan 2015 22:14:04 +0300
Message-Id: <1421608444-25525-1-git-send-email-v1ron@v1ros.org>
X-Mailer: git-send-email 2.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current kernel contains SDHC driver but not DTS node for it.
Add missing node to make SDHC controller working by default on WM8650.

Signed-off-by: Roman Volkov <v1ron@v1ros.org>
---
 arch/arm/boot/dts/wm8650.dtsi | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm/boot/dts/wm8650.dtsi b/arch/arm/boot/dts/wm8650.dtsi
index b1c59a7..5d85ccd 100644
--- a/arch/arm/boot/dts/wm8650.dtsi
+++ b/arch/arm/boot/dts/wm8650.dtsi
@@ -187,6 +187,15 @@
 			interrupts = <43>;
 		};
 
+		sdhc@d800a000 {
+			compatible = "wm,wm8505-sdhc";
+			reg = <0xd800a000 0x400>;
+			interrupts = <20 21>;
+			clocks = <&clksdhc>;
+			bus-width = <4>;
+			sdon-inverted;
+		};
+
 		fb: fb@d8050800 {
 			compatible = "wm,wm8505-fb";
 			reg = <0xd8050800 0x200>;
-- 
2.2.1

