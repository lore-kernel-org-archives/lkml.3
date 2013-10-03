Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080Ab3JCXG2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 19:06:28 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:34107 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374Ab3JCXG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 19:06:26 -0400
From: Rohit Vaswani <rvaswani@codeaurora.org>
To: David Brown <davidb@codeaurora.org>
Cc: Rohit Vaswani <rvaswani@codeaurora.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Russell King <linux@arm.linux.org.uk>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCHv4 2/4] ARM: msm: Add support for APQ8074 Dragonboard
Date: Thu,  3 Oct 2013 16:05:55 -0700
Message-Id: <1380841557-2673-3-git-send-email-rvaswani@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1380841557-2673-1-git-send-email-rvaswani@codeaurora.org>
References: <1380841557-2673-1-git-send-email-rvaswani@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds basic board support for APQ8074 Dragonboard
which belongs to the Snapdragon 800 family.
For now, just support a basic machine with device tree.

Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>
---
 arch/arm/boot/dts/Makefile                     |  3 ++-
 arch/arm/boot/dts/qcom-apq8074-dragonboard.dts |  6 +++++
 arch/arm/boot/dts/qcom-msm8974.dtsi            | 35 ++++++++++++++++++++++++++
 arch/arm/mach-msm/Kconfig                      | 13 ++++++++++
 arch/arm/mach-msm/board-dt.c                   |  9 +++++++
 5 files changed, 65 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm/boot/dts/qcom-apq8074-dragonboard.dts
 create mode 100644 arch/arm/boot/dts/qcom-msm8974.dtsi

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index 000cf76..e71a3ec 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -102,7 +102,8 @@ dtb-$(CONFIG_ARCH_KIRKWOOD) += kirkwood-cloudbox.dtb \
 	kirkwood-openblocks_a6.dtb
 dtb-$(CONFIG_ARCH_MARCO) += marco-evb.dtb
 dtb-$(CONFIG_ARCH_MSM) += msm8660-surf.dtb \
-	msm8960-cdp.dtb
+	msm8960-cdp.dtb \
+	qcom-apq8074-dragonboard.dtb
 dtb-$(CONFIG_ARCH_MVEBU) += armada-370-db.dtb \
 	armada-370-mirabox.dtb \
 	armada-370-netgear-rn102.dtb \
diff --git a/arch/arm/boot/dts/qcom-apq8074-dragonboard.dts b/arch/arm/boot/dts/qcom-apq8074-dragonboard.dts
new file mode 100644
index 0000000..bb6f3c4
--- /dev/null
+++ b/arch/arm/boot/dts/qcom-apq8074-dragonboard.dts
@@ -0,0 +1,6 @@
+/include/ "qcom-msm8974.dtsi"
+
+/ {
+	model = "Qualcomm APQ8074 Dragonboard";
+	compatible = "qcom,apq8074-dragonboard", "qcom,apq8074";
+};
diff --git a/arch/arm/boot/dts/qcom-msm8974.dtsi b/arch/arm/boot/dts/qcom-msm8974.dtsi
new file mode 100644
index 0000000..f04b643
--- /dev/null
+++ b/arch/arm/boot/dts/qcom-msm8974.dtsi
@@ -0,0 +1,35 @@
+/dts-v1/;
+
+/include/ "skeleton.dtsi"
+
+/ {
+	model = "Qualcomm MSM8974";
+	compatible = "qcom,msm8974";
+	interrupt-parent = <&intc>;
+
+	soc: soc { };
+};
+
+&soc {
+	#address-cells = <1>;
+	#size-cells = <1>;
+	ranges;
+	compatible = "simple-bus";
+
+	intc: interrupt-controller@f9000000 {
+		compatible = "qcom,msm-qgic2";
+		interrupt-controller;
+		#interrupt-cells = <3>;
+		reg = <0xf9000000 0x1000>,
+		      <0xf9002000 0x1000>;
+	};
+
+	timer {
+		compatible = "arm,armv7-timer";
+		interrupts = <1 2 0xf08>,
+			     <1 3 0xf08>,
+			     <1 4 0xf08>,
+			     <1 1 0xf08>;
+		clock-frequency = <19200000>;
+	};
+};
diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
index 2586c28..086bcb9 100644
--- a/arch/arm/mach-msm/Kconfig
+++ b/arch/arm/mach-msm/Kconfig
@@ -64,6 +64,19 @@ config ARCH_MSM_DT
 	select SPARSE_IRQ
 	select USE_OF
 
+config ARCH_MSM8974
+	bool "MSM8974"
+	select ARM_GIC
+	select CPU_V7
+	select HAVE_ARM_ARCH_TIMER
+	select HAVE_SMP
+	select MSM_SCM if SMP
+	select USE_OF
+
+config ARCH_MSM_DT
+	def_bool y
+	depends on (ARCH_MSM8X60 || ARCH_MSM8960 || ARCH_MSM8974)
+
 config MSM_HAS_DEBUG_UART_HS
 	bool
 
diff --git a/arch/arm/mach-msm/board-dt.c b/arch/arm/mach-msm/board-dt.c
index 266a280..5211e80 100644
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

