Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200AbaJCP4L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 11:56:11 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:47748 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754114AbaJCP4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 11:56:00 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        Antoine Tenart <antoine.tenart@free-electrons.com>,
        linux-mmc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 09/12] mmc: sdhci-pxav3: Document clocks and additional clock-names property
Date: Fri,  3 Oct 2014 17:55:44 +0200
Message-Id: <1412351747-4188-10-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1412351747-4188-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1412351747-4188-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that sdhci-pxav3 driver allows to have more than one IP clock defined,
document both clocks and clock-names properties.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Chris Ball <chris@printf.net>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>
Cc: linux-mmc@vger.kernel.org
Cc: devicetree@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 Documentation/devicetree/bindings/mmc/sdhci-pxa.txt | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/devicetree/bindings/mmc/sdhci-pxa.txt b/Documentation/devicetree/bindings/mmc/sdhci-pxa.txt
index 86223c3eda90..4dd6deb90719 100644
--- a/Documentation/devicetree/bindings/mmc/sdhci-pxa.txt
+++ b/Documentation/devicetree/bindings/mmc/sdhci-pxa.txt
@@ -12,6 +12,10 @@ Required properties:
   * for "marvell,armada-380-sdhci", two register areas. The first one
     for the SDHCI registers themselves, and the second one for the
     AXI/Mbus bridge registers of the SDHCI unit.
+- clocks: Array of clocks required for SDHCI; requires at least one for
+    I/O clock.
+- clock-names: Array of names corresponding to clocks property; shall be
+    "io" for I/O clock and "core" for optional core clock.
 
 Optional properties:
 - mrvl,clk-delay-cycles: Specify a number of cycles to delay for tuning.
@@ -23,6 +27,8 @@ sdhci@d4280800 {
 	reg = <0xd4280800 0x800>;
 	bus-width = <8>;
 	interrupts = <27>;
+	clocks = <&chip CLKID_SDIO1XIN>, <&chip CLKID_SDIO1>;
+	clock-names = "io", "core";
 	non-removable;
 	mrvl,clk-delay-cycles = <31>;
 };
@@ -32,5 +38,6 @@ sdhci@d8000 {
 	reg = <0xd8000 0x1000>, <0xdc000 0x100>;
 	interrupts = <0 25 0x4>;
 	clocks = <&gateclk 17>;
+	clock-names = "io";
 	mrvl,clk-delay-cycles = <0x1F>;
 };
-- 
2.1.1

