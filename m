Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476Ab3IRMV6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 08:21:58 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:41504 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716Ab3IRMPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 08:15:08 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@linaro.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 19/41] ARM: ux500: Add a DT node for the Nomadik System Timer (MTU0)
Date: Wed, 18 Sep 2013 13:14:16 +0100
Message-Id: <1379506478-16625-20-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379506478-16625-1-git-send-email-lee.jones@linaro.org>
References: <1379506478-16625-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MTU0 is required for full booting of the system. The driver has
been previously DT:ed and is in use on the Nomadik platform, but we
also need to enable it on ux500 based systems.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/dbx5x0.dtsi | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm/boot/dts/dbx5x0.dtsi b/arch/arm/boot/dts/dbx5x0.dtsi
index 5c3ff94..0d2d5d0 100644
--- a/arch/arm/boot/dts/dbx5x0.dtsi
+++ b/arch/arm/boot/dts/dbx5x0.dtsi
@@ -43,6 +43,7 @@
 			interrupts = <0 7 IRQ_TYPE_LEVEL_HIGH>;
 		};
 
+
 		clocks {
 			compatible = "stericsson,u8500-clks";
 
@@ -67,6 +68,16 @@
 			};
 		};
 
+		mtu@a03c6000 {
+			/* Nomadik System Timer */
+			compatible = "st,nomadik-mtu";
+			reg = <0xa03c6000 0x1000>;
+			interrupts = <0 4 IRQ_TYPE_LEVEL_HIGH>;
+
+			clocks = <&prcmu_clk PRCMU_TIMCLK>, <&prcc_pclk 6 6>;
+			clock-names = "timclk", "apb_pclk";
+		};
+
 		timer@a0410600 {
 			compatible = "arm,cortex-a9-twd-timer";
 			reg = <0xa0410600 0x20>;
-- 
1.8.1.2

