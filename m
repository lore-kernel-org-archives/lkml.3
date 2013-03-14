Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757208Ab3CNKhq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 06:37:46 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:41220 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757132Ab3CNKhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:37:40 -0400
From: Philip Avinash <avinashphilip@ti.com>
To: <nsekhar@ti.com>, <linux@arm.linux.org.uk>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>, <prakash.pm@ti.com>,
        Philip Avinash <avinashphilip@ti.com>
Subject: [PATCH 3/3] ARM: davinci: da850: add EHRPWM & ECAP DT node
Date: Thu, 14 Mar 2013 16:07:33 +0530
Message-ID: <1363257453-24747-4-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1363257453-24747-1-git-send-email-avinashphilip@ti.com>
References: <1363257453-24747-1-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add da850 EHRPWM & ECAP DT node.
Also adds OF_DEV_AUXDATA for EHRPWM & ECAP driver to use EHRPWM & ECAP
clock.

Signed-off-by: Philip Avinash <avinashphilip@ti.com>
---
:100644 100644 3ec1bda... 9b5b613... M	arch/arm/boot/dts/da850.dtsi
:100644 100644 72466ab... e32484c... M	arch/arm/mach-davinci/da8xx-dt.c
 arch/arm/boot/dts/da850.dtsi     |   30 ++++++++++++++++++++++++++++++
 arch/arm/mach-davinci/da8xx-dt.c |    5 +++++
 2 files changed, 35 insertions(+)

diff --git a/arch/arm/boot/dts/da850.dtsi b/arch/arm/boot/dts/da850.dtsi
index 3ec1bda..9b5b613 100644
--- a/arch/arm/boot/dts/da850.dtsi
+++ b/arch/arm/boot/dts/da850.dtsi
@@ -107,6 +107,36 @@
 			reg = <0x21000 0x1000>;
 			status = "disabled";
 		};
+		ehrpwm0: ehrpwm@01f00000 {
+			compatible = "ti,da850-ehrpwm";
+			#pwm-cells = <3>;
+			reg = <0x300000 0x2000>;
+			status = "disabled";
+		};
+		ehrpwm1: ehrpwm@01f02000 {
+			compatible = "ti,da850-ehrpwm";
+			#pwm-cells = <3>;
+			reg = <0x302000 0x2000>;
+			status = "disabled";
+		};
+		ecap0: ecap@01f06000 {
+			compatible = "ti,da850-ecap";
+			#pwm-cells = <3>;
+			reg = <0x306000 0x80>;
+			status = "disabled";
+		};
+		ecap1: ecap@01f07000 {
+			compatible = "ti,da850-ecap";
+			#pwm-cells = <3>;
+			reg = <0x307000 0x80>;
+			status = "disabled";
+		};
+		ecap2: ecap@01f08000 {
+			compatible = "ti,da850-ecap";
+			#pwm-cells = <3>;
+			reg = <0x308000 0x80>;
+			status = "disabled";
+		};
 	};
 	nand_cs3@62000000 {
 		compatible = "ti,davinci-nand";
diff --git a/arch/arm/mach-davinci/da8xx-dt.c b/arch/arm/mach-davinci/da8xx-dt.c
index 72466ab..e32484c 100644
--- a/arch/arm/mach-davinci/da8xx-dt.c
+++ b/arch/arm/mach-davinci/da8xx-dt.c
@@ -41,6 +41,11 @@ static void __init da8xx_init_irq(void)
 struct of_dev_auxdata da850_auxdata_lookup[] __initdata = {
 	OF_DEV_AUXDATA("ti,davinci-i2c", 0x01c22000, "i2c_davinci.1", NULL),
 	OF_DEV_AUXDATA("ti,davinci-wdt", 0x01c21000, "watchdog", NULL),
+	OF_DEV_AUXDATA("ti,da850-ehrpwm", 0x01f00000, "ehrpwm", NULL),
+	OF_DEV_AUXDATA("ti,da850-ehrpwm", 0x01f02000, "ehrpwm", NULL),
+	OF_DEV_AUXDATA("ti,da850-ecap", 0x01f06000, "ecap", NULL),
+	OF_DEV_AUXDATA("ti,da850-ecap", 0x01f07000, "ecap", NULL),
+	OF_DEV_AUXDATA("ti,da850-ecap", 0x01f08000, "ecap", NULL),
 	{}
 };
 
-- 
1.7.9.5

