Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752027AbaEUIpr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 04:45:47 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:45193 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218AbaEUIpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 04:45:45 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        maxime.coquelin@st.com, patrice.chotard@st.com
Cc: lee.jones@linaro.org, kernel@stlinux.com
Subject: [PATCH v2 2/3] ARM: sti: stih416: Enable board LED support for B2020 RevE
Date: Wed, 21 May 2014 09:45:23 +0100
Message-Id: <1400661924-10745-2-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1400661924-10745-1-git-send-email-lee.jones@linaro.org>
References: <1400661924-10745-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are two LEDs available on the B2020 RevE board, one red, one
green.  In this patch we enable the red one for "heartbeat" and turn
the green one off.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/stih416-b2020-revE.dts | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/arm/boot/dts/stih416-b2020-revE.dts b/arch/arm/boot/dts/stih416-b2020-revE.dts
index da3c1c4..ba0fa2c 100644
--- a/arch/arm/boot/dts/stih416-b2020-revE.dts
+++ b/arch/arm/boot/dts/stih416-b2020-revE.dts
@@ -14,6 +14,20 @@
 	compatible = "st,stih416-b2020", "st,stih416";
 
 	soc {
+		leds {
+			compatible = "gpio-leds";
+			red {
+				#gpio-cells		= <1>;
+				label			= "Front Panel LED";
+				gpios			= <&PIO4 1>;
+				linux,default-trigger	= "heartbeat";
+			};
+			green {
+				gpios			= <&PIO1 3>;
+				default-state 		= "off";
+			};
+		};
+
 		ethernet1: dwmac@fef08000 {
 			snps,reset-gpio = <&PIO0 7>;
 		};
-- 
1.8.3.2

