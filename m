Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933299AbaKSXQX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 18:16:23 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:59747 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757180AbaKSXQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 18:16:15 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Mike Turquette <mturquette@linaro.org>, linux-metag@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: James Hogan <james.hogan@imgtec.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: [PATCH 09/15] dt: binding: add binding for TZ1090 clock deleter
Date: Wed, 19 Nov 2014 23:15:37 +0000
Message-Id: <1416438943-11429-10-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1416438943-11429-1-git-send-email-james.hogan@imgtec.com>
References: <1416438943-11429-1-git-send-email-james.hogan@imgtec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add DT binding for the clock deleters in the TZ1090 SoC, which delete up
to 1023 out of every 1024 clock pulses of the input clock.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Kumar Gala <galak@codeaurora.org>
Cc: linux-metag@vger.kernel.org
Cc: devicetree@vger.kernel.org
---
 .../bindings/clock/img,tz1090-deleter.txt          | 40 ++++++++++++++++++++++
 1 file changed, 40 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/clock/img,tz1090-deleter.txt

diff --git a/Documentation/devicetree/bindings/clock/img,tz1090-deleter.txt b/Documentation/devicetree/bindings/clock/img,tz1090-deleter.txt
new file mode 100644
index 0000000..0f595be
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/img,tz1090-deleter.txt
@@ -0,0 +1,40 @@
+Binding for TZ1090 clock deleter.
+
+This binding uses the common clock binding[1]. The TZ1090 clock deleters can be
+configured to delete a certain fraction of the input clock pulses, so the output
+frequency is:
+
+    deleted_cycles = (reg & bit_mask) >> bit_shift
+    f_out = f_in * (cycle_period - deleted_cycles) / cycle_period
+
+[1] Documentation/devicetree/bindings/clock/clock-bindings.txt
+
+Required properties:
+- compatible         : Shall be "img,tz1090-deleter".
+- #clock-cells       : From common clock binding; shall be set to 0.
+- reg                : Address of configuration register.
+- bit-mask           : Shift of config value field in configuration register.
+- clocks             : From common clock binding.
+
+Required source clocks:
+- 0                  : Reference clock which is deleted to produce the output
+                       clock (doesn't have to be named).
+
+Optional properties:
+- clock-output-names : From common clock binding.
+- bit-shift          : Number of bits to shift the bit-mask, defaults to
+                       (ffs(mask) - 1) if not present.
+- cycle-period       : Period from which clocks are deleted, defaults to
+                       (1 << (fls(mask) - bit-shift)) if not present.
+
+Example:
+	meta_clkdelete {
+		compatible = "img,tz1090-deleter";
+		#clock-cells = <0>;
+		clocks = <&sys_clk_x2_undeleted>;
+		reg = <0x0200591c 0x4>;
+		bit-mask = <0x000003ff>;
+		/* implicit bit-shift = <0> */
+		/* implicit cycle-period = <1024> */
+		clock-output-names = "meta";
+	};
-- 
2.0.4

