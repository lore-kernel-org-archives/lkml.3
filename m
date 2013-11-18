Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990Ab3KRS5J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 13:57:09 -0500
Received: from mms1.broadcom.com ([216.31.210.17]:4397 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753209Ab3KRSz2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 13:55:28 -0500
X-Server-Uuid: 06151B78-6688-425E-9DE2-57CB27892261
From: "Tim Kryger" <tim.kryger@linaro.org>
To: "Thierry Reding" <thierry.reding@gmail.com>,
        "Rob Herring" <rob.herring@calxeda.com>,
        "Pawel Moll" <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        "Stephen Warren" <swarren@wwwdotorg.org>,
        "Ian Campbell" <ijc+devicetree@hellion.org.uk>,
        "Rob Landley" <rob@landley.net>, "Christian Daudt" <bcm@fixthebug.org>,
        "Grant Likely" <grant.likely@linaro.org>
cc: "Tim Kryger" <tim.kryger@linaro.org>,
        "Linux PWM List" <linux-pwm@vger.kernel.org>,
        "Device Tree List" <devicetree@vger.kernel.org>,
        "Linux Doc List" <linux-doc@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "Broadcom Kernel Feedback List" 
	<bcm-kernel-feedback-list@broadcom.com>,
        "Linux ARM Kernel List" <linux-arm-kernel@lists.infradead.org>,
        "Linaro Patches List" <patches@linaro.org>
Subject: [PATCH 1/5] Documentation: dt: Add kona-pwm binding
Date: Mon, 18 Nov 2013 10:54:57 -0800
Message-ID: <1384800901-21711-2-git-send-email-tim.kryger@linaro.org>
X-Mailer: git-send-email 1.8.0.1
In-Reply-To: <1384800901-21711-1-git-send-email-tim.kryger@linaro.org>
References: <1384800901-21711-1-git-send-email-tim.kryger@linaro.org>
MIME-Version: 1.0
X-WSS-ID: 7E94BD021509192163-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the binding description for the kona-pwm block found on Broadcom's
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
index 0000000..5c3ea1b
--- /dev/null
+++ b/Documentation/devicetree/bindings/pwm/bcm-kona-pwm.txt
@@ -0,0 +1,24 @@
+Broadcom's PWM Controller Device Tree bindings
+
+Broadcom's Kona PWM Controller has 6 channels
+
+Required Properties :
+- compatible: should be "brcm,kona-pwm"
+- reg: physical base address and length of the controller's registers
+- clocks: clock specifier for the kona pwm external clock
+- #pwm-cells: should be 2.  The first cell specifies the per-chip index
+  of the PWM to use and the second cell is the period in nanoseconds.
+
+Refer to pwm/pwm.txt for generic pwm controller node properties.
+
+Refer to clocks/clock-bindings.txt for generic clock consumer
+properties
+
+Example:
+
+pwm: pwm@3e01a000 {
+	compatible = "brcm,bcm11351-pwm", "brcm,kona-pwm";
+	reg = <0x3e01a000 0xc4>;
+	clocks = <&pwm_clk>;
+	#pwm-cells = <2>;
+};
-- 
1.8.0.1


