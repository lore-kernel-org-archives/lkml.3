Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419Ab3JDQQL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 12:16:11 -0400
Received: from mail-qe0-f53.google.com ([209.85.128.53]:55387 "EHLO
	mail-qe0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755376Ab3JDQQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 12:16:08 -0400
From: Fabio Estevam <festevam@gmail.com>
To: shawn.guo@linaro.org
Cc: linux-kernel@vger.kernel.org, Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH 3/3] ARM: dts: imx53-qsb: Do not use GPIO1_8 as wakeup source
Date: Fri,  4 Oct 2013 13:15:28 -0300
Message-Id: <1380903328-17598-3-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1380903328-17598-1-git-send-email-festevam@gmail.com>
References: <1380903328-17598-1-git-send-email-festevam@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

On the mx53qsb board with mc34708 PMIC, GPIO1_8 resets the system, so better not
to use it as a wakeup source.

Use GPIO 2_14 and 2_15 for wakeup sources instead.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 arch/arm/boot/dts/imx53-qsb.dts | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx53-qsb.dts b/arch/arm/boot/dts/imx53-qsb.dts
index 029ae42..91a5935 100644
--- a/arch/arm/boot/dts/imx53-qsb.dts
+++ b/arch/arm/boot/dts/imx53-qsb.dts
@@ -55,19 +55,20 @@
 			label = "Power Button";
 			gpios = <&gpio1 8 0>;
 			linux,code = <116>; /* KEY_POWER */
-			gpio-key,wakeup;
 		};
 
 		volume-up {
 			label = "Volume Up";
 			gpios = <&gpio2 14 0>;
 			linux,code = <115>; /* KEY_VOLUMEUP */
+			gpio-key,wakeup;
 		};
 
 		volume-down {
 			label = "Volume Down";
 			gpios = <&gpio2 15 0>;
 			linux,code = <114>; /* KEY_VOLUMEDOWN */
+			gpio-key,wakeup;
 		};
 	};
 
-- 
1.8.1.2

