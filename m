Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756450Ab3FLKTo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 06:19:44 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:16795 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756359Ab3FLKTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 06:19:39 -0400
X-AuditID: cbfee691-b7fef6d000002d62-50-51b84b355251
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
Subject: [PATCH V4 2/3] ARM: EXYNOS: Enable PCIe support for Exynos5440
Date: Wed, 12 Jun 2013 19:19:33 +0900
Message-id: <003701ce6756$551c4ed0$ff54ec70$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5nVlA5OK3B7pJVRIuJ6dyPxQluVA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNKsWRmVeSWpSXmKPExsVy+t8zfV1T7x2BBmcmK1k0/9/OavF30jF2
	iyVNGRYHZj9ktXh1ZiObxeWFl1gtvt8wtehdcJXNYtPja6wWl3fNYbM4O+84m8WM8/uYLFY0
	bWW0WHxxObPF7pVLWCyOzVjCaPH0QROTg6DHmnlrGD1+/5rE6NE35Sqbx5NNFxk9Fmwq9bhz
	bQ+bx+Yl9R7nZyxk9Pi+oxeoYMsqRo+fL3U8Pm+SC+CJ4rJJSc3JLEst0rdL4MqY+4ilYCpH
	xbzPH5gaGK+wdTFyckgImEg09x+FssUkLtxbD2RzcQgJLGOUaLu0nxGm6O/kPawQiUWMErcv
	bmOGcH4xSqzqgqhiE1CT+PLlMDuILSLgL3HtaisLSBGzwCRWiV8TLzGBJIQF3CXuPJ/GDGKz
	CKhK/F7UCxbnFbCUONE6jxXCFpT4MfkeC4jNLKAlsX7ncSYIW15i85q3zBAnKUjsOPuaEWKZ
	nsT7/5+hakQk9r14xwiyWELgBIfE8s9T2CGWCUh8m3wIaCgHUEJWYtMBqDmSEgdX3GCZwCg2
	C8nqWUhWz0KyehaSFQsYWVYxiqYWJBcUJ6UXmeoVJ+YWl+al6yXn525ihCSMiTsY7x+wPsSY
	DLR+IrOUaHI+MOHklcQbGpsZWZiamBobmVuakSasJM6r3mIdKCSQnliSmp2aWpBaFF9UmpNa
	fIiRiYNTqoFxzv0P+dO6XS0rPR3X171cHHtnR+sug8Nc2XOrVQVv15f3mH46u1n01GwZ9YWs
	exeKGvdlu5i2Tj18uEvy5Qldv9/H+4XVWq8V15iaPNzwY0fIw4QWH4ephybyuHzVUT5u8+jG
	aQm1gKjUG1nHP/1677KebwKjjt4v5U+LPjrrNPtKxsV9+sOsxFKckWioxVxUnAgAAD9K+S4D	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBKsWRmVeSWpSXmKPExsVy+t9jAV1T7x2BBjcWylg0/9/OavF30jF2
	iyVNGRYHZj9ktXh1ZiObxeWFl1gtvt8wtehdcJXNYtPja6wWl3fNYbM4O+84m8WM8/uYLFY0
	bWW0WHxxObPF7pVLWCyOzVjCaPH0QROTg6DHmnlrGD1+/5rE6NE35Sqbx5NNFxk9Fmwq9bhz
	bQ+bx+Yl9R7nZyxk9Pi+oxeoYMsqRo+fL3U8Pm+SC+CJamC0yUhNTEktUkjNS85PycxLt1Xy
	Do53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAH6S0mhLDGnFCgUkFhcrKRvh2lCaIibrgVM
	Y4Sub0gQXI+RARpIWMeYMfcRS8FUjop5nz8wNTBeYeti5OSQEDCR+Dt5DyuELSZx4d56oDgX
	h5DAIkaJ2xe3MUM4vxglVnXtZwSpYhNQk/jy5TA7iC0i4C9x7WorC0gRs8AkVolfEy8xgSSE
	Bdwl7jyfxgxiswioSvxe1AsW5xWwlDjROo8VwhaU+DH5HguIzSygJbF+53EmCFteYvOat8wQ
	JylI7Dj7mhFimZ7E+/+foWpEJPa9eMc4gVFgFpJRs5CMmoVk1CwkLQsYWVYxiqYWJBcUJ6Xn
	GukVJ+YWl+al6yXn525iBKejZ9I7GFc1WBxiFOBgVOLhPWC2PVCINbGsuDL3EKMEB7OSCG+V
	9o5AId6UxMqq1KL8+KLSnNTiQ4zJQJ9OZJYSTc4Hpsq8knhDYxMzI0sjMwsjE3Nz0oSVxHkP
	tloHCgmkJ5akZqemFqQWwWxh4uCUamB09n+62u1nmMC77w/clixTr2tJ1PUrSvodFTEt98KP
	khh10QtPSvadqt2xZvbOTfVrDRhyVjWu+hMhwfDAaokUs3fZRzWhl1amOzzXMfpnvD26osyc
	q9zkzB+djHTJ4wXXVJ/7/u0t4zunx+t48+nLOT9jvs2r+RcmsevFnrJox1Nxq24kSy5SYinO
	SDTUYi4qTgQAh7xV3YsDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable PCIe support for Exynos5440 which has two PCIe controllers.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
Tested on Exynos5440.

Changes since v3:
- Selected PCI_DOMAINS

 arch/arm/Kconfig             |    1 +
 arch/arm/mach-exynos/Kconfig |    2 ++
 2 files changed, 3 insertions(+)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 42d6ea2..53b3b2d 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1395,6 +1395,7 @@ config PCI_HOST_ITE8152
 	select DMABOUNCE
 
 source "drivers/pci/Kconfig"
+source "drivers/pci/pcie/Kconfig"
 
 source "drivers/pcmcia/Kconfig"
 
diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
index 6aa228d..773b5ee 100644
--- a/arch/arm/mach-exynos/Kconfig
+++ b/arch/arm/mach-exynos/Kconfig
@@ -78,6 +78,8 @@ config SOC_EXYNOS5440
 	select ARCH_HAS_OPP
 	select ARM_ARCH_TIMER
 	select AUTO_ZRELADDR
+	select MIGHT_HAVE_PCI
+	select PCI_DOMAINS if PCI
 	select PINCTRL
 	select PINCTRL_EXYNOS5440
 	select PM_OPP
-- 
1.7.10.4


