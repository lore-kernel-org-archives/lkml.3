Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755724AbbAWPpK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 10:45:10 -0500
Received: from down.free-electrons.com ([37.187.137.238]:51430 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755492AbbAWPpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 10:45:05 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Gregory Clement <gregory.clement@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Brian Norris <computersforpeace@gmail.com>
Cc: linux-mtd@lists.infradead.org, Boris Brezillon <boris@free-electrons.com>,
        Thomas Petazzoni <thomas@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Lior Amsalem <alior@marvell.com>, linux-kernel@vger.kernel.org,
        Sudhakar Gundubogula <sudhakar@marvell.com>,
        Seif Mazareeb <seif@marvell.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 2/2] ARM: mvebu: a385-db-ap: Enable the NAND
Date: Fri, 23 Jan 2015 16:41:43 +0100
Message-Id: <1422027703-3763-3-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1422027703-3763-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1422027703-3763-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Armada 385 Access Point Development Board has a 1GB NAND SLC chip from
Micron as its main storage. Enable it.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/boot/dts/armada-385-db-ap.dts | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/arm/boot/dts/armada-385-db-ap.dts b/arch/arm/boot/dts/armada-385-db-ap.dts
index b891b4c897f5..ee648fb19075 100644
--- a/arch/arm/boot/dts/armada-385-db-ap.dts
+++ b/arch/arm/boot/dts/armada-385-db-ap.dts
@@ -130,6 +130,19 @@
 				phy-mode = "rgmii-id";
 			};
 
+			nfc: flash@d0000 {
+				status = "okay";
+				#address-cells = <1>;
+				#size-cells = <1>;
+
+				num-cs = <1>;
+				nand-ecc-strength = <4>;
+				nand-ecc-step-size = <512>;
+				marvell,nand-keep-config;
+				marvell,nand-enable-arbiter;
+				nand-on-flash-bbt;
+			};
+
 			usb3@f0000 {
 				status = "okay";
 				usb-phy = <&usb3_phy>;
-- 
2.2.2

