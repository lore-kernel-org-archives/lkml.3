Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471AbaEUOQz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 10:16:55 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:43810 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752426AbaEUOQx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 10:16:53 -0400
From: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
To: <santosh.shilimkar@ti.com>
CC: <galak@codeaurora.org>, <linux@arm.linux.org.uk>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <robh+dt@kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <grygorii.strashko@ti.com>, <m-karicheri2@ti.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
Subject: [Patch] ARM: dts: keystone: add device state control syscon entry
Date: Wed, 21 May 2014 17:16:00 +0300
Message-ID: <1400681760-24351-1-git-send-email-ivan.khoronzhuk@ti.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Device state control registers has register regions with different
purposes so add syscon entry in order to be able to correctly access
them from appropriate places.

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
---

Based on linux-next/master

 arch/arm/boot/dts/keystone.dtsi | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/boot/dts/keystone.dtsi b/arch/arm/boot/dts/keystone.dtsi
index 5e67c5b..8b899ba 100644
--- a/arch/arm/boot/dts/keystone.dtsi
+++ b/arch/arm/boot/dts/keystone.dtsi
@@ -71,6 +71,11 @@
 			reg = <0x2310000 0x200>;
 		};
 
+		devctrl: device_state_control {
+			compatible = "ti,keystone-devctrl", "syscon";
+			reg = <0x2620000 0x1000>;
+		};
+
 		rstctrl: reset-controller {
 			compatible = "ti,keystone-reset";
 			reg = <0x023100e8 4>;	/* pll reset control reg */
-- 
1.8.3.2

