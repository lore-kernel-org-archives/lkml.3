Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241AbbAVL5G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 06:57:06 -0500
Received: from mail-ig0-f175.google.com ([209.85.213.175]:58978 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbbAVL47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 06:56:59 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, rtc-linux@googlegroups.com,
        wim@iguana.be, linux-watchdog@vger.kernel.org,
        devicetree@vger.kernel.org, linux@roeck-us.net, david.paris@st.com
Subject: [PATCH v2 5/9] watchdog: bindings: Provide ST bindings for ST's LPC Watchdog device
Date: Thu, 22 Jan 2015 11:56:03 +0000
Message-Id: <1421927767-28889-6-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421927767-28889-1-git-send-email-lee.jones@linaro.org>
References: <1421927767-28889-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On current ST platforms the LPC controls a number of functions including
Watchdog and Real Time Clock.  This patch provides the bindings used to
configure LPC in Watchdog mode.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 .../devicetree/bindings/watchdog/st_lpc_wdt.txt    | 38 ++++++++++++++++++++++
 1 file changed, 38 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/watchdog/st_lpc_wdt.txt

diff --git a/Documentation/devicetree/bindings/watchdog/st_lpc_wdt.txt b/Documentation/devicetree/bindings/watchdog/st_lpc_wdt.txt
new file mode 100644
index 0000000..1bdf023
--- /dev/null
+++ b/Documentation/devicetree/bindings/watchdog/st_lpc_wdt.txt
@@ -0,0 +1,38 @@
+STMicroelectronics Low Power Controller (LPC) - Watchdog
+========================================================
+
+LPC currently supports Watchdog OR Real Time Clock functionality.
+
+[See: ../rtc/rtc-st-lpc.txt for RTC options]
+
+Required properties
+
+- compatible 	: Must be one of: "st,stih407-lpc" "st,stih416-lpc"
+				  "st,stih415-lpc" "st,stid127-lpc"
+- reg		: LPC registers base address + size
+- interrupts    : LPC interrupt line number and associated flags
+- clocks	: Clock used by LPC device (See: ../clock/clock-bindings.txt)
+- st,lpc-mode	: The LPC can run either one of two modes ST_LPC_MODE_RTC [0] or
+		  ST_LPC_MODE_WDT [1].  One (and only one) mode must be
+		  selected.
+
+Required properties [watchdog mode]
+
+- st,syscfg	: Phandle to syscfg node used to enable watchdog and configure
+		  CPU reset type.
+- timeout-sec	: Watchdog timeout in seconds
+
+Optional properties [watchdog mode]
+
+- st,warm-reset	: If present reset type will be 'warm' - if not it will be cold
+
+Example:
+	lpc@fde05000 {
+		compatible	= "st,stih416-lpc-watchdog";
+		reg		= <0xfde05000 0x1000>;
+		clocks 		= <&clk_s_d3_flexgen CLK_LPC_0>;
+		st,syscfg	= <&syscfg_core>;
+		timeout-sec	= <120>;
+		st,lpc-mode	= <ST_LPC_MODE_WDT>;
+		st,warm-reset;
+	};
-- 
1.9.1

