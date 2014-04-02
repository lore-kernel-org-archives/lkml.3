Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933090AbaDBT3l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 15:29:41 -0400
Received: from mail-ig0-f180.google.com ([209.85.213.180]:58621 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933072AbaDBT3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 15:29:39 -0400
From: Alex Elder <elder@linaro.org>
To: mturquette@linaro.org, bcm@fixthebug.org, mporter@linaro.org,
        devicetree@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH RESEND 3/5] ARM: dts: define clock binding for bcm21664
Date: Wed,  2 Apr 2014 14:29:59 -0500
Message-Id: <1396467001-3551-4-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1396467001-3551-1-git-send-email-elder@linaro.org>
References: <1396467001-3551-1-git-send-email-elder@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document the device tree binding for Broadcom BCM28164 clock control
units and clocks.  This SoC uses Kona CCUs, similar to the BCM281XX
SoC family.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 .../devicetree/bindings/clock/bcm-kona-clock.txt   |   39 ++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/Documentation/devicetree/bindings/clock/bcm-kona-clock.txt b/Documentation/devicetree/bindings/clock/bcm-kona-clock.txt
index ebe3ab6..5286e26 100644
--- a/Documentation/devicetree/bindings/clock/bcm-kona-clock.txt
+++ b/Documentation/devicetree/bindings/clock/bcm-kona-clock.txt
@@ -98,3 +98,42 @@ be used.  These specifiers are defined in:
     slave   bsc2            peri      7     BCM281XX_SLAVE_CCU_BSC2
     slave   bsc3            peri      8     BCM281XX_SLAVE_CCU_BSC3
     slave   pwm             peri      9     BCM281XX_SLAVE_CCU_PWM
+
+
+BCM21664 family
+---------------
+CCU compatible string values for SoCs in the BCM21664 family are:
+    "brcm,bcm21664-root-ccu"
+    "brcm,bcm21664-aon-ccu"
+    "brcm,bcm21664-master-ccu"
+    "brcm,bcm21664-slave-ccu"
+
+The following table defines the set of CCUs and clock specifiers for
+BCM21664 family clocks.  When a clock consumer references a clocks,
+its symbolic specifier (rather than its numeric index value) should
+be used.  These specifiers are defined in:
+    "include/dt-bindings/clock/bcm21664.h"
+
+    CCU     Clock           Type    Index   Specifier
+    ---     -----           ----    -----   ---------
+    root    frac_1m         peri      0     BCM21664_ROOT_CCU_FRAC_1M
+
+    aon     hub_timer       peri      0     BCM21664_AON_CCU_HUB_TIMER
+
+    master  sdio1           peri      0     BCM21664_MASTER_CCU_SDIO1
+    master  sdio2           peri      1     BCM21664_MASTER_CCU_SDIO2
+    master  sdio3           peri      2     BCM21664_MASTER_CCU_SDIO3
+    master  sdio4           peri      3     BCM21664_MASTER_CCU_SDIO4
+    master  sdio1_sleep     peri      4     BCM21664_MASTER_CCU_SDIO1_SLEEP
+    master  sdio2_sleep     peri      5     BCM21664_MASTER_CCU_SDIO2_SLEEP
+    master  sdio3_sleep     peri      6     BCM21664_MASTER_CCU_SDIO3_SLEEP
+    master  sdio4_sleep     peri      7     BCM21664_MASTER_CCU_SDIO4_SLEEP
+
+    slave   uartb           peri      0     BCM21664_SLAVE_CCU_UARTB
+    slave   uartb2          peri      1     BCM21664_SLAVE_CCU_UARTB2
+    slave   uartb3          peri      2     BCM21664_SLAVE_CCU_UARTB3
+    slave   uartb4          peri      3     BCM21664_SLAVE_CCU_UARTB4
+    slave   bsc1            peri      4     BCM21664_SLAVE_CCU_BSC1
+    slave   bsc2            peri      5     BCM21664_SLAVE_CCU_BSC2
+    slave   bsc3            peri      6     BCM21664_SLAVE_CCU_BSC3
+    slave   bsc4            peri      7     BCM21664_SLAVE_CCU_BSC4
-- 
1.7.9.5

