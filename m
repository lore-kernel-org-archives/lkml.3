Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968014Ab3DRKPY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 06:15:24 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:49358 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967907Ab3DRKNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 06:13:18 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 25/32] ARM: ux500: Setup the DMA40 driver's DT node using the new DMA API
Date: Thu, 18 Apr 2013 11:12:07 +0100
Message-Id: <1366279934-30761-26-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new DMA is now available, so let's use it to setup ST-Ericsson's
DMA40 driver when Device Tree is enabled.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/dbx5x0.dtsi |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/dbx5x0.dtsi b/arch/arm/boot/dts/dbx5x0.dtsi
index 0f462b7..e2fa20f 100644
--- a/arch/arm/boot/dts/dbx5x0.dtsi
+++ b/arch/arm/boot/dts/dbx5x0.dtsi
@@ -182,12 +182,14 @@
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
+			dma-channels = <0>; /* Zero means read from H/W. */
 		};
 
 		prcmu: prcmu@80157000 {
-- 
1.7.10.4

