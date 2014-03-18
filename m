Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442AbaCRNX5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 09:23:57 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:36127 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754050AbaCRNXz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 09:23:55 -0400
From: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
To: <santosh.shilimkar@ti.com>
CC: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <linux@arm.linux.org.uk>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <grygorii.strashko@ti.com>, Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
Subject: [PATCH] ARM: dts: keystone: Fix control register range for clktsip
Date: Tue, 18 Mar 2014 15:23:11 +0200
Message-ID: <1395148991-22538-1-git-send-email-ivan.khoronzhuk@ti.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The control register range for clktsio interferes with clkaemifspi clock.
And it causes issues for NAND/AEMIF. So fix it.

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
---

Only comment is corrected.

 arch/arm/boot/dts/k2hk-clocks.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/k2hk-clocks.dtsi b/arch/arm/boot/dts/k2hk-clocks.dtsi
index a71aa29..8855b1f 100644
--- a/arch/arm/boot/dts/k2hk-clocks.dtsi
+++ b/arch/arm/boot/dts/k2hk-clocks.dtsi
@@ -59,7 +59,7 @@ clocks {
 		compatible = "ti,keystone,psc-clock";
 		clocks = <&chipclk16>;
 		clock-output-names = "tsip";
-		reg = <0x0235000c 0xb00>, <0x02350000 0x400>;
+		reg = <0x02350000 0xb00>, <0x02350000 0x400>;
 		reg-names = "control", "domain";
 		domain-id = <0>;
 	};
-- 
1.8.3.2

