Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011AbaFXWor (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 18:44:47 -0400
Received: from top.free-electrons.com ([176.31.233.9]:59393 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752833AbaFXWoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 18:44:44 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH 1/2] ARM: at91/dt: describe rgmii ethernet phy connected to sama5d3xek boards
Date: Wed, 25 Jun 2014 00:44:37 +0200
Message-Id: <1403649878-28242-2-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1403649878-28242-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1403649878-28242-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add ethernet-phy node to specify phy address (on the MDIO bus) and phy
interrupt (connected to pin PB25).

Define board specific delays to apply to RGMII signals.

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
---
 arch/arm/boot/dts/sama5d3xcm.dtsi | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/arm/boot/dts/sama5d3xcm.dtsi b/arch/arm/boot/dts/sama5d3xcm.dtsi
index b0b1331..2185ad8 100644
--- a/arch/arm/boot/dts/sama5d3xcm.dtsi
+++ b/arch/arm/boot/dts/sama5d3xcm.dtsi
@@ -34,6 +34,22 @@
 
 			macb0: ethernet@f0028000 {
 				phy-mode = "rgmii";
+				#address-cells = <1>;
+				#size-cells = <0>;
+
+				ethernet-phy@1 {
+					interrupt-parent = <&pioB>;
+					interrupts = <25 IRQ_TYPE_EDGE_FALLING>;
+					reg = <1>;
+					txen-skew-ps = <800>;
+					txc-skew-ps = <12000>;
+					rxdv-skew-ps = <400>;
+					rxc-skew-ps = <12000>;
+					rxd0-skew-ps = <400>;
+					rxd1-skew-ps = <400>;
+					rxd2-skew-ps = <400>;
+					rxd3-skew-ps = <400>;
+				};
 			};
 
 			pmc: pmc@fffffc00 {
-- 
1.8.3.2

