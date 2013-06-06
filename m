Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943Ab3FFFlx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 01:41:53 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:37243 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752660Ab3FFFlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 01:41:49 -0400
From: Matt Porter <matt.porter@linaro.org>
To: Christian Daudt <csd@broadcom.com>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>
Cc: Stephen Warren <swarren@nvidia.com>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linaro Patches <patches@linaro.org>
Subject: [PATCH 2/2] ARM: dts: bcm281xx: use existing defines for irqs
Date: Thu,  6 Jun 2013 01:41:35 -0400
Message-Id: <1370497295-12682-3-git-send-email-matt.porter@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1370497295-12682-1-git-send-email-matt.porter@linaro.org>
References: <1370497295-12682-1-git-send-email-matt.porter@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the standard interrupt-controller and ARM GIC constants to
improve the readability of bcm281xx DT irq properties.

Signed-off-by: Matt Porter <matt.porter@linaro.org>
---
 arch/arm/boot/dts/bcm11351.dtsi |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/bcm11351.dtsi b/arch/arm/boot/dts/bcm11351.dtsi
index c08810e..824bebe 100644
--- a/arch/arm/boot/dts/bcm11351.dtsi
+++ b/arch/arm/boot/dts/bcm11351.dtsi
@@ -11,6 +11,9 @@
  * GNU General Public License for more details.
  */
 
+#include <dt-bindings/interrupt-controller/arm-gic.h>
+#include <dt-bindings/interrupt-controller/irq.h>
+
 #include "skeleton.dtsi"
 
 / {
@@ -41,7 +44,7 @@
 		status = "disabled";
 		reg = <0x3e000000 0x1000>;
 		clock-frequency = <13000000>;
-		interrupts = <0x0 67 0x4>;
+		interrupts = <GIC_SPI 67 IRQ_TYPE_LEVEL_HIGH>;
 		reg-shift = <2>;
 		reg-io-width = <4>;
 	};
@@ -56,7 +59,7 @@
 	timer@35006000 {
 		compatible = "bcm,kona-timer";
 		reg = <0x35006000 0x1000>;
-		interrupts = <0x0 7 0x4>;
+		interrupts = <GIC_SPI 7 IRQ_TYPE_LEVEL_HIGH>;
 		clock-frequency = <32768>;
 	};
 
-- 
1.7.9.5

