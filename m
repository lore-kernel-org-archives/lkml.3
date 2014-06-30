Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755059AbaF3WJx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 18:09:53 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:60597 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754612AbaF3WJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 18:09:50 -0400
From: Alex Elder <elder@linaro.org>
To: mporter@linaro.org, bcm@fixthebug.org, devicetree@vger.kernel.org,
        grant.likely@linaro.org, robh+dt@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] devicetree: bindings: document Broadcom CPU enable method
Date: Mon, 30 Jun 2014 17:09:45 -0500
Message-Id: <1404166185-4168-1-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Broadcom mobile SoCs use a ROM-implemented holding pen for
controlled boot of secondary cores.  A special register is
used to communicate to the ROM that a secondary core should
start executing kernel code.  This enable method is currently
used for members of the bcm281xx and bcm21664 SoC families.

The use of an enable method also allows the SMP operation vector to
be assigned as a result of device tree content for these SoCs.

Signed-off-by: Alex Elder <elder@linaro.org>
---
Notes:
  - This patch was previously posted as part of this series:
	https://lkml.org/lkml/2014/6/16/580
  - The binding definition is now found in a separate file rather
    than embedding it in:
	Documentation/devicetree/bindings/arm/cpus.txt

 .../bindings/arm/bcm/brcm,bcm11351-cpu-method      | 36 ++++++++++++++++++++++
 1 file changed, 36 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/bcm/brcm,bcm11351-cpu-method

diff --git a/Documentation/devicetree/bindings/arm/bcm/brcm,bcm11351-cpu-method b/Documentation/devicetree/bindings/arm/bcm/brcm,bcm11351-cpu-method
new file mode 100644
index 0000000..8240c02
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/bcm/brcm,bcm11351-cpu-method
@@ -0,0 +1,36 @@
+Broadcom Kona Family CPU Enable Method
+--------------------------------------
+This binding defines the enable method used for starting secondary
+CPUs in the following Broadcom SoCs:
+  BCM11130, BCM11140, BCM11351, BCM28145, BCM28155, BCM21664
+
+The enable method is specified by defining the following required
+properties in the "cpus" device tree node:
+  - enable-method = "brcm,bcm11351-cpu-method";
+  - secondary-boot-reg = <...>;
+
+The secondary-boot-reg property is a u32 value that specifies the
+physical address of the register used to request the ROM holding pen
+code release a secondary CPU.  The value written to the register is
+formed by encoding the target CPU id into the low bits of the
+physical start address it should jump to.
+
+Example:
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		enable-method = "brcm,bcm11351-cpu-method";
+		secondary-boot-reg = <0x3500417c>;
+
+		cpu0: cpu@0 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a9";
+			reg = <0>;
+		};
+
+		cpu1: cpu@1 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a9";
+			reg = <1>;
+		};
+	};
-- 
1.9.1

