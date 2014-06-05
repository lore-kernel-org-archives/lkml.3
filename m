Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842AbaFEPs7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 11:48:59 -0400
Received: from top.free-electrons.com ([176.31.233.9]:58896 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752709AbaFEPs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 11:48:56 -0400
From: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com, Peter.Chen@freescale.com, balbi@ti.com
Cc: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 9/9] ARM: dts: Berlin: enable USB on the BG2Q DMP
Date: Thu,  5 Jun 2014 17:48:46 +0200
Message-Id: <1401983326-19205-10-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401983326-19205-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1401983326-19205-1-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable the 2 available USB PHY and USB nodes on the Marvell Berlin BG2Q
DMP.

Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
---
 arch/arm/boot/dts/berlin2q-marvell-dmp.dts | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arch/arm/boot/dts/berlin2q-marvell-dmp.dts b/arch/arm/boot/dts/berlin2q-marvell-dmp.dts
index 2da9c41e29d8..4195874b9bed 100644
--- a/arch/arm/boot/dts/berlin2q-marvell-dmp.dts
+++ b/arch/arm/boot/dts/berlin2q-marvell-dmp.dts
@@ -7,6 +7,8 @@
  */
 
 /dts-v1/;
+
+#include <dt-bindings/gpio/gpio.h>
 #include "berlin2q.dtsi"
 
 / {
@@ -26,3 +28,21 @@
 &uart0 {
 	status = "okay";
 };
+
+&usb_phy0 {
+	power-gpio = <&portb 8 GPIO_ACTIVE_HIGH>;
+	status = "okay";
+};
+
+&usb_phy2 {
+	power-gpio = <&portb 12 GPIO_ACTIVE_HIGH>;
+	status = "okay";
+};
+
+&usb0 {
+	status = "okay";
+};
+
+&usb2 {
+	status = "okay";
+};
-- 
1.9.1

