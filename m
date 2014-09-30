Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751376AbaI3Wt5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 18:49:57 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:16630 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750717AbaI3Wtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 18:49:55 -0400
Message-ID: <542B338D.2040909@sonymobile.com>
Date: Tue, 30 Sep 2014 15:49:49 -0700
From: Tim Bird <tim.bird@sonymobile.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Kumar Gala <galak@codeaurora.org>
CC: Bjorn Andersson <Bjorn.Andersson@sonymobile.com>,
        Kevin Hilman <khilman@linaro.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v3] ARM: dts: Add initial DTS file for Sony Xperia Z1 phone
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This DTS has support for the Sony Xperia Z1 phone (codenamed Honami).
This first version of the DTS supports just a serial console.

changes from V2
 - fixed dtb name in Makefile

changes from v1
 - removed qcom,msm-id attribute
 - removed mis-capitalized Qualcomm word
 - changed dts file name
 - added board-specific compatible-string

Signed-off-by: Tim Bird <tim.bird@sonymobile.com>
Tested-by: Kevin Hilman <khilman@linaro.org>
---

This version fixes the dtb name.  I asked previously about adding to qcom_dt_match,
but apparently board compatibles are being removed from that list in
mach_qcom/board.c
See https://lkml.org/lkml/2014/9/24/952

Kevin tested this (modulu re-adding back the qcom,msm-id).  I have a new
mkqcdtbootimg which works without requiring the qcom,msm-id attribute,
that I'll send to Kevin shortly (and publish on github).

 Documentation/devicetree/bindings/vendor-prefixes.txt |  1 +
 arch/arm/boot/dts/Makefile                            |  3 ++-
 arch/arm/boot/dts/qcom-msm8974-sony-xperia-honami.dts | 17 +++++++++++++++++
 3 files changed, 20 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm/boot/dts/qcom-msm8974-sony-xperia-honami.dts

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
index ac7269f..d3a4579 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -128,6 +128,7 @@ sirf	SiRF Technology, Inc.
 smsc	Standard Microsystems Corporation
 snps 	Synopsys, Inc.
 solidrun	SolidRun
+sony	Sony Corporation
 spansion	Spansion Inc.
 st	STMicroelectronics
 ste	ST-Ericsson
diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index b8c5cd3..cf58321 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -343,7 +343,8 @@ dtb-$(CONFIG_ARCH_QCOM) += \
 	qcom-apq8074-dragonboard.dtb \
 	qcom-apq8084-mtp.dtb \
 	qcom-msm8660-surf.dtb \
-	qcom-msm8960-cdp.dtb
+	qcom-msm8960-cdp.dtb \
+	qcom-msm8974-sony-xperia-honami.dtb
 dtb-$(CONFIG_ARCH_ROCKCHIP) += \
 	rk3066a-bqcurie2.dtb \
 	rk3188-radxarock.dtb \
diff --git a/arch/arm/boot/dts/qcom-msm8974-sony-xperia-honami.dts b/arch/arm/boot/dts/qcom-msm8974-sony-xperia-honami.dts
new file mode 100644
index 0000000..cccc21b
--- /dev/null
+++ b/arch/arm/boot/dts/qcom-msm8974-sony-xperia-honami.dts
@@ -0,0 +1,17 @@
+#include "qcom-msm8974.dtsi"
+
+/ {
+	model = "Sony Xperia Z1";
+	compatible = "sony,xperia-honami", "qcom,msm8974";
+
+	memory@0 {
+		reg = <0 0x40000000>, <0x40000000 0x40000000>;
+		device_type = "memory";
+	};
+};
+
+&soc {
+	serial@f991e000 {
+		status = "ok";
+	};
+};
-- 
1.8.2.2

