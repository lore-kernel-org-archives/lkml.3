Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708Ab3EaPQQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 11:16:16 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:42374 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753336Ab3EaPQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 11:16:04 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH v2] ARM: ux500: Allocate correct amount of memory for the u8540 in DT
Date: Fri, 31 May 2013 16:15:51 +0100
Message-Id: <1370013351-7960-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As it stands, the memory node in the u8540 Device Tree is ignored and
memory is actually stipulated by the bootloader via ATAGS. ARM core
architecture code then extracts the memory ATAG and inserts it into the
Device Tree. In the u8540 the LittleKernel bootloader only stipulates
512MB of memory; however, the u8540 actually has 2GB. We're taking the
responsibility to register the remainder from Device Tree here.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/ccu8540.dts |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/ccu8540.dts b/arch/arm/boot/dts/ccu8540.dts
index 12f0bc2..5603764 100644
--- a/arch/arm/boot/dts/ccu8540.dts
+++ b/arch/arm/boot/dts/ccu8540.dts
@@ -16,8 +16,8 @@
 	model = "ST-Ericsson U8540 platform with Device Tree";
 	compatible = "st-ericsson,ccu8540", "st-ericsson,u8540";
 
-	memory {
-		reg = <0x00000000 0x20000000>;
+	memory@0 {
+		reg = <0x20000000 0x1f000000>, <0xc0000000 0x3f000000>;
 	};
 
 	soc {
-- 
1.7.10.4

