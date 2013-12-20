Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195Ab3LTTKN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 14:10:13 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:37418 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753650Ab3LTTJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 14:09:34 -0500
From: David Brown <davidb@codeaurora.org>
To: arm@kernel.org
Cc: Rohit Vaswani <rvaswani@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        David Brown <davidb@codeaurora.org>
Subject: [PATCH 2/7] ARM: msm: Add support for APQ8074 Dragonboard
Date: Fri, 20 Dec 2013 11:09:15 -0800
Message-Id: <1387566560-23948-3-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1387566560-23948-1-git-send-email-davidb@codeaurora.org>
References: <1387566560-23948-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rohit Vaswani <rvaswani@codeaurora.org>

This patch adds basic board support for APQ8074 Dragonboard
which belongs to the Snapdragon 800 family.
For now, just support a basic machine with device tree.

Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>
Acked-by: Kumar Gala <galak@codeaurora.org>
Signed-off-by: David Brown <davidb@codeaurora.org>
---
 arch/arm/boot/dts/Makefile                     |  3 ++-
 arch/arm/boot/dts/qcom-apq8074-dragonboard.dts |  6 +++++
 arch/arm/boot/dts/qcom-msm8974.dtsi            | 33 ++++++++++++++++++++++++++
 arch/arm/mach-msm/Kconfig                      | 11 ++++++++-
 arch/arm/mach-msm/board-dt.c                   |  9 +++++++
 5 files changed, 60 insertions(+), 2 deletions(-)
 create mode 100644 arch/arm/boot/dts/qcom-apq8074-dragonboard.dts
 create mode 100644 arch/arm/boot/dts/qcom-msm8974.dtsi

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index d57c1a6..5b37694 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -105,7 +105,8 @@ dtb-$(CONFIG_ARCH_KIRKWOOD) += kirkwood-cloudbox.dtb \
 	kirkwood-ts219-6282.dtb
 dtb-$(CONFIG_ARCH_MARCO) += marco-evb.dtb
 dtb-$(CONFIG_ARCH_MSM) += qcom-msm8660-surf.dtb \
-	qcom-msm8960-cdp.dtb
+	qcom-msm8960-cdp.dtb \
+	qcom-apq8074-dragonboard.dtb
 dtb-$(CONFIG_ARCH_MVEBU) += armada-370-db.dtb \
 	armada-370-mirabox.dtb \
 	armada-370-netgear-rn102.dtb \
diff --git a/arch/arm/boot/dts/qcom-apq8074-dragonboard.dts b/arch/arm/boot/dts/qcom-apq8074-dragonboard.dts
new file mode 100644
index 0000000..13ac3e2
--- /dev/null
+++ b/arch/arm/boot/dts/qcom-apq8074-dragonboard.dts
@@ -0,0 +1,6 @@
+#include "qcom-msm8974.dtsi"
+
+/ {
+	model = "Qualcomm APQ8074 Dragonboard";
+	compatible = "qcom,apq8074-dragonboard", "qcom,apq8074";
+};
diff --git a/arch/arm/boot/dts/qcom-msm8974.dtsi b/arch/arm/boot/dts/qcom-msm8974.dtsi
new file mode 100644
index 0000000..2ebb4f0
--- /dev/null
+++ b/arch/arm/boot/dts/qcom-msm8974.dtsi
@@ -0,0 +1,33 @@
+/dts-v1/;
+
+#include "skeleton.dtsi"
+
+/ {
+	model = "Qualcomm MSM8974";
+	compatible = "qcom,msm8974";
+	interrupt-parent = <&intc>;
+
+	soc: soc {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+		compatible = "simple-bus";
+
+		intc: interrupt-controller@f9000000 {
+			compatible = "qcom,msm-qgic2";
+			interrupt-controller;
+			#interrupt-cells = <3>;
+			reg = <0xf9000000 0x1000>,
+			      <0xf9002000 0x1000>;
+		};
+
+		timer {
+			compatible = "arm,armv7-timer";
+			interrupts = <1 2 0xf08>,
+				     <1 3 0xf08>,
+				     <1 4 0xf08>,
+				     <1 1 0xf08>;
+			clock-frequency = <19200000>;
+		};
+	};
+};
diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
index 2586c28..5e5782d 100644
--- a/arch/arm/mach-msm/Kconfig
+++ b/arch/arm/mach-msm/Kconfig
@@ -58,9 +58,18 @@ config ARCH_MSM8960
 	select GPIO_MSM_V2
 	select MSM_SCM if SMP
 
+config ARCH_MSM8974
+	bool "MSM8974"
+	select ARM_GIC
+	select CPU_V7
+	select HAVE_ARM_ARCH_TIMER
+	select HAVE_SMP
+	select MSM_SCM if SMP
+	select USE_OF
+
 config ARCH_MSM_DT
 	def_bool y
-	depends on (ARCH_MSM8X60 || ARCH_MSM8960)
+	depends on (ARCH_MSM8X60 || ARCH_MSM8960 || ARCH_MSM8974)
 	select SPARSE_IRQ
 	select USE_OF
 
diff --git a/arch/arm/mach-msm/board-dt.c b/arch/arm/mach-msm/board-dt.c
index 16e6183..1f11d93 100644
--- a/arch/arm/mach-msm/board-dt.c
+++ b/arch/arm/mach-msm/board-dt.c
@@ -26,7 +26,16 @@ static const char * const msm_dt_match[] __initconst = {
 	NULL
 };
 
+static const char * const apq8074_dt_match[] __initconst = {
+	"qcom,apq8074-dragonboard",
+	NULL
+};
+
 DT_MACHINE_START(MSM_DT, "Qualcomm MSM (Flattened Device Tree)")
 	.smp = smp_ops(msm_smp_ops),
 	.dt_compat = msm_dt_match,
 MACHINE_END
+
+DT_MACHINE_START(APQ_DT, "Qualcomm MSM (Flattened Device Tree)")
+	.dt_compat = apq8074_dt_match,
+MACHINE_END
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

