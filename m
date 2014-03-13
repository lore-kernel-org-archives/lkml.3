Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668AbaCMIVQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 04:21:16 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:8436 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411AbaCMIRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 04:17:43 -0400
X-AuditID: cbfee68f-b7f156d00000276c-69-532169a04486
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, kyungmin.park@samsung.com
Cc: rafael.j.wysocki@intel.com, nm@ti.com, b.zolnierkie@samsaung.com,
        pawel.moll@arm.com, mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv2 8/8] devfreq: exynos4: Add busfreq driver for
 exynos4210/exynos4x12
Date: Thu, 13 Mar 2014 17:17:29 +0900
Message-id: <1394698649-20996-9-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1394698649-20996-1-git-send-email-cw00.choi@samsung.com>
References: <1394698649-20996-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsWyRsSkRHdBpmKwwZRbxhYdPb9ZLK5/ec5q
	Mf/IOVaLc69WMlqcbXrDbrGwbQmLxeVdc9gsPvceYbSYcX4fk8XS6xeZLG43rmCzePPjLJPF
	hOlrWSwer3jLbvHqYBuLA7/HmnlrGD1WLv/C5rF4z0smj5/Lt7N79G1Zxehx/MZ2Jo/Pm+Q8
	Ns4NDeCI4rJJSc3JLEst0rdL4MrY9f0YS8Em0YrrTbdZGhh/CnYxcnJICJhIdMx8wgRhi0lc
	uLeerYuRi0NIYCmjRPf7PlaYommn17NDJKYzSnw6v4oZwmlkkpg/7SdYFZuAlsT+FzfYQGwR
	AXOJXUt/go1iFnjGJHGrvw9sh7BAuMTdhuvMIDaLgKrEoZ/nwGxeAVeJKx8+sEGsk5P4sOcR
	O4jNKeAmcfPuNLBeIaCaC61TwDZLCHxklzh/9joLxCABiW+TDwHZHEAJWYlNB5gh5khKHFxx
	g2UCo/ACRoZVjKKpBckFxUnpRcZ6xYm5xaV56XrJ+bmbGIFxdfrfs/4djHcPWB9iTAYaN5FZ
	SjQ5HxiXeSXxhsZmRhamJqbGRuaWZqQJK4nz3n+YFCQkkJ5YkpqdmlqQWhRfVJqTWnyIkYmD
	U6qBUVVm/9o/n0r1c2q2pOpUnMp9kbTr89X5MXbtzw1eTj/3RGcFj3xoZEL4jgStixpv1eWn
	vqlKqYx/pddo2di110bh2Ec/zkv90d0vdRdP3Vc1Le+HWvARnuT2UyuXT1oSXVD0yClqe7R3
	v+S3drWj6daGpkVm0dPnzBUteVtyaTNzNWP4SqYvSizFGYmGWsxFxYkAz8ucVMECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42I5/e+xoO6CTMVgg6+/dSw6en6zWFz/8pzV
	Yv6Rc6wW516tZLQ42/SG3WJh2xIWi8u75rBZfO49wmgx4/w+Joul1y8yWdxuXMFm8ebHWSaL
	CdPXslg8XvGW3eLVwTYWB36PNfPWMHqsXP6FzWPxnpdMHj+Xb2f36NuyitHj+I3tTB6fN8l5
	bJwbGsAR1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuW
	mQN0vZJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsIYxY9f3YywFm0Qrrjfd
	Zmlg/CnYxcjJISFgIjHt9Hp2CFtM4sK99WxdjFwcQgLTGSU+nV/FDOE0MknMn/aTFaSKTUBL
	Yv+LG2wgtoiAucSupT/BOpgFnjFJ3OrvYwJJCAuES9xtuM4MYrMIqEoc+nkOzOYVcJW48uED
	G8Q6OYkPex6BreYUcJO4eXcaWK8QUM2F1inMExh5FzAyrGIUTS1ILihOSs810itOzC0uzUvX
	S87P3cQIjtpn0jsYVzVYHGIU4GBU4uFdsVwhWIg1say4MvcQowQHs5IIr6ePYrAQb0piZVVq
	UX58UWlOavEhxmSgqyYyS4km5wMTSl5JvKGxiZmRpZG5oYWRsTlpwkrivAdbrQOFBNITS1Kz
	U1MLUotgtjBxcEo1MMpV9T6WZZxQ9U5XpWn9s32MCzrmP1/OdzSAW+bGpfehXoyWr549vsH/
	9vpmYdcjD+sNA41WTxSNWR8yQ2ZnSf/PV7Gfv0w6zlB8tCGp4GzeAvnYlWc0JnScXOn398Je
	i70K7bffla83ucB/7/sLterluhf3HL9/MvqQz+tV+b66l2epMH1NfrxXiaU4I9FQi7moOBEA
	eMhYIR4DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add busfreq driver for Exynos4210/Exynos4x12 memory interface
and bus to support DVFS(Dynamic Voltage Frequency Scaling) according to PPMU
counters. PPMU (Performance Profiling Monitorings Units) of Exynos4 SoC provides
PPMU counters for DMC(Dynamic Memory Controller) to check memory bus utilization
and then busfreq driver adjusts dynamically the operating frequency/voltage
by using DEVFREQ Subsystem.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 .../devicetree/bindings/devfreq/exynos4_bus.txt    | 49 ++++++++++++++++++++++
 1 file changed, 49 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/devfreq/exynos4_bus.txt

diff --git a/Documentation/devicetree/bindings/devfreq/exynos4_bus.txt b/Documentation/devicetree/bindings/devfreq/exynos4_bus.txt
new file mode 100644
index 0000000..2a83fcc
--- /dev/null
+++ b/Documentation/devicetree/bindings/devfreq/exynos4_bus.txt
@@ -0,0 +1,49 @@
+
+Exynos4210/4x12 busfreq driver
+-----------------------------
+
+Exynos4210/4x12 Soc busfreq driver with devfreq for Memory bus frequency/voltage
+scaling according to PPMU counters of memory controllers
+
+Required properties:
+- compatible	: should contain Exynos4 SoC type as follwoing:
+		  - "samsung,exynos4x12-busfreq" for Exynos4x12
+		  - "samsung,exynos4210-busfreq" for Exynos4210
+- reg		: offset and length of the ppmudmc0/1
+		  - PPMU (Performance Profiling Monitoring Units)
+		  : It is to profile performance event of DMC(Dynamic Memory
+		  Controller) So, exynos4_bus.c can check memory bus utilization
+		  by using PPMU of Exynos4 SoC.
+- clocks	: clock number of ppmudmc0/1
+- clock-names	: clock name of ppmudmc0/1
+- vdd_int-supply: regulator for interface block of Exynos4
+
+Optional properties:
+- vdd_mif-supply: regulator for DMC block of Exynos4x12 if Exynos4x12 Soc
+- regs-name	: register name of ppmudmc0/1
+
+All the required listed above must be defined under code busfreq with devfreq
+
+Exmaple:
+For Exynos4210 busfreq,
+	busfreq@106A0000 {
+		compatible = "samsung,exynos4210-busfreq";
+		reg = <0x106A0000 0x2000>, <0x106B0000 0x2000>;
+		regs-name = "PPMU_DMC0", "PPMU_DMC1";
+		clocks = <&clock CLK_PPMUDMC0>, <&clock CLK_PPMUDMC1>;
+		clock-names = "ppmudmc0", "ppmudmc1";
+
+		vdd_int-supply = <&buck3_reg>;
+	};
+
+For Exynos4x12 busfreq,
+	busfreq@106A0000 {
+		compatible = "samsung,exynos4x12-busfreq";
+		reg = <0x106A0000 0x2000>, <0x106B0000 0x2000>;
+		regs-name = "PPMU_DMC0", "PPMU_DMC1";
+		clocks = <&clock CLK_PPMUDMC0>, <&clock CLK_PPMUDMC1>;
+		clock-names = "ppmudmc0", "ppmudmc1";
+
+		vdd_mif-suppy = <&buck1_reg>;
+		vdd_int-supply = <&buck3_reg>;
+	};
-- 
1.8.0

