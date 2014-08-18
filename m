Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752374AbaHRUH5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 16:07:57 -0400
Received: from mail.kmu-office.ch ([178.209.48.102]:60855 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263AbaHRUHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 16:07:31 -0400
From: Stefan Agner <stefan@agner.ch>
To: peter.chen@freescale.com, s.hauer@pengutronix.de, kernel@pengutronix.de,
        shawn.guo@freescale.com, balbi@ti.com, gregkh@linuxfoundation.org
Cc: jingchang.lu@freescale.com, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stefan@agner.ch
Subject: [PATCH RESEND v2 6/7] ARM: dts: vf610-colibri: Add USB support
Date: Mon, 18 Aug 2014 22:07:16 +0200
Message-Id: <675131705ee053a3adaaddff5ed1a379402a955f.1408391385.git.stefan@agner.ch>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <cover.1408391385.git.stefan@agner.ch>
References: <cover.1408391385.git.stefan@agner.ch>
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
2.0.4

