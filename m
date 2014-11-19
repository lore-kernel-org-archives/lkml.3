Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933350AbaKSXQd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 18:16:33 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:47965 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933271AbaKSXQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 18:16:23 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Mike Turquette <mturquette@linaro.org>, linux-metag@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: James Hogan <james.hogan@imgtec.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: [PATCH 13/15] dt: binding: add binding for TZ1090 divider clock
Date: Wed, 19 Nov 2014 23:15:41 +0000
Message-Id: <1416438943-11429-14-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1416438943-11429-1-git-send-email-james.hogan@imgtec.com>
References: <1416438943-11429-1-git-send-email-james.hogan@imgtec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add binding for TZ1090 divider clock. This supports a subset of the
functionality of the generic divider, and by being specific to the
TZ1090 SoC it allows policy decisions to be made from the driver.

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
 .../bindings/clock/img,tz1090-divider.txt          | 37 ++++++++++++++++++++++
 1 file changed, 37 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/clock/img,tz1090-divider.txt

diff --git a/Documentation/devicetree/bindings/clock/img,tz1090-divider.txt b/Documentation/devicetree/bindings/clock/img,tz1090-divider.txt
new file mode 100644
index 0000000..25f9b9a
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/img,tz1090-divider.txt
@@ -0,0 +1,37 @@
+Binding for TZ1090 simple divider clock.
+
+This binding uses the common clock binding[1]. It assumes a register-mapped
+adjustable clock rate divider that does not gate and has only one input clock or
+parent. The value programmed into the register is one less than the actual
+divisor value. E.g:
+
+register value		actual divisor value
+0			1
+1			2
+2			3
+
+The binding must also provide the register to control the divider and the mask
+for the corresponding control bits. The shift is calculated from the mask as
+(ffs(mask) - 1)
+
+[1] Documentation/devicetree/bindings/clock/clock-bindings.txt
+
+Required properties:
+- compatible : shall be "divider-clock".
+- #clock-cells : from common clock binding; shall be set to 0.
+- clocks : link to phandle of parent clock
+- reg : base address for register controlling adjustable divider
+- bit-mask : arbitrary bitmask for programming the adjustable divider
+
+Optional properties:
+- clock-output-names : from common clock binding.
+
+Examples:
+	sys_clk_div: sys_clk_div {
+		compatible = "img,tz1090-divider";
+		#clock-cells = <0>;
+		clocks = <&sys_pll>;
+		reg = <0x02005914 0x4>;	/* CR_TOP_SYSCLK_DIV */
+		bit-mask = <0xff>;	/* CR_TOP_SYSDIV */
+		clock-output-names = "sys_div";
+	};
-- 
2.0.4

