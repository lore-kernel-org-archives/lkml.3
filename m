Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933429AbaKSXTT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 18:19:19 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:35021 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932826AbaKSXQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 18:16:07 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Mike Turquette <mturquette@linaro.org>, linux-metag@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: James Hogan <james.hogan@imgtec.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: [PATCH 05/15] dt: binding: add binding for TZ1090 gate bank
Date: Wed, 19 Nov 2014 23:15:33 +0000
Message-Id: <1416438943-11429-6-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1416438943-11429-1-git-send-email-james.hogan@imgtec.com>
References: <1416438943-11429-1-git-send-email-james.hogan@imgtec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add DT binding for a bank of clock gates in the TZ1090 SoC. There are
several such registers which contain only bits controlling clock gates.

The bit-mask property determines the mask of bits of the register which
control gates. The number of input (and output) clocks is equal to the
number of set bits in the bit-mask, and the clocks and
clock-output-names arrays list the clocks/names from the least
significant set bit in the mask to the most significant set bit.

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
 .../bindings/clock/img,tz1090-gate-bank.txt        | 52 ++++++++++++++++++++++
 1 file changed, 52 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/clock/img,tz1090-gate-bank.txt

diff --git a/Documentation/devicetree/bindings/clock/img,tz1090-gate-bank.txt b/Documentation/devicetree/bindings/clock/img,tz1090-gate-bank.txt
new file mode 100644
index 0000000..7a93f6a
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/img,tz1090-gate-bank.txt
@@ -0,0 +1,52 @@
+Binding for TZ1090 clock gate bank.
+
+This binding uses the common clock binding[1]. It assumes a register-mapped bank
+of clock gates, where each bit in the register can control a single gate. The
+number of clocks in the bank is specified indirectly by the number of set bits
+in the bit-mask property.
+
+
+[1] Documentation/devicetree/bindings/clock/clock-bindings.txt
+
+Required properties:
+- compatible         : shall be "img,tz1090-gate-bank".
+- #clock-cells       : from common clock binding; shall be set to 1.
+- reg                : base address for register controlling gates
+- bit-mask           : bitmask of bits in register controlling gates
+- clocks             : clock specifiers of parent clock of each gate with bit
+                       set in bit-mask
+- clock-output-names : from common clock binding. Name of each gate with bit set
+                       in bit-mask
+
+Clock Specifier Definition:
+- <1st-cell>: gate number, counting from 0 (the gate controlled by the lowest
+              set bit in bit-mask) to the number of gates - 1 (i.e.  omitting
+              any clear bits in bit-mask)
+
+Examples:
+	clkenab {
+		compatible = "img,tz1090-gate-bank";
+		#clock-cells = <1>;
+		reg = <0x0200590c 0x4>;
+		bit-mask = <0x020b7220>;
+		clock-output-names =
+			"out0_en",
+			"out1_en",
+			"i2s_en",
+			"scb_en",
+			"uart_en",
+			"ext_stc1_en",
+			"ext_stc1_en",
+			"usb_en",
+			"adcpll_en";
+		clocks =
+			<&clkswitch 5>,
+			<&clkswitch 9>,
+			<&clkswitch 12>,
+			<&clkswitch 13>,
+			<&clkswitch 14>,
+			<&clkswitch 15>,
+			<&clkswitch 16>,
+			<&clkswitch 18>,
+			<&clkswitch 24>;
+	};
-- 
2.0.4

