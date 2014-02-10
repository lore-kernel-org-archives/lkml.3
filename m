Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475AbaBJU1k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 15:27:40 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:55829 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754051AbaBJU13 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 15:27:29 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
To: <mturquette@linaro.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <ivan.khoronzhuk@ti.com>, Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: [PATCH 2/2] ARM: keystone: dts: fix clkvcp3 control register address
Date: Mon, 10 Feb 2014 15:26:51 -0500
Message-ID: <1392064011-11986-3-git-send-email-santosh.shilimkar@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392064011-11986-1-git-send-email-santosh.shilimkar@ti.com>
References: <1392064011-11986-1-git-send-email-santosh.shilimkar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>

The address for control regs in clkvcp3 node is not correct and should
be 0x023500a8 instead of 0x0235000a8.

This lead to few unexpected behaviors while clocks were turned
of in absence of clk_ignore_unused

Mike Turquette <mturquette@linaro.org>
Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 arch/arm/boot/dts/keystone-clocks.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/keystone-clocks.dtsi b/arch/arm/boot/dts/keystone-clocks.dtsi
index 2363593..ef58d1c 100644
--- a/arch/arm/boot/dts/keystone-clocks.dtsi
+++ b/arch/arm/boot/dts/keystone-clocks.dtsi
@@ -612,7 +612,7 @@ clocks {
 		compatible = "ti,keystone,psc-clock";
 		clocks = <&chipclk13>;
 		clock-output-names = "vcp-3";
-		reg = <0x0235000a8 0xb00>, <0x02350060 0x400>;
+		reg = <0x023500a8 0xb00>, <0x02350060 0x400>;
 		reg-names = "control", "domain";
 		domain-id = <24>;
 	};
-- 
1.7.9.5

