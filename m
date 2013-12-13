Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527Ab3LMWDg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:03:36 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:60454 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609Ab3LMWDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:03:33 -0500
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        linux-doc@vger.kernel.org
Subject: [PATCH] devicetree: macb: Document clock properties
Date: Fri, 13 Dec 2013 14:03:25 -0800
Message-Id: <1386972205-32733-1-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.8.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The macb driver uses the clock bindings. Document the required
properties, especially the driver specific clock-names.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
 Documentation/devicetree/bindings/net/macb.txt | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/macb.txt b/Documentation/devicetree/bindings/net/macb.txt
index 4ff65047bb9a..70af2ec12b09 100644
--- a/Documentation/devicetree/bindings/net/macb.txt
+++ b/Documentation/devicetree/bindings/net/macb.txt
@@ -10,6 +10,10 @@ Required properties:
 - interrupts: Should contain macb interrupt
 - phy-mode: String, operation mode of the PHY interface.
   Supported values are: "mii", "rmii", "gmii", "rgmii".
+- clock-names: Tuple listing input clock names.
+	Required elements: 'pclk', 'hclk'
+	Optional elements: 'tx_clk'
+- clocks: Phandles to input clocks.
 
 Optional properties:
 - local-mac-address: 6 bytes, mac address
@@ -22,4 +26,6 @@ Examples:
 		interrupts = <21>;
 		phy-mode = "rmii";
 		local-mac-address = [3a 0e 03 04 05 06];
+		clock-names = "pclk", "hclk", "tx_clk";
+		clocks = <&clkc 30>, <&clkc 30>, <&clkc 13>;
 	};
-- 
1.8.5.1

