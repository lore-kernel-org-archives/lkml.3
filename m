Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038AbaCNKNl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 06:13:41 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:15980 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794AbaCNKNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 06:13:39 -0400
X-AuditID: cbfee61a-b7fb26d00000724f-36-5322d65216da
From: Robert Baldyga <r.baldyga@samsung.com>
To: ben-linux@fluff.org, kgene.kim@samsung.com
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        t.figa@samsung.com, Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH] ARM: dts: exynos4210-trats: add max8997 IRQ
Date: Fri, 14 Mar 2014 11:13:21 +0100
Message-id: <1394792001-7837-1-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKLMWRmVeSWpSXmKPExsVy+t9jAd2ga0rBBp8fc1hMWneAyWL+kXOs
	Fv1vFrJanHu1ktGid8FVNotNj6+xWlzeNYfNYsb5fUwWty/zWqw9cpfdYun1i0wWE6avZbF4
	cHgnu0Xr3iPsFutnvGZx4PdYM28No0dLcw+bx+W+XiaPv6teMHusXP6FzWPTqk42j81L6j36
	tqxi9Pi8SS6AM4rLJiU1J7MstUjfLoEr4+W8SawFn9grph35yNLAuISti5GTQ0LAROL2l3ns
	ELaYxIV764HiXBxCAosYJY5/vcQC4bQzSex9egOsg01AR2LL9wmMILaIgJ7ExQ+HwYqYBT4w
	SVw7u4oJJCEsYCOxav0/oAQHB4uAqsSeX5IgYV4BF4lFk34wgoQlBBQk5kyymcDIvYCRYRWj
	aGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcGA+k9rBuLLB4hCjAAejEg+vw2HFYCHWxLLiytxD
	jBIczEoivK5nlIKFeFMSK6tSi/Lji0pzUosPMUpzsCiJ8x5otQ4UEkhPLEnNTk0tSC2CyTJx
	cEo1MEoxckxN/nSz9sBqETP+mR4rFSPrvscU6fXPXerf9pxpx4qavhlH5q8w/HBQyHS2kqRx
	hkDKDeHnJZHGUzxS4q+pcz9InPI99/H9hMUVMvn+GpZOAv/U+jrfphuY14uZTE5ntVSoDz4l
	ms4fwbH7/Y6Z23qnpYYUT5veMvGJe1z3xG8PLVbuUmIpzkg01GIuKk4EALw9zulIAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds device tree node for IRQ used by max8997.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---
 arch/arm/boot/dts/exynos4210-trats.dts |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4210-trats.dts b/arch/arm/boot/dts/exynos4210-trats.dts
index 1d18428..0e1fc19 100644
--- a/arch/arm/boot/dts/exynos4210-trats.dts
+++ b/arch/arm/boot/dts/exynos4210-trats.dts
@@ -148,6 +148,14 @@
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
@@ -179,6 +187,11 @@
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

