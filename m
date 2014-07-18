Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030575AbaGRRCh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 13:02:37 -0400
Received: from mail.kmu-office.ch ([178.209.48.102]:38446 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030454AbaGRRCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 13:02:14 -0400
From: Stefan Agner <stefan@agner.ch>
To: peter.chen@freescale.com, s.hauer@pengutronix.de, shawn.guo@freescale.com
Cc: b35083@freescale.com, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stefan@agner.ch
Subject: [PATCH 6/6] ARM: dts: vf610-colibri: add USB support
Date: Fri, 18 Jul 2014 19:01:42 +0200
Message-Id: <438da287f96dfcfd1dbdc4c1255d18d125529850.1405702442.git.stefan@agner.ch>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <cover.1405702442.git.stefan@agner.ch>
References: <cover.1405702442.git.stefan@agner.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add USB support for Colibri VF61 modules. Due to lack of pinmux
options, the USB hosts over-current protection signal of the Colibri
standard could not be connected to the PHY's over-current protection,
hence we need to disable it.

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
2.0.1

