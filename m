Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934070AbaLLUJ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 15:09:59 -0500
Received: from smtp-3.sys.kth.se ([130.237.48.192]:60852 "EHLO
	smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037AbaLLUJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 15:09:56 -0500
X-Greylist: delayed 419 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Dec 2014 15:09:55 EST
X-KTH-Auth: niso [89.233.231.155]
X-KTH-mail-from: niso@kth.se
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niso@kth.se>
To: linux-kernel@vger.kernel.org, laurent.pinchart@ideasonboard.com,
        linus.walleij@linaro.org
Cc: devicetree@vger.kernel.org, linux-sh@vger.kernel.org,
        magnus.damm@gmail.com,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niso@kth.se>
Subject: [PATCH 4/4] ARM: shmobile: emev2-kzm9d: Add PFC information for uart1
Date: Fri, 12 Dec 2014 21:01:37 +0100
Message-Id: <1418414497-23741-5-git-send-email-niso@kth.se>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418414497-23741-1-git-send-email-niso@kth.se>
References: <1418414497-23741-1-git-send-email-niso@kth.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Configure the pinmux on kzm9d to use the serial connector for uart1.

Signed-off-by: Niklas Söderlund <niso@kth.se>
---
 arch/arm/boot/dts/emev2-kzm9d.dts | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/arm/boot/dts/emev2-kzm9d.dts b/arch/arm/boot/dts/emev2-kzm9d.dts
index 667d323..daf19bf 100644
--- a/arch/arm/boot/dts/emev2-kzm9d.dts
+++ b/arch/arm/boot/dts/emev2-kzm9d.dts
@@ -94,3 +94,16 @@
 		vdd33a-supply = <&reg_3p3v>;
 	};
 };
+
+&pfc {
+	uart1_pins: uart@e1030000 {
+		renesas,groups = "uart1_rx", "uart1_tx", "uart1_ctsb", "uart1_rtsb";
+		renesas,function = "uart1";
+	};
+};
+
+&uart1 {
+	pinctrl-0 = <&uart1_pins>;
+	pinctrl-names = "default";
+	status = "okay";
+};
-- 
2.1.3

