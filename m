Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785AbaGPCCy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 22:02:54 -0400
Received: from cluster-g.mailcontrol.com ([208.87.233.190]:36430 "EHLO
	cluster-g.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862AbaGPCCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 22:02:52 -0400
X-Greylist: delayed 385 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Jul 2014 22:02:52 EDT
X-PGP-Universal: processed;
	by shaapppus01.asia.root.pri on Wed, 16 Jul 2014 10:02:28 +0800
From: Huayi Li <huayi.li@csr.com>
To: Thierry Reding <thierry.reding@gmail.com>, <linux-pwm@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <workgroup.linux@csr.com>,
        <rongjun.ying@csr.com>, <barry.song@csr.com>,
        Huayi Li <huayi.li@csr.com>
Subject: [PATCH v5 2/4] pwm: sirf: add dt-binding document
Date: Wed, 16 Jul 2014 10:01:53 +0800
Message-ID: <1405476113-10127-1-git-send-email-huayi.li@csr.com>
X-Mailer: git-send-email 1.9.3
MIME-Version: 1.0
X-Originating-IP: [10.125.12.180]
X-CFilter-Loop: Reflected
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds dt-binding document for pwm-sirf. here the controller clock
can't generate PWM signals, so we need seperate clock as signal source.

Signed-off-by: Huayi Li <huayi.li@csr.com>
---
 Documentation/devicetree/bindings/pwm/pwm-sirf.txt | 29 ++++++++++++++++++++++
 1 file changed, 29 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/pwm/pwm-sirf.txt

diff --git a/Documentation/devicetree/bindings/pwm/pwm-sirf.txt b/Documentation/devicetree/bindings/pwm/pwm-sirf.txt
new file mode 100644
index 0000000..221e5d9
--- /dev/null
+++ b/Documentation/devicetree/bindings/pwm/pwm-sirf.txt
@@ -0,0 +1,29 @@
+SiRF prima2 & atlas6 PWM drivers
+
+Required properties:
+- compatible: "sirf,prima2-pwm"
+- reg: physical base address and length of the controller's registers
+- #pwm-cells: should be 2. See pwm.txt in this directory for a description of
+  the cells format.
+- clocks: Must contain an entry for each entry in clock-names.
+  See ../clock/prima2-clock.txt for details.
+- clock-names: Must include the following entries:
+  of clock sources to generate PWM signal,
+  - pwmc: PWM controller clock
+  - sigsrc0: source clock 0 for PWM
+  - sigsrc1: source clock 1 for PWM
+  - sigsrc2: source clock 2 for PWM
+  - sigsrc3: source clock 3 for PWM
+  - sigsrc4: source clock 4 for PWM
+
+Example:
+
+pwm: pwm@b0130000 {
+	compatible = "sirf,prima2-pwm";
+	#pwm-cells = <2>;
+	reg = <0xb0130000 0x10000>;
+	clocks = <&clks 21>, <&clks 1>, <&clks 2>,
+	       <&clks 3>, <&clks 0>, <&clks 4>;
+	clock-names = "pwmc", "sigsrc0", "sigsrc1",
+		"sigsrc2", "sigsrc3", "sigsrc4";
+};
-- 
1.9.3



Member of the CSR plc group of companies. CSR plc registered in England and Wales, registered number 4187346, registered office Churchill House, Cambridge Business Park, Cowley Road, Cambridge, CB4 0WZ, United Kingdom
More information can be found at www.csr.com. Keep up to date with CSR on our technical blog, www.csr.com/blog, CSR people blog, www.csr.com/people, YouTube, www.youtube.com/user/CSRplc, Facebook, www.facebook.com/pages/CSR/191038434253534, or follow us on Twitter at www.twitter.com/CSR_plc.
New for 2014, you can now access the wide range of products powered by aptX at www.aptx.com.
