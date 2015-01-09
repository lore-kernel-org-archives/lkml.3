Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932904AbbAIR5R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 12:57:17 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:37744 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715AbbAIR5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 12:57:13 -0500
From: Ezequiel Garcia <ezequiel.garcia@imgtec.com>
To: Andrew Bresticker <abrestic@chromium.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        James Hartley <james.hartley@imgtec.com>,
        "Arnd Bergmann" <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-pwm@vger.kernel.org>, <vladimir_zapolskiy@mentor.com>,
        Naidu Tellapati <naidu.tellapati@gmail.com>,
        Naidu Tellapati <Naidu.Tellapati@imgtec.com>,
        Sai Masarapu <Sai.Masarapu@imgtec.com>,
        Ezequiel Garcia <ezequiel.garcia@imgtec.com>
Subject: [PATCH v8 2/2] DT: pwm: Add binding document for IMG PWM DAC
Date: Fri, 9 Jan 2015 14:54:48 -0300
Message-ID: <1420826088-13113-3-git-send-email-ezequiel.garcia@imgtec.com>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <1420826088-13113-1-git-send-email-ezequiel.garcia@imgtec.com>
References: <1420826088-13113-1-git-send-email-ezequiel.garcia@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.100.200.183]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Naidu Tellapati <naidu.tellapati@gmail.com>

Add binding document for IMG Pulse Width Modulator (PWM) DAC present on the
Pistachio SOC. The PWM DAC has four channels.

Signed-off-by: Naidu Tellapati <Naidu.Tellapati@imgtec.com>
Signed-off-by: Sai Masarapu <Sai.Masarapu@imgtec.com>
Signed-off-by: Ezequiel Garcia <ezequiel.garcia@imgtec.com>
---
 Documentation/devicetree/bindings/pwm/img-pwm.txt | 24 +++++++++++++++++++++++
 1 file changed, 24 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/pwm/img-pwm.txt

diff --git a/Documentation/devicetree/bindings/pwm/img-pwm.txt b/Documentation/devicetree/bindings/pwm/img-pwm.txt
new file mode 100644
index 0000000..fade5f2
--- /dev/null
+++ b/Documentation/devicetree/bindings/pwm/img-pwm.txt
@@ -0,0 +1,24 @@
+*Imagination Technologies PWM DAC driver
+
+Required properties:
+  - compatible: Should be "img,pistachio-pwm"
+  - reg: Should contain physical base address and length of pwm registers.
+  - clocks: Must contain an entry for each entry in clock-names.
+	See ../clock/clock-bindings.txt for details.
+  - clock-names: Must include the following entries.
+    - pwm: PWM operating clock.
+    - sys: PWM system interface clock.
+  - #pwm-cells: Should be 2. See pwm.txt in this directory for the
+	description of the cells format.
+  - img,cr-periph: Must contain a phandle to the peripheral control
+	syscon node which contains PWM control registers.
+
+Example:
+	pwm: pwm@18101300 {
+		compatible = "img,pistachio-pwm";
+		reg = <0x18101300 0x100>;
+		clocks = <&pwm_clk>, <&system_clk>;
+		clock-names = "pwm", "sys";
+		#pwm-cells = <2>;
+		img,cr-periph = <&cr_periph>;
+	};
-- 
2.2.1

