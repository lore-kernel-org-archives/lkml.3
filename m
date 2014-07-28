Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780AbaG1O60 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 10:58:26 -0400
Received: from mail.kmu-office.ch ([178.209.48.102]:51097 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364AbaG1O55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 10:57:57 -0400
From: Stefan Agner <stefan@agner.ch>
To: peter.chen@freescale.com, s.hauer@pengutronix.de, shawn.guo@freescale.com
Cc: b35083@freescale.com, jingchang.lu@freescale.com,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, stefan@agner.ch
Subject: [PATCH v2 7/7] ARM: dts: vf610-twr: Add USB support
Date: Mon, 28 Jul 2014 16:57:33 +0200
Message-Id: <07491836b9c23a82b7a33972a5c71f2676ceaf71.1406558450.git.stefan@agner.ch>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <cover.1406558450.git.stefan@agner.ch>
References: <cover.1406558450.git.stefan@agner.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add USB support for Freescale Vybrid tower. The USB hosts over-current
protection signal is not connected is not connected to the PHY's over-
current protection, hence we need to disable it.

Signed-off-by: Stefan Agner <stefan@agner.ch>
---
 arch/arm/boot/dts/vf610-twr.dts | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/boot/dts/vf610-twr.dts b/arch/arm/boot/dts/vf610-twr.dts
index 11d7334..c709dc3 100644
--- a/arch/arm/boot/dts/vf610-twr.dts
+++ b/arch/arm/boot/dts/vf610-twr.dts
@@ -265,3 +265,13 @@
 	pinctrl-0 = <&pinctrl_uart1>;
 	status = "okay";
 };
+
+&usbdev0 {
+	disable-over-current;
+	status = "okay";
+};
+
+&usbh1 {
+	disable-over-current;
+	status = "okay";
+};
-- 
2.0.2

