Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528AbaEUOSf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 10:18:35 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:32980 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751561AbaEUOSe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 10:18:34 -0400
From: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
To: <santosh.shilimkar@ti.com>
CC: <galak@codeaurora.org>, <linux@arm.linux.org.uk>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <robh+dt@kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <grygorii.strashko@ti.com>, <m-karicheri2@ti.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
Subject: [Patch] ARM: dts: keystone: add pll controller syscon entry
Date: Wed, 21 May 2014 17:17:55 +0300
Message-ID: <1400681875-24432-1-git-send-email-ivan.khoronzhuk@ti.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pll controller register set includes sets of registers with
different purposes, so it's logically to add syscon entry to be able
to access them from appropriate places.

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
---

Based on linux-next/master

 arch/arm/boot/dts/keystone.dtsi | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/boot/dts/keystone.dtsi b/arch/arm/boot/dts/keystone.dtsi
index d9f99e7..5e67c5b 100644
--- a/arch/arm/boot/dts/keystone.dtsi
+++ b/arch/arm/boot/dts/keystone.dtsi
@@ -66,6 +66,11 @@
 		ranges = <0x0 0x0 0x0 0xc0000000>;
 		dma-ranges = <0x80000000 0x8 0x00000000 0x80000000>;
 
+		pllctrl: pll_controller {
+			compatible = "ti,keystone-pllctrl", "syscon";
+			reg = <0x2310000 0x200>;
+		};
+
 		rstctrl: reset-controller {
 			compatible = "ti,keystone-reset";
 			reg = <0x023100e8 4>;	/* pll reset control reg */
-- 
1.8.3.2

