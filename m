Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932202Ab3CYPC4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 11:02:56 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:61143 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932116Ab3CYPCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 11:02:54 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 1/3] ARM: ux500: Add device nodes for TCDM and TCPM memory locations
Date: Mon, 25 Mar 2013 15:02:36 +0000
Message-Id: <1364223758-17621-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PRCMU requires the Tightly Coupled Memory (TCM) locations in
order to function correctly. A recent move to send the base
addresses though the PRCMU platform device resource instead of
defines found in <mach/*>, means that dbx500 devices can no longer
boot successfully. These new nodes will allow the PRCMU to extract
the base memory locations from Device Tree instead.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/snowball.dts |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm/boot/dts/snowball.dts b/arch/arm/boot/dts/snowball.dts
index d3ec32f..6195ffa 100644
--- a/arch/arm/boot/dts/snowball.dts
+++ b/arch/arm/boot/dts/snowball.dts
@@ -126,6 +126,14 @@
 			 };
 		};
 
+		prcmu-tcpm-per4@801b0000 {
+			reg = <0x801b0000 0x1000>;
+		};
+
+		prcmu-tcdm-per4@801b8000 {
+			reg = <0x801b8000 0x1000>;
+		};
+
 		external-bus@50000000 {
 			status = "okay";
 
-- 
1.7.10.4

