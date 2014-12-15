Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751664AbaLOMAA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 07:00:00 -0500
Received: from mail-yh0-f50.google.com ([209.85.213.50]:54966 "EHLO
	mail-yh0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516AbaLOL74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 06:59:56 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        computersforpeace@gmail.com, linux-mtd@lists.infradead.org
Cc: lee.jones@linaro.org, kernel@stlinux.com
Subject: [PATCH v3 12/13] ARM: STi: stih416: Use new platform specific compatible string
Date: Mon, 15 Dec 2014 11:59:19 +0000
Message-Id: <1418644760-18773-13-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418644760-18773-1-git-send-email-lee.jones@linaro.org>
References: <1418644760-18773-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The FSM SPI NOR driver now obtains syscfg particulars using DT match. In
order for this to happen each platform is required to supply their own
specific compatible string.

We're also remove the old, now unused vendor properties from the node.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/stih416.dtsi | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/stih416.dtsi b/arch/arm/boot/dts/stih416.dtsi
index 84758d7..dec546e 100644
--- a/arch/arm/boot/dts/stih416.dtsi
+++ b/arch/arm/boot/dts/stih416.dtsi
@@ -214,13 +214,11 @@
 
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

