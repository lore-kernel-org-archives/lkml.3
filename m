Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934618Ab3IDJcA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 05:32:00 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:61426 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934597Ab3IDJb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 05:31:57 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        jic23@cam.ac.uk
Cc: arnd@arndb.de, linus.walleij@linaro.org, denis.ciocca@st.com,
        linux-iio@vger.kernel.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 02/11] ARM: ux500: Enable the LPS001WP Pressure & Temperature sensor from DT
Date: Wed,  4 Sep 2013 10:31:34 +0100
Message-Id: <1378287103-21765-3-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378287103-21765-1-git-send-email-lee.jones@linaro.org>
References: <1378287103-21765-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After applying this node the LPS001WP sensor chip should probe
successfully once the driver support has also been applied.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/ste-snowball.dts | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/boot/dts/ste-snowball.dts b/arch/arm/boot/dts/ste-snowball.dts
index cf9b16e..aad8f54 100644
--- a/arch/arm/boot/dts/ste-snowball.dts
+++ b/arch/arm/boot/dts/ste-snowball.dts
@@ -153,6 +153,16 @@
 			status = "okay";
 		};
 
+		i2c@80128000 {
+			lps001wp@5c {
+				compatible = "lps001wp";
+				reg = <0x5c>;
+
+				vdd-supply = <&ab8500_ldo_aux1_reg>;
+				vms-supply = <&db8500_vsmps2_reg>;
+			};
+		};
+
 		uart@80120000 {
 			status = "okay";
 		};
-- 
1.8.1.2

