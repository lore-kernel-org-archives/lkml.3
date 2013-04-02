Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761098Ab3DBNWX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 09:22:23 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:52329 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761057Ab3DBNWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 09:22:21 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 7/9] ARM: ux500: Add a VQMMC (level-shifting) regulator DT node for Snowball
Date: Tue,  2 Apr 2013 14:21:54 +0100
Message-Id: <1364908916-29803-7-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364908916-29803-1-git-send-email-lee.jones@linaro.org>
References: <1364908916-29803-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Until recently platform code took care of all MMCI level-shifting by
way of an ios_handler() call-back. Now it is the driver's responsibility
to handle. In order to so that we need to provide the VQMMC regulator
reference in Device Tree. This patch takes care of that.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/snowball.dts |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm/boot/dts/snowball.dts b/arch/arm/boot/dts/snowball.dts
index cc99447..6b4f8b9 100644
--- a/arch/arm/boot/dts/snowball.dts
+++ b/arch/arm/boot/dts/snowball.dts
@@ -119,6 +119,13 @@
 			};
 		};
 
+		vmmci: regulator-gpio {
+			gpios = <&gpio6 25 0x4>;
+			enable-gpio = <&gpio7 4 0x4>;
+
+			status = "okay";
+		};
+
 		// External Micro SD slot
 		sdi0_per1@80126000 {
 			arm,primecell-periphid = <0x10480180>;
@@ -126,6 +133,7 @@
 			bus-width = <4>;
 			mmc-cap-mmc-highspeed;
 			vmmc-supply = <&ab8500_ldo_aux3_reg>;
+			vqmmc-supply = <&vmmci>;
 
 			cd-gpios  = <&gpio6 26 0x4>; // 218
 			cd-inverted;
-- 
1.7.10.4

