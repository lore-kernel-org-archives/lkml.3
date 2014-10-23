Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755709AbaJWPUA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 11:20:00 -0400
Received: from mail-yh0-f43.google.com ([209.85.213.43]:64258 "EHLO
	mail-yh0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754407AbaJWPTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 11:19:11 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        wim@iguana.be, linux-watchdog@vger.kernel.org, linux@roeck-us.net
Cc: lee.jones@linaro.org, kernel@stlinux.com, devicetree@vger.kernel.org,
        David Paris <david.paris@st.com>
Subject: [PATCH 3/4] watchdog: st_wdt: Provide binding documentation for ST's LPC Watchdog driver
Date: Thu, 23 Oct 2014 16:18:43 +0100
Message-Id: <1414077524-6469-4-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414077524-6469-1-git-send-email-lee.jones@linaro.org>
References: <1414077524-6469-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: devicetree@vger.kernel.org
Signed-off-by: David Paris <david.paris@st.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 .../devicetree/bindings/watchdog/st-lpc-wdt.txt    | 31 ++++++++++++++++++++++
 1 file changed, 31 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/watchdog/st-lpc-wdt.txt

diff --git a/Documentation/devicetree/bindings/watchdog/st-lpc-wdt.txt b/Documentation/devicetree/bindings/watchdog/st-lpc-wdt.txt
new file mode 100644
index 0000000..2d0328b
--- /dev/null
+++ b/Documentation/devicetree/bindings/watchdog/st-lpc-wdt.txt
@@ -0,0 +1,31 @@
+STMicroelectronics LPC Watchdog
+===============================
+
+Required properties
+
+- compatible 	: Must be one of:
+			"st,stih407-watchdog"
+			"st,stih416-watchdog"
+			"st,stih415-watchdog"
+			"st,stid127-watchdog"
+- reg		: LPC registers base address + size
+- reg-names	: Register map "base" and "syscfg-en" are compulsory.
+		  "syscfg-type" is platform dependent and not required for the
+		  STiH407
+- clock-names 	: Should be "lpc_wdt"
+- clocks	: Clock used by LPC device
+- timeout-sec	: Watchdog timeout in seconds
+- st,syscfg	: Syscfg node used to configure CPU reset type and mask
+- st,warm_reset	: If present, reset type will be 'warm'. If not, it will be cold
+
+Example:
+	watchdog@fde05000 {
+		compatible	= "st,stih416-lpc-watchdog";
+		reg		= <0xfde05000 0x1000> <0x204 0x4>;
+		reg-names	= "base", "syscfg-en"
+		clock-names	= "lpc_wdt";
+		clocks 		= <&clk_s_d3_flexgen CLK_LPC_0>;
+		timeout-sec	= <600>;
+		st,syscfg	= <&syscfg_core>;
+		st,warm_reset;
+	};
-- 
1.9.1

