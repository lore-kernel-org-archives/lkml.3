Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160Ab3FTHLr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 03:11:47 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:22436 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359Ab3FTHLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 03:11:45 -0400
X-AuditID: cbfee691-b7fef6d000002d62-a0-51c2ab2fbd89
From: Jingoo Han <jg1.han@samsung.com>
To: "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-pci@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Andrew Murray'" <andrew.murray@arm.com>,
        "'Thomas Petazzoni'" <thomas.petazzoni@free-electrons.com>,
        "'Thierry Reding'" <thierry.reding@avionic-design.de>,
        "'Jason Gunthorpe'" <jgunthorpe@obsidianresearch.com>,
        "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Surendranath Gurivireddy Balla'" <suren.reddy@samsung.com>,
        "'Siva Reddy Kallam'" <siva.kallam@samsung.com>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH V6 2/3] ARM: EXYNOS: Enable PCIe support for Exynos5440
Date: Thu, 20 Jun 2013 16:11:42 +0900
Message-id: <00c101ce6d85$6aab9230$4002b690$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5thWgQTTJizKGYQlmBD0dyL+5XuA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJKsWRmVeSWpSXmKPExsVy+t8zA1391YcCDb7eFrdo/r+d1eLvpGPs
	FkuaMiwOzH7IavHqzEY2i8sLL7FafL9hatG74CqbxabH11gtLu+aw2Zxdt5xNosZ5/cxWaxo
	2sposfjicmaL3SuXsFgcm7GE0eLpgyYmB0GPNfPWMHr8/jWJ0aNvylU2jyebLjJ6LNhU6nHn
	2h42j81L6j3Oz1jI6PF9Ry9QwZZVjB4/X+p4fN4kF8ATxWWTkpqTWZZapG+XwJXxb/sxtoJT
	7BX3Xro3MM5i62Lk4JAQMJE4NV+ii5ETyBSTuHBvPVCYi0NIYBmjxJLbB9kgEiYS+1d/ZYVI
	LGKUaD9zihkkISTwi1Hi7xFlEJtNQE3iy5fD7CC2iIC/xLWrrSwgDcwCk1glfk28xASSEBZw
	l+h4fowVxGYRUJW4uWg/2AZeAUuJZc+PMELYghI/Jt9jAbGZBbQk1u88zgRhy0tsXvOWGeIi
	BYkdZ18zQizTk3jy/Cg7RI2IxL4X7xhBFksInOCQWD3lFzPEMgGJb5MPsUC8LCux6QDUHEmJ
	gytusExgFJuFZPUsJKtnIVk9C8mKBYwsqxhFUwuSC4qT0otM9YoTc4tL89L1kvNzNzFCksXE
	HYz3D1gfYkwGWj+RWUo0OR+YbPJK4g2NzYwsTE1MjY3MLc1IE1YS51VvsQ4UEkhPLEnNTk0t
	SC2KLyrNSS0+xMjEwSnVwBjlIeNlaqeU1br4frieaYXeHKO93lxhaz+/+vGhOfL2I40owV2R
	yjPfl9Yf47gbLfFVLf+1yuaQeYnaF0Odd635xll6ds7fA2IK+0zDHXap3D7sOfNb+okJHmZv
	OYNEn3w6sCGjv2Lf2cYY0cWMmWWi9fMEkhaqyLyzlkqd43GmJ3A+W/G3GCWW4oxEQy3mouJE
	AFsfyUMsAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOKsWRmVeSWpSXmKPExsVy+t9jAV391YcCDf69FrRo/r+d1eLvpGPs
	FkuaMiwOzH7IavHqzEY2i8sLL7FafL9hatG74CqbxabH11gtLu+aw2Zxdt5xNosZ5/cxWaxo
	2sposfjicmaL3SuXsFgcm7GE0eLpgyYmB0GPNfPWMHr8/jWJ0aNvylU2jyebLjJ6LNhU6nHn
	2h42j81L6j3Oz1jI6PF9Ry9QwZZVjB4/X+p4fN4kF8AT1cBok5GamJJapJCal5yfkpmXbqvk
	HRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQP0l5JCWWJOKVAoILG4WEnfDtOE0BA3XQuY
	xghd35AguB4jAzSQsI4x49/2Y2wFp9gr7r10b2CcxdbFyMkhIWAisX/1V1YIW0ziwr31QHEu
	DiGBRYwS7WdOMYMkhAR+MUr8PaIMYrMJqEl8+XKYHcQWEfCXuHa1lQWkgVlgEqvEr4mXmEAS
	wgLuEh3Pj4FNZRFQlbi5aD/YNl4BS4llz48wQtiCEj8m32MBsZkFtCTW7zzOBGHLS2xe85YZ
	4iIFiR1nXzNCLNOTePL8KDtEjYjEvhfvGCcwCsxCMmoWklGzkIyahaRlASPLKkbR1ILkguKk
	9FxDveLE3OLSvHS95PzcTYzgZPRMagfjygaLQ4wCHIxKPLwalw8GCrEmlhVX5h5ilOBgVhLh
	TZ1zKFCINyWxsiq1KD++qDQntfgQYzLQpxOZpUST84GJMq8k3tDYxMzI0sjMwsjE3Jw0YSVx
	3gOt1oFCAumJJanZqakFqUUwW5g4OKUaGHefW/qWn1nxUaJv39qiqS0uUlEffx/bwr936tMP
	+xNsP3LWWaw8fVvebLmdVjy3dsM9/bWmha5Oz1oecmlfV9YzeJPF+Cn7g8nNTWsMX0sbZO1Y
	eyU42c3tVWn3V+Zao4qlhVOzAx0/y7jZnn1os91g8f5Qr19i/k88t4X8/+PIvEjwfH3/fyWW
	4oxEQy3mouJEAFnDg9OKAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable PCIe support for Exynos5440 which has two PCIe controllers.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 arch/arm/Kconfig             |    1 +
 arch/arm/mach-exynos/Kconfig |    2 ++
 2 files changed, 3 insertions(+)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 804f41d..098eaef 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1427,6 +1427,7 @@ config PCI_HOST_ITE8152
 	select DMABOUNCE
 
 source "drivers/pci/Kconfig"
+source "drivers/pci/pcie/Kconfig"
 
 source "drivers/pcmcia/Kconfig"
 
diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
index 359af2c..f5f65b5 100644
--- a/arch/arm/mach-exynos/Kconfig
+++ b/arch/arm/mach-exynos/Kconfig
@@ -95,6 +95,8 @@ config SOC_EXYNOS5440
 	select ARCH_HAS_OPP
 	select HAVE_ARM_ARCH_TIMER
 	select AUTO_ZRELADDR
+	select MIGHT_HAVE_PCI
+	select PCI_DOMAINS if PCI
 	select PINCTRL_EXYNOS5440
 	select PM_OPP
 	help
-- 
1.7.10.4


