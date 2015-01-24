Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019AbbAXAyV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 19:54:21 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:6334 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750820AbbAXAyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 19:54:19 -0500
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Bryan Wu <cooloney@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Grant Likely <grant.likely@linaro.org>
CC: Courtney Cavin <courtney.cavin@sonymobile.com>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-leds@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>
Subject: [PATCH v2 1/2] leds: add DT binding for Qualcomm PM8941 WLED block
Date: Fri, 23 Jan 2015 16:54:12 -0800
Message-ID: <1422060853-1067-1-git-send-email-bjorn.andersson@sonymobile.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Courtney Cavin <courtney.cavin@sonymobile.com>

This adds device tree binding documentation for the WLED ('White' LED)
block on Qualcomm's PM8941 PMICs.

Signed-off-by: Courtney Cavin <courtney.cavin@sonymobile.com>
Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
---
 .../devicetree/bindings/leds/leds-pm8941-wled.txt  | 43 ++++++++++++++++++++++
 1 file changed, 43 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/leds/leds-pm8941-wled.txt

diff --git a/Documentation/devicetree/bindings/leds/leds-pm8941-wled.txt b/Documentation/devicetree/bindings/leds/leds-pm8941-wled.txt
new file mode 100644
index 0000000..a85a964
--- /dev/null
+++ b/Documentation/devicetree/bindings/leds/leds-pm8941-wled.txt
@@ -0,0 +1,43 @@
+Binding for Qualcomm PM8941 WLED driver
+
+Required properties:
+- compatible: should be "qcom,pm8941-wled"
+- reg: slave address
+
+Optional properties:
+- label: The label for this led
+  See Documentation/devicetree/bindings/leds/common.txt
+- linux,default-trigger: Default trigger assigned to the LED
+  See Documentation/devicetree/bindings/leds/common.txt
+- qcom,cs-out: bool; enable current sink output
+- qcom,cabc: bool; enable content adaptive backlight control
+- qcom,ext-gen: bool; use externally generated modulator signal to dim
+- qcom,current-limit: mA; per-string current limit; value from 0 to 25
+	default: 20mA
+- qcom,current-boost-limit: mA; boost current limit; one of:
+	105, 385, 525, 805, 980, 1260, 1400, 1680
+	default: 805mA
+- qcom,switching-freq: kHz; switching frequency; one of:
+	600, 640, 685, 738, 800, 872, 960, 1066, 1200, 1371,
+	1600, 1920, 2400, 3200, 4800, 9600,
+	default: 1600kHz
+- qcom,ovp: V; Over-voltage protection limit; one of:
+	27, 29, 32, 35
+	default: 29V
+- qcom,num-strings: #; number of led strings attached; value from 1 to 3
+	default: 2
+
+Example:
+
+pm8941-wled@d800 {
+	compatible = "qcom,pm8941-wled";
+	reg = <0xd800>;
+	label = "backlight";
+
+	qcom,cs-out;
+	qcom,current-limit = <20>;
+	qcom,current-boost-limit = <805>;
+	qcom,switching-freq = <1600>;
+	qcom,ovp = <29>;
+	qcom,num-strings = <2>;
+};
-- 
1.9.1

