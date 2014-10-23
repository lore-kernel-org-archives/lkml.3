Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609AbaJWPTM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 11:19:12 -0400
Received: from mail-yh0-f44.google.com ([209.85.213.44]:48131 "EHLO
	mail-yh0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753019AbaJWPTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 11:19:06 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        wim@iguana.be, linux-watchdog@vger.kernel.org, linux@roeck-us.net
Cc: lee.jones@linaro.org, kernel@stlinux.com, David Paris <david.paris@st.com>
Subject: [PATCH 1/4] ARM: STi: DT: STiH407: Add Device Tree node for LPC Watchdog
Date: Thu, 23 Oct 2014 16:18:41 +0100
Message-Id: <1414077524-6469-2-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414077524-6469-1-git-send-email-lee.jones@linaro.org>
References: <1414077524-6469-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Paris <david.paris@st.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/stih407.dtsi | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/boot/dts/stih407.dtsi b/arch/arm/boot/dts/stih407.dtsi
index f539627a..303df6c 100644
--- a/arch/arm/boot/dts/stih407.dtsi
+++ b/arch/arm/boot/dts/stih407.dtsi
@@ -259,5 +259,15 @@
 
 			status = "disabled";
 		};
+
+		watchdog@0x8787000 {
+			compatible = "st,stih407-watchdog";
+			reg = <0x8787000 0x1000>, <0x204 0x4>;
+			reg-names = "base", "syscfg-en";
+			clock-names = "st_wdog";
+			clocks = <&clk_s_d3_flexgen CLK_LPC_0>;
+			timeout-sec = <600>;
+			st,syscfg = <&syscfg_core>;
+		};
 	};
 };
-- 
1.9.1

