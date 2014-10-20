Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751683AbaJTLhN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 07:37:13 -0400
Received: from smtp121.ord1c.emailsrvr.com ([108.166.43.121]:39563 "EHLO
	smtp121.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750798AbaJTLhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 07:37:11 -0400
X-Sender-Id: pramod.gurav@smartplayin.com
From: Pramod Gurav <pramod.gurav@smartplayin.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org
Cc: Pramod Gurav <pramod.gurav@smartplayin.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH] ARM: DT: apq8064: Add Support for SD Card Detect for ifc6410 board
Date: Mon, 20 Oct 2014 17:09:54 +0530
Message-Id: <1413805194-4360-1-git-send-email-pramod.gurav@smartplayin.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This changes muxes in gpio26 pin to function as gpio and adds support
for sd card detect for apq8064 based IFC6410 board.

Cc: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Kumar Gala <galak@codeaurora.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>

---
 arch/arm/boot/dts/qcom-apq8064-ifc6410.dts |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm/boot/dts/qcom-apq8064-ifc6410.dts b/arch/arm/boot/dts/qcom-apq8064-ifc6410.dts
index b396c83..bf6262f 100644
--- a/arch/arm/boot/dts/qcom-apq8064-ifc6410.dts
+++ b/arch/arm/boot/dts/qcom-apq8064-ifc6410.dts
@@ -12,6 +12,14 @@
 					function = "gsbi1";
 				};
 			};
+
+			card_detect: card_detect {
+				mux {
+					pins = "gpio26";
+					function = "gpio";
+					bias-disable;
+				};
+			};
 		};
 
 		gsbi@12440000 {
@@ -49,6 +57,9 @@
 			/* External micro SD card */
 			sdcc3: sdcc@12180000 {
 				status = "okay";
+				pinctrl-names	= "default";
+				pinctrl-0	= <&card_detect>;
+				cd-gpios	= <&tlmm_pinmux 26 1>;
 			};
 			/* WLAN */
 			sdcc4: sdcc@121c0000 {
-- 
1.7.9.5

