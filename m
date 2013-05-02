Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761076Ab3EBTnk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 15:43:40 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:37035 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759293Ab3EBTnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 15:43:39 -0400
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Nobuhiro Iwamatsu <iwamatsu@nigauri.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Subject: [PATCH] ARM: kirkwood: add button for OpenBlock A6
Date: Thu,  2 May 2013 21:43:22 +0200
Message-Id: <1367523802-16372-1-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The OpenBlocks A6 board has one software-controlled button on the
front side, labeled "INIT", so we add minimal support for this button
in the kernel.

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
---
 arch/arm/boot/dts/kirkwood-openblocks_a6.dts |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/arm/boot/dts/kirkwood-openblocks_a6.dts b/arch/arm/boot/dts/kirkwood-openblocks_a6.dts
index d27f724..627d8d0 100644
--- a/arch/arm/boot/dts/kirkwood-openblocks_a6.dts
+++ b/arch/arm/boot/dts/kirkwood-openblocks_a6.dts
@@ -209,4 +209,17 @@
 			gpios = <&gpio1 11 1>;
 		};
         };
+
+	gpio_keys {
+		compatible = "gpio-keys";
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+			button@1 {
+			label = "Init Button";
+			linux,code = <116>;
+			gpios = <&gpio1 6 0>;
+		};
+	};
+
 };
-- 
1.7.9.5

