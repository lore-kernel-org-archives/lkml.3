Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482AbaCZKHl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 06:07:41 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:40677 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbaCZKHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 06:07:39 -0400
X-AuditID: cbfee61a-b7fb26d00000724f-4f-5332a6e1a2c0
From: Robert Baldyga <r.baldyga@samsung.com>
To: ben-linux@fluff.org, kgene.kim@samsung.com
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        t.figa@samsung.com, Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH v2] ARM: dts: exynos4210-trats: add max8997 IRQ
Date: Wed, 26 Mar 2014 11:07:09 +0100
Message-id: <1395828429-11023-1-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGLMWRmVeSWpSXmKPExsVy+t9jQd2Hy4yCDZYv4rKYtO4Ak8X8I+dY
	LfrfLGS1OPdqJaNF74KrbBabHl9jtbi8aw6bxYzz+5gsbl/mtVh75C67xdLrF5ksJkxfy2Lx
	4PBOdovWvUfYLdbPeM3iwO+xZt4aRo+W5h42j8t9vUwef1e9YPZYufwLm8emVZ1sHpuX1Hv0
	bVnF6PF5k1wAZxSXTUpqTmZZapG+XQJXxrWOdSwF57gq3l5sZGpgPMLRxcjJISFgIrFq4n12
	CFtM4sK99WxdjFwcQgLTGSXmHXnFDuG0M0l8Pr0TrIpNQEdiy/cJjCC2iICexMUPh1lAipgF
	PjBJXDu7igkkISxgL9G36BBYA4uAqsTH5z9ZQWxeAVeJGWtOA9kcQOsUJOZMspnAyL2AkWEV
	o2hqQXJBcVJ6rqFecWJucWleul5yfu4mRnBoPpPawbiyweIQowAHoxIP74QJhsFCrIllxZW5
	hxglOJiVRHiDm42ChXhTEiurUovy44tKc1KLDzFKc7AoifMeaLUOFBJITyxJzU5NLUgtgsky
	cXBKNTCuuclwNdaa2/DYs4m2/1YdaZxSMHHuoaAz+kriZsKp/ltOPVZn9+c6/u/3saXlT7er
	5Ey5FJTud+Hiri/8LKqfX2QyvhGOfOYp9eb11xciUnJ67lJFmzY/Pl1x8ohOVdGXzRp3bzkU
	d7Gl2PjVBbiWvt7wdJLQo9a7NxevnKgn9m7Fior1l9RqlViKMxINtZiLihMBFeQb80kCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds IRQ line specification for the MAX8997 chip and necessary
pinctrl group to configure pull-up and driver strength of the pin.
It's needed for proper handling of IRQs coming from MAX8997 multifunction
device (IRQs are used by PMIC, MUIC and RTC).

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
---

Changelog:

v2:
- Corrected commit message.

v1: https://lkml.org/lkml/2014/3/14/124

 arch/arm/boot/dts/exynos4210-trats.dts |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4210-trats.dts b/arch/arm/boot/dts/exynos4210-trats.dts
index 662b482..5629eef 100644
--- a/arch/arm/boot/dts/exynos4210-trats.dts
+++ b/arch/arm/boot/dts/exynos4210-trats.dts
@@ -156,6 +156,14 @@
 		};
 	};
 
+	pinctrl@11000000 {
+		max8997_irq: max8997-irq {
+			samsung,pins = "gpx0-7";
+			samsung,pin-pud = <3>;
+			samsung,pin-drv = <0>;
+		};
+	};
+
 	i2c@13890000 {
 		samsung,i2c-sda-delay = <100>;
 		samsung,i2c-slave-addr = <0x10>;
@@ -187,6 +195,11 @@
 		max8997_pmic@66 {
 			compatible = "maxim,max8997-pmic";
 
+			pinctrl-0 = <&max8997_irq>;
+			pinctrl-names = "default";
+
+			interrupt-parent = <&gpx0>;
+			interrupts = <7 0>;
 			reg = <0x66>;
 
 			max8997,pmic-buck1-uses-gpio-dvs;
-- 
1.7.9.5

