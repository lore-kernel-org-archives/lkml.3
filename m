Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395Ab3JDQQD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 12:16:03 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:54686 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754530Ab3JDQQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 12:16:01 -0400
From: Fabio Estevam <festevam@gmail.com>
To: shawn.guo@linaro.org
Cc: linux-kernel@vger.kernel.org, Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH 2/3] ARM: dts: imx53-qsb: SDHC1 does not have cd-gpios
Date: Fri,  4 Oct 2013 13:15:27 -0300
Message-Id: <1380903328-17598-2-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1380903328-17598-1-git-send-email-festevam@gmail.com>
References: <1380903328-17598-1-git-send-email-festevam@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

SDHC1 does not have any GPIO for reading the card detection status, so
remove 'cd-gpios'.

After this change card detection works via the internal SD controller mechanism.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 arch/arm/boot/dts/imx53-qsb.dts | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm/boot/dts/imx53-qsb.dts b/arch/arm/boot/dts/imx53-qsb.dts
index b646ef1..029ae42 100644
--- a/arch/arm/boot/dts/imx53-qsb.dts
+++ b/arch/arm/boot/dts/imx53-qsb.dts
@@ -122,7 +122,6 @@
 &esdhc1 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_esdhc1_1>;
-	cd-gpios = <&gpio3 13 0>;
 	status = "okay";
 };
 
@@ -153,7 +152,6 @@
 				MX53_PAD_PATA_DATA15__GPIO2_15    0x80000000
 				MX53_PAD_EIM_DA11__GPIO3_11       0x80000000
 				MX53_PAD_EIM_DA12__GPIO3_12       0x80000000
-				MX53_PAD_EIM_DA13__GPIO3_13       0x80000000
 				MX53_PAD_PATA_DA_0__GPIO7_6       0x80000000
 				MX53_PAD_PATA_DA_2__GPIO7_8	  0x80000000
 				MX53_PAD_GPIO_16__GPIO7_11        0x80000000
-- 
1.8.1.2

