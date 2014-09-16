Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339AbaIPXDy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 19:03:54 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:12607 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753867AbaIPXDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 19:03:53 -0400
Message-ID: <5418C1D2.4000303@sonymobile.com>
Date: Tue, 16 Sep 2014 16:03:46 -0700
From: Tim Bird <tim.bird@sonymobile.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: <galak@codeaurora.org>
CC: <linux-arm-msm@vger.kernel.org>,
        Bjorn Andersson <Bjorn.Andersson@sonymobile.com>,
        <linux-kernel@vger.kernel.org>, <device-tree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        "arnd.bergmann@linaro.org" <arnd.bergmann@linaro.org>
Subject: [PATCH] ARM: dts: Add initial DTS file for Sony Xperia Z1 phone
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This DTS has initial support for just a serial console, for the
Sony Xperia Z1 phone.  This phone uses a QualComm 8074 processor.

Signed-off-by: Tim Bird <tim.bird@sonymobile.com>
---
 arch/arm/boot/dts/Makefile                   |    1 +
 arch/arm/boot/dts/qcom-apq8074-xperia-z1.dts |   18 ++++++++++++++++++
 2 files changed, 19 insertions(+)
 create mode 100644 arch/arm/boot/dts/qcom-apq8074-xperia-z1.dts

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index b8c5cd3..680ce7e 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -341,6 +341,7 @@ dtb-$(CONFIG_ARCH_PRIMA2) += prima2-evb.dtb
 dtb-$(CONFIG_ARCH_QCOM) += \
 	qcom-apq8064-ifc6410.dtb \
 	qcom-apq8074-dragonboard.dtb \
+	qcom-apq8074-xperia-z1.dtb \
 	qcom-apq8084-mtp.dtb \
 	qcom-msm8660-surf.dtb \
 	qcom-msm8960-cdp.dtb
diff --git a/arch/arm/boot/dts/qcom-apq8074-xperia-z1.dts b/arch/arm/boot/dts/qcom-apq8074-xperia-z1.dts
new file mode 100644
index 0000000..59b3fa1
--- /dev/null
+++ b/arch/arm/boot/dts/qcom-apq8074-xperia-z1.dts
@@ -0,0 +1,18 @@
+#include "qcom-msm8974.dtsi"
+
+/ {
+	model = "Sony Xperia Z1 phone";
+	compatible = "qcom,msm8974";
+	qcom,msm-id = <126 8 0>, <185 8 0>, <186 8 0>;
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
1.7.9.5

