Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933189Ab3ECOdZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 10:33:25 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:52724 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933113Ab3ECOdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 10:33:21 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 02/63] ARM: ux500: Setup the DMA40 driver's DT node using the new DMA API
Date: Fri,  3 May 2013 15:31:48 +0100
Message-Id: <1367591569-32197-3-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1367591569-32197-1-git-send-email-lee.jones@linaro.org>
References: <1367591569-32197-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new DMA is now available, so let's use it to setup ST-Ericsson's
DMA40 driver when Device Tree is enabled.

Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/dbx5x0.dtsi |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/dbx5x0.dtsi b/arch/arm/boot/dts/dbx5x0.dtsi
index 0f462b7..8a82b18 100644
--- a/arch/arm/boot/dts/dbx5x0.dtsi
+++ b/arch/arm/boot/dts/dbx5x0.dtsi
@@ -182,12 +182,13 @@
 			interrupts = <0 23 0x4>;
 		};
 
-		dma-controller@801C0000 {
-			compatible = "stericsson,db8500-dma40",
-					"stericsson,dma40";
+		dma: dma-controller@801C0000 {
+			compatible = "stericsson,db8500-dma40", "stericsson,dma40";
 			reg = <0x801C0000 0x1000 0x40010000 0x800>;
 			reg-names = "base", "lcpa";
 			interrupts = <0 25 0x4>;
+
+			#dma-cells = <3>;
 		};
 
 		prcmu: prcmu@80157000 {
-- 
1.7.10.4

