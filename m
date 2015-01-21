Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754465AbbAUP0d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 10:26:33 -0500
Received: from mail-ig0-f175.google.com ([209.85.213.175]:52579 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754120AbbAUPZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 10:25:04 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, linux-mtd@lists.infradead.org,
        computersforpeace@gmail.com, devicetree@vger.kernel.org
Subject: [PATCH v4 09/10] ARM: STi: stih416: Use new platform specific compatible string
Date: Wed, 21 Jan 2015 15:24:27 +0000
Message-Id: <1421853868-8262-10-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421853868-8262-1-git-send-email-lee.jones@linaro.org>
References: <1421853868-8262-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The FSM SPI NOR driver now obtains syscfg particulars using DT match. In
order for this to happen each platform is required to supply their own
specific compatible string.

We're also remove the old, now unused vendor properties from the node.

Cc: devicetree@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/stih416.dtsi | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/stih416.dtsi b/arch/arm/boot/dts/stih416.dtsi
index fad9073..2e35bab7 100644
--- a/arch/arm/boot/dts/stih416.dtsi
+++ b/arch/arm/boot/dts/stih416.dtsi
@@ -216,13 +216,11 @@
 
 		/* FSM */
 		spifsm: spifsm@fe902000 {
-			compatible	   = "st,spi-fsm";
+			compatible	   = "st,stih416-spi-fsm";
 			reg		   = <0xfe902000 0x1000>;
 			pinctrl-0	   = <&pinctrl_fsm>;
 
 			st,syscfg	   = <&syscfg_rear>;
-			st,boot-device-reg = <0x958>;
-			st,boot-device-spi = <0x1a>;
 
 			status = "disabled";
 		};
-- 
1.9.1

