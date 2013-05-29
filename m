Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935190Ab3E2Nga (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 09:36:30 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:34411 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966128Ab3E2Ng1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 09:36:27 -0400
From: Gabriel Fernandez <gabriel.fernandez.st@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>,
        Olivier Clergeaud <olivier.clergeaud@st.com>,
        Gabriel Fernandez <gabriel.fernandez@st.com>,
        Gabriel Fernandez <gabriel.fernandez@stericsson.com>
Subject: [PATCH 2/4] ARM: u8540: Add device tree support for lp5521 leds
Date: Wed, 29 May 2013 15:33:25 +0200
Message-Id: <1369834407-30762-3-git-send-email-gabriel.fernandez.st@gmail.com>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1369834407-30762-1-git-send-email-gabriel.fernandez.st@gmail.com>
References: <1369834407-30762-1-git-send-email-gabriel.fernandez.st@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gabriel Fernandez <gabriel.fernandez@st.com>

This patch adds DT probing of lp5521 leds for u8540.

Signed-off-by: Gabriel Fernandez <gabriel.fernandez@stericsson.com>
---
 arch/arm/boot/dts/ccu8540-uib-v3.dts | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/arch/arm/boot/dts/ccu8540-uib-v3.dts b/arch/arm/boot/dts/ccu8540-uib-v3.dts
index 4b4982e..422a292 100644
--- a/arch/arm/boot/dts/ccu8540-uib-v3.dts
+++ b/arch/arm/boot/dts/ccu8540-uib-v3.dts
@@ -14,3 +14,25 @@
 / {
 	model = "ST-Ericsson U8540 platform with device tree UIB v3";
 };
+
+&i2c2 {
+
+	lp5521@32 {
+		compatible = "national,lp5521";
+		reg = <0x32>;
+		label = "lp5521_pri";
+		clock-mode = /bits/ 8 <2>;
+		chan0 {
+			led-cur = /bits/ 8 <0x2f>;
+			max-cur = /bits/ 8 <0x5f>;
+		};
+		chan1 {
+			led-cur = /bits/ 8 <0x2f>;
+			max-cur = /bits/ 8 <0x5f>;
+		};
+		chan2 {
+			led-cur = /bits/ 8 <0x2f>;
+			max-cur = /bits/ 8 <0x5f>;
+		};
+	};
+};
-- 
1.8.1.1

