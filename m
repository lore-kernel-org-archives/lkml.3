Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751AbaG1O6X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 10:58:23 -0400
Received: from mail.kmu-office.ch ([178.209.48.102]:51088 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbaG1O55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 10:57:57 -0400
From: Stefan Agner <stefan@agner.ch>
To: peter.chen@freescale.com, s.hauer@pengutronix.de, shawn.guo@freescale.com
Cc: b35083@freescale.com, jingchang.lu@freescale.com,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, stefan@agner.ch
Subject: [PATCH v2 6/7] ARM: dts: vf610-colibri: Add USB support
Date: Mon, 28 Jul 2014 16:57:32 +0200
Message-Id: <675131705ee053a3adaaddff5ed1a379402a955f.1406558450.git.stefan@agner.ch>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <cover.1406558450.git.stefan@agner.ch>
References: <cover.1406558450.git.stefan@agner.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add USB support for Colibri VF61 modules. The Colibri standard pinout
defines a pin for USB over-current. However, due to lack of pinmux
options, the USB hosts over-current protection signal of the Colibri
standard could not be connected to the PHY's over-current protection.
Hence we need to disable the over-current functionality of the USB
controller.

Signed-off-by: Stefan Agner <stefan@agner.ch>
---
 arch/arm/boot/dts/vf610-colibri.dts | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/boot/dts/vf610-colibri.dts b/arch/arm/boot/dts/vf610-colibri.dts
index aecc7db..f2a950d 100644
--- a/arch/arm/boot/dts/vf610-colibri.dts
+++ b/arch/arm/boot/dts/vf610-colibri.dts
@@ -69,6 +69,16 @@
 	status = "okay";
 };
 
+&usbdev0 {
+	disable-over-current;
+	status = "okay";
+};
+
+&usbh1 {
+	disable-over-current;
+	status = "okay";
+};
+
 &iomuxc {
 	vf610-colibri {
 		pinctrl_esdhc1: esdhc1grp {
-- 
2.0.2

