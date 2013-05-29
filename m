Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966146Ab3E2Ngq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 09:36:46 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:48640 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935179Ab3E2Nga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 09:36:30 -0400
From: Gabriel Fernandez <gabriel.fernandez.st@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>,
        Olivier Clergeaud <olivier.clergeaud@st.com>,
        Gabriel Fernandez <gabriel.fernandez@st.com>,
        Gabriel Fernandez <gabriel.fernandez@stericsson.com>
Subject: [PATCH 4/4] ARM: u8540: Add DT probing for SFH7741 Proximity Sensor
Date: Wed, 29 May 2013 15:33:27 +0200
Message-Id: <1369834407-30762-5-git-send-email-gabriel.fernandez.st@gmail.com>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1369834407-30762-1-git-send-email-gabriel.fernandez.st@gmail.com>
References: <1369834407-30762-1-git-send-email-gabriel.fernandez.st@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gabriel Fernandez <gabriel.fernandez@st.com>

Here we ensure the SFH7741 Proximity Sensor is registered through
gpio-keys when booting with Device Tree enabled.

Signed-off-by: Gabriel Fernandez <gabriel.fernandez@stericsson.com>
---
 arch/arm/boot/dts/ccu8540-uib-v3.dts | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/arm/boot/dts/ccu8540-uib-v3.dts b/arch/arm/boot/dts/ccu8540-uib-v3.dts
index dc90571..26f3106 100644
--- a/arch/arm/boot/dts/ccu8540-uib-v3.dts
+++ b/arch/arm/boot/dts/ccu8540-uib-v3.dts
@@ -13,6 +13,21 @@
 
 / {
 	model = "ST-Ericsson U8540 platform with device tree UIB v3";
+
+	gpio_keys {
+		compatible = "gpio-keys";
+		#address-cells = <1>;
+		#size-cells = <0>;
+		v-vcc-supply = <&ab8500_ldo_aux1_reg>;
+
+		button@1 {
+			debounce_interval = <50>;
+			wakeup = <1>;
+			linux,code = <0xb>;
+			label = "SFH7741 Proximity Sensor";
+			gpios = <&gpio7 5 0x8>;
+		};
+	};
 };
 
 &i2c2 {
-- 
1.8.1.1

