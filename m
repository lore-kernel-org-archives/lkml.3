Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060Ab3JWNLg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 09:11:36 -0400
Received: from mail-vc0-f202.google.com ([209.85.220.202]:58284 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753932Ab3JWNLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 09:11:35 -0400
From: Doug Anderson <dianders@chromium.org>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Olof Johansson <olof@lixom.net>, marc.zyngier@arm.com,
        Doug Anderson <dianders@chromium.org>,
        Russell King <linux@arm.linux.org.uk>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: dts: Add max77686 RTC interrupt to cros5250-common
Date: Wed, 23 Oct 2013 06:11:01 -0700
Message-Id: <1382533861-12688-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without the interrupt you'll get problems if you enable
CONFIG_RTC_DRV_MAX77686.  Setup the interrupt properly in the device
tree.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
 arch/arm/boot/dts/cros5250-common.dtsi | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm/boot/dts/cros5250-common.dtsi b/arch/arm/boot/dts/cros5250-common.dtsi
index dc259e8b..9b186ac 100644
--- a/arch/arm/boot/dts/cros5250-common.dtsi
+++ b/arch/arm/boot/dts/cros5250-common.dtsi
@@ -27,6 +27,13 @@
 		i2c2_bus: i2c2-bus {
 			samsung,pin-pud = <0>;
 		};
+
+		max77686_irq: max77686-irq {
+			samsung,pins = "gpx3-2";
+			samsung,pin-function = <0>;
+			samsung,pin-pud = <0>;
+			samsung,pin-drv = <0>;
+		};
 	};
 
 	i2c@12C60000 {
@@ -35,6 +42,11 @@
 
 		max77686@09 {
 			compatible = "maxim,max77686";
+			interrupt-parent = <&gpx3>;
+			interrupts = <2 0>;
+			pinctrl-names = "default";
+			pinctrl-0 = <&max77686_irq>;
+			wakeup-source;
 			reg = <0x09>;
 
 			voltage-regulators {
-- 
1.8.4

