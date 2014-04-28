Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155AbaD1OBW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 10:01:22 -0400
Received: from mail-yk0-f175.google.com ([209.85.160.175]:59959 "EHLO
	mail-yk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753667AbaD1OAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 10:00:46 -0400
From: =?UTF-8?q?Guido=20Mart=C3=ADnez?= <guido@vanguardiasur.com.ar>
To: LKML <linux-kernel@vger.kernel.org>, bcousson@baylibre.com,
        tony@atomide.com
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        =?UTF-8?q?Ezequiel=20Garc=C3=ADa?= <ezequiel@vanguardiasur.com.ar>,
        =?UTF-8?q?Guido=20Mart=C3=ADnez?= <guido@vanguardiasur.com.ar>
Subject: [PATCH 4/4] ARM: dts: am335x-igep0033: use phandles for USB and DMA refs
Date: Mon, 28 Apr 2014 10:58:32 -0300
Message-Id: <1398693512-5355-4-git-send-email-guido@vanguardiasur.com.ar>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1398693512-5355-1-git-send-email-guido@vanguardiasur.com.ar>
References: <1398693512-5355-1-git-send-email-guido@vanguardiasur.com.ar>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use phandles instead of unit adresses to reference usb and dma nodes.
This makes the DT more robust and readable.

Signed-off-by: Guido Martínez <guido@vanguardiasur.com.ar>
---
 arch/arm/boot/dts/am335x-igep0033.dtsi | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm/boot/dts/am335x-igep0033.dtsi b/arch/arm/boot/dts/am335x-igep0033.dtsi
index 9f22c18..81cf68b 100644
--- a/arch/arm/boot/dts/am335x-igep0033.dtsi
+++ b/arch/arm/boot/dts/am335x-igep0033.dtsi
@@ -201,28 +201,28 @@
 &usb {
 	status = "okay";
 
-	control@44e10620 {
+	&usb_ctrl_mod {
 		status = "okay";
 	};
 
-	usb-phy@47401300 {
+	&usb0_phy {
 		status = "okay";
 	};
 
-	usb-phy@47401b00 {
+	&usb1_phy {
 		status = "okay";
 	};
 
-	usb@47401000 {
+	&usb0 {
 		status = "okay";
 	};
 
-	usb@47401800 {
+	&usb1 {
 		status = "okay";
 		dr_mode = "host";
 	};
 
-	dma-controller@47402000  {
+	&cppi41dma  {
 		status = "okay";
 	};
 };
-- 
1.9.2

