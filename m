Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183AbaJTM5B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 08:57:01 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:51046 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751690AbaJTM4j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 08:56:39 -0400
From: Grygorii Strashko <grygorii.strashko@ti.com>
To: <ssantosh@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        <khilman@linaro.org>
CC: Geert Uytterhoeven <geert+renesas@glider.be>, <linux-pm@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, <grant.likely@secretlab.ca>,
        <ulf.hansson@linaro.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH v2 3/3] ARM: dts: keystone: add generic pd controller node
Date: Mon, 20 Oct 2014 15:56:04 +0300
Message-ID: <1413809764-21995-4-git-send-email-grygorii.strashko@ti.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413809764-21995-1-git-send-email-grygorii.strashko@ti.com>
References: <1413809764-21995-1-git-send-email-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add TI Keystone 2 Generic Power Domain Controller node and attach
the Davinci MDIO device to it.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 arch/arm/boot/dts/keystone.dtsi | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm/boot/dts/keystone.dtsi b/arch/arm/boot/dts/keystone.dtsi
index 5d3e83f..c669d0d 100644
--- a/arch/arm/boot/dts/keystone.dtsi
+++ b/arch/arm/boot/dts/keystone.dtsi
@@ -85,6 +85,11 @@
 
 		/include/ "keystone-clocks.dtsi"
 
+		pm_controller: pm-controller {
+			compatible = "ti,keystone-powerdomain";
+			#power-domain-cells = <0>;
+		};
+
 		uart0: serial@02530c00 {
 			compatible = "ns16550a";
 			current-speed = <115200>;
@@ -275,6 +280,7 @@
 			status = "disabled";
 			clocks = <&clkpa>;
 			clock-names = "fck";
+			power-domains = <&pm_controller>;
 			bus_freq	= <2500000>;
 		};
 
-- 
1.9.1

