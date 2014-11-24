Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565AbaKXNMl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 08:12:41 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:35630 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786AbaKXNMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 08:12:39 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-99-54732ec4ca13
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org
Cc: kgene.kim@samsung.com, linux-kernel@vger.kernel.org,
        s.nawrocki@samsung.com, pankaj.dubey@samsung.com,
        ulf.hansson@linaro.org, khilman@kernel.org, linux-pm@vger.kernel.org,
        geert@linux-m68k.org, rjw@rjwysocki.net, devicetree@vger.kernel.org,
        Amit Daniel Kachhap <amit.daniel@samsung.com>
Subject: [PATCH RFC v2 02/12] soc: exynos: Move exynos power domain file to
 driver/soc/samsung folder
Date: Mon, 24 Nov 2014 18:34:06 +0530
Message-id: <1416834256-11225-2-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1416834256-11225-1-git-send-email-amit.daniel@samsung.com>
References: <1416833572-6880-1-git-send-email-amit.daniel@samsung.com>
 <1416834256-11225-1-git-send-email-amit.daniel@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgkeLIzCtJLcpLzFFi42JZI2JSpXtErzjEYPEmHYuGqyEW84+cY7V4
	dmsvk0XvgqtsFk83P2ay2PT4GqvF5V1z2Cw+9x5htJhxfh+TxaKtX9gtzpy+xGpx+E07q8Xx
	teEOvB6bVnWyedy5tofN49DhDkaPzUvqPbZcbWfx6NuyitHj8ya5APYoLpuU1JzMstQifbsE
	rozlrxaxFtwVqvg+5Tx7A+MW/i5GTg4JAROJ/7Pfs0DYYhIX7q1n62Lk4hASWMoo0XFtMStM
	0e+5D1khEtMZJc5tvMkE4Uxgkpg2cQIzSBWbgLHEz5372bsYOThEBLwlll9TBKlhFljNJLG1
	/QMTSFxYIF3izeoKkHIWAVWJTSd3gG3mFXCXeHbtBzNIiYSAgsScSTYgYU4BD4kXB1uYIVa1
	MEpcejwX7AgJgWvsEm/v9LJBDBKQ+Db5EAtEs6zEpgPMEEdLShxccYNlAqPwAkaGVYyiqQXJ
	BcVJ6UUmesWJucWleel6yfm5mxiBEXP637MJOxjvHbA+xCjAwajEw/thY1GIEGtiWXFl7iFG
	U6ANE5mlRJPzgXGZVxJvaGxmZGFqYmpsZG5ppiTO+1rqZ7CQQHpiSWp2ampBalF8UWlOavEh
	RiYOTqkGRsVcvuMzY9T9uIU9NVvvbbdOPrPrrJtU751ts6vrfr942nFeX1m+iPtYXmj3I8ll
	KhPMYt/JXui6953tf1h2ZXIw+9yjj9x+67z5PWVXOtPkO9qZ58IK/cu+X9/TWLv2fOSbPXtq
	Dwn2RMe2OG3Lj4yw65kRI7UqLUJ4Zkjppnmqk7mWnFYKUWIpzkg01GIuKk4EAIl6I9CTAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsVy+t9jQd0jesUhBlPvKVk0XA2xmH/kHKvF
	s1t7mSx6F1xls3i6+TGTxabH11gtLu+aw2bxufcIo8WM8/uYLBZt/cJuceb0JVaLw2/aWS2O
	rw134PXYtKqTzePOtT1sHocOdzB6bF5S77HlajuLR9+WVYwenzfJBbBHNTDaZKQmpqQWKaTm
	JeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gAdq6RQlphTChQKSCwuVtK3
	wzQhNMRN1wKmMULXNyQIrsfIAA0krGHMWP5qEWvBXaGK71POszcwbuHvYuTkkBAwkfg99yEr
	hC0mceHeerYuRi4OIYHpjBLnNt5kgnAmMElMmziBGaSKTcBY4ufO/exdjBwcIgLeEsuvKYLU
	MAusZpLY2v6BCSQuLJAu8WZ1BUg5i4CqxKaTO1hAbF4Bd4ln134wg5RICChIzJlkAxLmFPCQ
	eHGwhRliVQujxKXHc1knMPIuYGRYxSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iREcj8+kdzCu
	arA4xCjAwajEwztjfVGIEGtiWXFl7iFGCQ5mJRFeMbHiECHelMTKqtSi/Pii0pzU4kOMpkBX
	TWSWEk3OB6aKvJJ4Q2MTc1NjU0sTCxMzSyVx3hs3c0OEBNITS1KzU1MLUotg+pg4OKUaGE2E
	lzTVbxePX/mLt+916if9jmvz1moXsq9fqZz86tVF8V0pqf7LHxs2pRanmkazasiv/pm/S2eP
	sj17Xm3b/I/HLRMyqtt/l+75+OYls/ep9TK7p6yUNbSZpjXz599XPodq8r+/Uvgt/vnvlFem
	ladEnhhbeyQ0R3/ZUB9cKvG36UBosc2+MiWW4oxEQy3mouJEAPavO1PdAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves arch/arm/mach-exynos/pm_domains.c to driver/soc/samsung
folder. In this way it can be used for both arm and arm64 platforms.
This file is moved in this directory as this driver is soc specific and
only used by exynos platforms.

Cc: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
 arch/arm/mach-exynos/Makefile                      |    1 -
 drivers/soc/samsung/Kconfig                        |    9 +++++++++
 drivers/soc/samsung/Makefile                       |    3 ++-
 .../soc/samsung}/pm_domains.c                      |    0
 4 files changed, 11 insertions(+), 2 deletions(-)
 rename {arch/arm/mach-exynos => drivers/soc/samsung}/pm_domains.c (100%)

diff --git a/arch/arm/mach-exynos/Makefile b/arch/arm/mach-exynos/Makefile
index b91b382..9ea6c54 100644
--- a/arch/arm/mach-exynos/Makefile
+++ b/arch/arm/mach-exynos/Makefile
@@ -13,7 +13,6 @@ obj-$(CONFIG_ARCH_EXYNOS)	+= exynos.o exynos-smc.o firmware.o
 
 obj-$(CONFIG_EXYNOS_CPU_SUSPEND) += pm.o sleep.o
 obj-$(CONFIG_PM_SLEEP)		+= suspend.o
-obj-$(CONFIG_PM_GENERIC_DOMAINS) += pm_domains.o
 
 obj-$(CONFIG_SMP)		+= platsmp.o headsmp.o
 
diff --git a/drivers/soc/samsung/Kconfig b/drivers/soc/samsung/Kconfig
index 6855cc4..2bb33e7 100644
--- a/drivers/soc/samsung/Kconfig
+++ b/drivers/soc/samsung/Kconfig
@@ -17,4 +17,13 @@ config EXYNOS_PMU
 	  functionality like initialisation and transition to various low power
 	  states.
 
+config EXYNOS_POWER_DOMAIN
+	tristate "Support Exynos PM Power Domain"
+	depends on ARCH_EXYNOS && PM_GENERIC_DOMAINS
+	default y
+	help
+	  Exynos SOC have power domain gating support. This driver implements
+	  that functionality and registers all the necessary hooks to the
+	  generic power domain core kernel infrastructure.
+
 endmenu
diff --git a/drivers/soc/samsung/Makefile b/drivers/soc/samsung/Makefile
index 5a879c6..61ccd51 100644
--- a/drivers/soc/samsung/Makefile
+++ b/drivers/soc/samsung/Makefile
@@ -1 +1,2 @@
-obj-$(CONFIG_EXYNOS_PMU)	+= exynos-pmu.o
+obj-$(CONFIG_EXYNOS_PMU)		+= exynos-pmu.o
+obj-$(CONFIG_EXYNOS_POWER_DOMAIN)	+= pm_domains.o
diff --git a/arch/arm/mach-exynos/pm_domains.c b/drivers/soc/samsung/pm_domains.c
similarity index 100%
rename from arch/arm/mach-exynos/pm_domains.c
rename to drivers/soc/samsung/pm_domains.c
-- 
1.7.9.5

