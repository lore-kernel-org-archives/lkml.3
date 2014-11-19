Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933455AbaKSXUF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 18:20:05 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:35467 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756518AbaKSXQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 18:16:03 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Mike Turquette <mturquette@linaro.org>, linux-metag@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: James Hogan <james.hogan@imgtec.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: [PATCH 03/15] dt: binding: add binding for tz1090-pll clock
Date: Wed, 19 Nov 2014 23:15:31 +0000
Message-Id: <1416438943-11429-4-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1416438943-11429-1-git-send-email-james.hogan@imgtec.com>
References: <1416438943-11429-1-git-send-email-james.hogan@imgtec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add simple device tree binding for TZ1090 PLL clock. It takes a couple
of registers, and has a single reference clock source.

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
 .../devicetree/bindings/clock/img,tz1090-pll.txt   | 33 ++++++++++++++++++++++
 1 file changed, 33 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/clock/img,tz1090-pll.txt

diff --git a/Documentation/devicetree/bindings/clock/img,tz1090-pll.txt b/Documentation/devicetree/bindings/clock/img,tz1090-pll.txt
new file mode 100644
index 0000000..20aa622
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/img,tz1090-pll.txt
@@ -0,0 +1,33 @@
+Binding for TZ1090 Phase-Lock Loop (PLL) clocks.
+
+This binding uses the common clock binding[1]. These PLLs are configured with 2
+registers specified with the reg property. These contain various fields which
+among other things specify the reference divider value (r), the frequency
+divider value (f), and the output divider value (od). When enabled, the output
+clock rate is:
+
+    f_out = f_ref / r * (f / 2) / od
+
+[1] Documentation/devicetree/bindings/clock/clock-bindings.txt
+
+Required properties:
+- compatible         : Shall be "img,tz1090-pll".
+- #clock-cells       : From common clock binding; shall be set to 0.
+- reg                : Address of configuration register pair.
+- clocks             : From common clock binding.
+
+Required source clocks:
+- 0                  : Reference clock used to generate the output clock
+                       (doesn't have to be named).
+
+Optional properties:
+- clock-output-names : From common clock binding.
+
+Example:
+	sys_pll {
+		compatible = "img,tz1090-pll";
+		#clock-cells = <0>;
+		clocks = <&sysclk0_sw>;
+		reg = <0x02005950 0x8>;	/* CR_TOP_SYSPLL_CTL{0,1} */
+		clock-output-names = "sys_pll";
+	};
-- 
2.0.4

