Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965226Ab3FTJde (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 05:33:34 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:52407 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935296Ab3FTJdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 05:33:32 -0400
X-AuditID: cbfee68f-b7f436d000000f81-a3-51c2cc6b5394
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
Subject: [PATCH V7 2/4] ARM: EXYNOS: Enable PCIe support for Exynos5440
Date: Thu, 20 Jun 2013 18:33:30 +0900
Message-id: <00cc01ce6d99$39f0a860$add1f920$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5tmTf6PyhGHGrqTie7bpjA+2u/bQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNKsWRmVeSWpSXmKPExsVy+t8zA93sM4cCDT5/F7Zo/r+d1eLvpGPs
	FkuaMiwOzH7IavHqzEY2i8sLL7FafL9hatG74CqbxabH11gtLu+aw2Zxdt5xNosZ5/cxWaxo
	2sposfjicmaL3SuXsFgcm7GE0eLpgyYmB0GPNfPWMHr8/jWJ0aNvylU2jyebLjJ6LNhU6nHn
	2h42j81L6j3Oz1jI6PF9Ry9QwZZVjB4/X+p4fN4kF8ATxWWTkpqTWZZapG+XwJXxb/sxtoJT
	7BX3Xro3MM5i62Lk5JAQMJH41nyZEcIWk7hwbz1QnItDSGAZo8Sv7mesMEVHb+xlgkgsYpT4
	vv0hC4Tzi1HiYsN2sHY2ATWJL18Os4PYIgL+EteutoIVMQtMYpX4NfESE0hCWMBd4seW/2BF
	LAKqEv/vP2cGsXkFLCU+X7jHDmELSvyYfI8FxGYW0JJYv/M4E4QtL7F5zVtmiJMUJHacfc0I
	sUxP4tuNA4wQNSIS+168YwRZLCFwgkNi0elbjBDLBCS+TT4ENJQDKCErsekA1BxJiYMrbrBM
	YBSbhWT1LCSrZyFZPQvJigWMLKsYRVMLkguKk9KLjPWKE3OLS/PS9ZLzczcxQhJG/w7Guwes
	DzEmA62fyCwlmpwPTDh5JfGGxmZGFqYmpsZG5pZmpAkrifOqtVgHCgmkJ5akZqemFqQWxReV
	5qQWH2Jk4uCUamAsFM2Pf1h6dV6NuuiZ3389fcsr1q5Tum+fdccoonX/Bb5FHF5bvDPWSEp9
	bCj7uNpX6W9TuO/JF7r5JR5bcxscNpZ2m2X3ZIjPujw95Rz7IrX9ppwdDRmHk/Xf+ukv/7zs
	dGe0D7/I1qa0VsuTYr7eb9hvalRev39bqnW3fLXnv8/n5JzyC5RYijMSDbWYi4oTAcAZgPQu	AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBKsWRmVeSWpSXmKPExsVy+t9jAd3sM4cCDZ7P4rNo/r+d1eLvpGPs
	FkuaMiwOzH7IavHqzEY2i8sLL7FafL9hatG74CqbxabH11gtLu+aw2Zxdt5xNosZ5/cxWaxo
	2sposfjicmaL3SuXsFgcm7GE0eLpgyYmB0GPNfPWMHr8/jWJ0aNvylU2jyebLjJ6LNhU6nHn
	2h42j81L6j3Oz1jI6PF9Ry9QwZZVjB4/X+p4fN4kF8AT1cBok5GamJJapJCal5yfkpmXbqvk
	HRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQP0l5JCWWJOKVAoILG4WEnfDtOE0BA3XQuY
	xghd35AguB4jAzSQsI4x49/2Y2wFp9gr7r10b2CcxdbFyMkhIWAicfTGXiYIW0ziwr31QHEu
	DiGBRYwS37c/ZIFwfjFKXGzYzghSxSagJvHly2F2EFtEwF/i2tVWsCJmgUmsEr8mXgIbJSzg
	LvFjy3+wIhYBVYn/958zg9i8ApYSny/cY4ewBSV+TL7HAmIzC2hJrN95nAnClpfYvOYtM8RJ
	ChI7zr5mhFimJ/HtxgFGiBoRiX0v3jFOYBSYhWTULCSjZiEZNQtJywJGllWMoqkFyQXFSem5
	hnrFibnFpXnpesn5uZsYwenomdQOxpUNFocYBTgYlXh4NS4fDBRiTSwrrsw9xCjBwawkwps6
	51CgEG9KYmVValF+fFFpTmrxIcZkoE8nMkuJJucDU2VeSbyhsYmZkaWRmYWRibk5acJK4rwH
	Wq0DhQTSE0tSs1NTC1KLYLYwcXBKNTAWMDq9EuF6rlLKqvR9enCipEPbY40bqsf6u6W/b9Cr
	Vr/7z+FSfYJZR6/LHHXVIH3n6Qs3Cf00sMws+DQlYPYS+0n57NXiV1N8k68cX/DbqfFXXE23
	ZJJBaUeaXnl52g3vFy5LReYZzXowmaPBf7ZHzYto+XlRupmrVrjsMFxa8/bhjrfPtimxFGck
	GmoxFxUnAgDCgsvgiwMAAA==
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


