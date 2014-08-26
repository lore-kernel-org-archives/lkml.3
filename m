Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758295AbaHZOKv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 10:10:51 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:41715 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758160AbaHZOKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 10:10:47 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-7f-53fc95642a2d
From: Tomasz Figa <t.figa@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, Arnd Bergmann <arnd@arndb.de>,
        swarren@nvidia.com, acourbot@nvidia.com,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Olof Johansson <olof@lixom.net>,
        drake@endlessm.com, tomeu@tomeuvizoso.net,
        Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH v3 3/5] ARM: dts: exynos4412-trats2: Keep eMMC regulators
 soft-disabled
Date: Tue, 26 Aug 2014 16:10:26 +0200
Message-id: <1409062228-14690-4-git-send-email-t.figa@samsung.com>
X-Mailer: git-send-email 2.0.4
In-reply-to: <1409062228-14690-1-git-send-email-t.figa@samsung.com>
References: <1409062228-14690-1-git-send-email-t.figa@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHLMWRmVeSWpSXmKPExsVy+t/xq7opU/8EG/TfE7f4/vAUq8XfScfY
	LR7Nf8xs0bvgKpvFpsfXWC0u75rDZjHj/D4mi9uXeS3WHrnLbnHq+mc2ixvTW1gt1s94zWKx
	atcfRovLjWYOfB4tzT1sHr9/TWL0WPQ9y2PnrLvsHpuX1HtcOdHE6tHb/I7No2/LKkaPo3/Z
	PD5vkgvgiuKySUnNySxLLdK3S+DKmDPxHmPBOa6K7ocb2RsY93J0MXJySAiYSPzefI8NwhaT
	uHBvPZDNxSEksJRRoq9/J5TTxyTx8P5isCo2ATWJzw2PwGwRAVWJz20L2EGKmAU2Mkv8+DuB
	HSQhLBApsfX+G7AiFqCibdNPgsV5BZwkjr++zAqxTk5i1cZ9TCA2p4CzxM8nW8HiQkA1ex+u
	Zp3AyLuAkWEVo2hqaXJBcVJ6rpFecWJucWleul5yfu4mRkgYf93BuPSY1SFGAQ5GJR7eB2m/
	g4VYE8uKK3MPMUpwMCuJ8P5I+hMsxJuSWFmVWpQfX1Sak1p8iJGJg1OqgdFJZuczTh2p/O6m
	o/OLfjwLu756Rsj9V8f2Ra6tdllb9kF06ZaNl2+zWhf2MWTN3tSi11n++P6MJO7OaRtaS3Y7
	VHKaJic/3KIi5Sbr/iFMu83ay/uw2muxWkYvdQ8mpVoZbXuzPXlrL7Psm/Qlw/zN56/vVI5o
	BQe39ImcuXej8MnsgoA+eSWW4oxEQy3mouJEAJSVA5ZBAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In MAX77686 PMIC two regulators dedicated for eMMC memory can be
controlled both by I2C interface and a GPIO pin, with the resulting
regulator state being a logical OR of both. Since the GPIO control is
used both by the kernel and the lowest level bootloader at reset, the
regulator should be disabled by I2C control to allow it to be turned off
by GPIO control.

This patch removes regulator-always-on properties from both regulators
and, while at it, also unsupported regulator-mem-off.

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
---
 arch/arm/boot/dts/exynos4412-trats2.dts | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/arm/boot/dts/exynos4412-trats2.dts b/arch/arm/boot/dts/exynos4412-trats2.dts
index 5e066cd..a75034c 100644
--- a/arch/arm/boot/dts/exynos4412-trats2.dts
+++ b/arch/arm/boot/dts/exynos4412-trats2.dts
@@ -399,8 +399,6 @@
 					regulator-name = "VMEM_VDD_2.8V";
 					regulator-min-microvolt = <2800000>;
 					regulator-max-microvolt = <2800000>;
-					regulator-always-on;
-					regulator-mem-off;
 				};
 
 				ldo23_reg: ldo23 {
@@ -503,8 +501,6 @@
 					regulator-name = "VMEM_VDDF_3.0V";
 					regulator-min-microvolt = <2850000>;
 					regulator-max-microvolt = <2850000>;
-					regulator-always-on;
-					regulator-mem-off;
 				};
 
 				buck9_reg: buck9 {
-- 
2.0.4

