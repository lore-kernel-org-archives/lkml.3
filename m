Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752902Ab3KCJfJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 04:35:09 -0500
Received: from top.free-electrons.com ([176.31.233.9]:59055 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752189Ab3KCJfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 04:35:06 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>
Cc: kevin.z.m.zh@gmail.com, sunny@allwinnertech.com, shuge@allwinnertech.com,
        zhuzhenhua@allwinnertech.com, linux-sunxi@googlegroups.com,
        linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 1/2] ARM: sun6i: dt: Add IP needed to bring up the additional cores
Date: Sun,  3 Nov 2013 10:30:12 +0100
Message-Id: <1383471013-21695-2-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1383471013-21695-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1383471013-21695-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the PRCM and CPU configuration units needed for SMP in the A31 DTSI.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/boot/dts/sun6i-a31.dtsi | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/boot/dts/sun6i-a31.dtsi b/arch/arm/boot/dts/sun6i-a31.dtsi
index c1751a64889a..a0646877f5f2 100644
--- a/arch/arm/boot/dts/sun6i-a31.dtsi
+++ b/arch/arm/boot/dts/sun6i-a31.dtsi
@@ -295,5 +295,15 @@
 			#interrupt-cells = <3>;
 			interrupts = <1 9 0xf04>;
 		};
+
+		cpucfg@01f01c00 {
+			compatible = "allwinner,sun6i-a31-cpuconfig";
+			reg = <0x01f01c00 0x300>;
+		};
+
+		prcm@01f01c00 {
+			compatible = "allwinner,sun6i-a31-prcm";
+			reg = <0x01f01400 0x200>;
+		};
 	};
 };
-- 
1.8.4

