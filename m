Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932611AbaBDTxG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 14:53:06 -0500
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:16231 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932198AbaBDTwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 14:52:50 -0500
X-IronPort-AV: E=Sophos;i="4.95,781,1384329600"; 
   d="scan'208";a="12703098"
From: Tim Kryger <tim.kryger@linaro.org>
To: Thierry Reding <thierry.reding@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "Kumar Gala" <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Christian Daudt <bcm@fixthebug.org>,
        Grant Likely <grant.likely@linaro.org>
CC: Tim Kryger <tim.kryger@linaro.org>,
        Linux PWM List <linux-pwm@vger.kernel.org>,
        Device Tree List <devicetree@vger.kernel.org>,
        Linux Doc List <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Broadcom Kernel Feedback List 
	<bcm-kernel-feedback-list@broadcom.com>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v2 1/5] Documentation: dt: Add Kona PWM binding
Date: Tue, 4 Feb 2014 11:51:39 -0800
Message-ID: <1391543503-14773-2-git-send-email-tim.kryger@linaro.org>
X-Mailer: git-send-email 1.8.0.1
In-Reply-To: <1391543503-14773-1-git-send-email-tim.kryger@linaro.org>
References: <1391543503-14773-1-git-send-email-tim.kryger@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the binding description for the Kona PWM controller found on Broadcom's
mobile SoCs.

Signed-off-by: Tim Kryger <tim.kryger@linaro.org>
Reviewed-by: Alex Elder <elder@linaro.org>
Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
---
 .../devicetree/bindings/pwm/bcm-kona-pwm.txt       | 24 ++++++++++++++++++++++
 1 file changed, 24 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/pwm/bcm-kona-pwm.txt

diff --git a/Documentation/devicetree/bindings/pwm/bcm-kona-pwm.txt b/Documentation/devicetree/bindings/pwm/bcm-kona-pwm.txt
new file mode 100644
index 0000000..c8e2d13
--- /dev/null
+++ b/Documentation/devicetree/bindings/pwm/bcm-kona-pwm.txt
@@ -0,0 +1,24 @@
+Broadcom Kona PWM controller device tree bindings
+
+This controller has 6 channels.
+
+Required Properties :
+- compatible: should be "brcm,kona-pwm"
+- reg: physical base address and length of the controller's registers
+- clocks: phandle + clock specifier pair for the external clock
+- #pwm-cells: should be 3.  The first cell specifies the per-chip index
+  of the PWM to use, the second cell is the period in nanoseconds, and
+  the third cell is the flags.
+
+Refer to pwm/pwm.txt for generic pwm controller node properties.
+
+Refer to clocks/clock-bindings.txt for generic clock consumer properties.
+
+Example:
+
+pwm: pwm@3e01a000 {
+	compatible = "brcm,bcm11351-pwm", "brcm,kona-pwm";
+	reg = <0x3e01a000 0xc4>;
+	clocks = <&pwm_clk>;
+	#pwm-cells = <3>;
+};
-- 
1.8.0.1

