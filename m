Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618AbaGNLZT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 07:25:19 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:31455 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754450AbaGNLZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 07:25:05 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-78-53c3be0e6176
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Russell King <linux@arm.linux.org.uk>, Kukjin Kim <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Tomasz Figa <t.figa@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Nicolas Pitre <nico@linaro.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>, stable@vger.kernel.org
Subject: [PATCH] ARM: EXYNOS: Fix MCPM build with SUSPEND=n
Date: Mon, 14 Jul 2014 13:24:53 +0200
Message-id: <1405337093-15377-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGJMWRmVeSWpSXmKPExsVy+t/xK7p8+w4HGxxq0LTYOGM9q8XrF4YW
	vQuuslmcbXrDbrHp8TVWi8u75rBZzDi/j8ni9mVei7VH7rJbTD/2l81iwcZHjBbrZ7xmceDx
	aGnuYfO4c20Pm8fmJfUefVtWMXp83iQXwBrFZZOSmpNZllqkb5fAldF17g17wXGOis+b9rE1
	MC5n72Lk5JAQMJG4fGY6lC0mceHeerYuRi4OIYGljBIvLncyQTh9TBK3O58ygVSxCRhLbF6+
	BKxKRGAHo8Tye5fZQRxmgSVMEit3HWQBqRIWsJaY97SLGcRmEVCVuDL3MdgOXgF3ibv7ZjJB
	7JOTOHlsMusERu4FjAyrGEVTS5MLipPScw31ihNzi0vz0vWS83M3MULC6ssOxsXHrA4xCnAw
	KvHwVogdDhZiTSwrrsw9xCjBwawkwiu1DijEm5JYWZValB9fVJqTWnyIkYmDU6qBUU8kbXHv
	mQPCCwKiJHorNi88scLnQapS/opQg9DXH13iQh/NsivOvXBc8+U3AfP/d1nYrNRXpgpekPBS
	KmYVtHteNzOf89AeTbMfNwoOH/6+qcc70EGfcal9WBaHrqai24veUrHqqX4/eReePS+hzjvr
	ctzl2BWR7LOt/mluuL5O/sh/zcgOJZbijERDLeai4kQAJVr0igkCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Building of EXYNOS5420_MCPM with disabled SUSPEND fails:
arch/arm/mach-exynos/built-in.o: In function `exynos_mcpm_init':
arch/arm/mach-exynos/mcpm-exynos.c:361: undefined reference to `mcpm_loopback'

The exynos_mcpm_init() in mcp-exynos.c calls mcpm_loopback() which
depends on cpu_suspend function (ARM_CPU_SUSPEND).

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: <stable@vger.kernel.org>
Fixes: a6a4d3152e3cbb6 ("ARM: 8083/1: exynos: activate the CCI on boot CPU/cluster using the MCPM loopback")
---
 arch/arm/mach-exynos/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
index 8f9b66c4ac78..5d4ff6571dcd 100644
--- a/arch/arm/mach-exynos/Kconfig
+++ b/arch/arm/mach-exynos/Kconfig
@@ -119,6 +119,7 @@ config EXYNOS5420_MCPM
 	bool "Exynos5420 Multi-Cluster PM support"
 	depends on MCPM && SOC_EXYNOS5420
 	select ARM_CCI
+	select ARM_CPU_SUSPEND
 	help
 	  This is needed to provide CPU and cluster power management
 	  on Exynos5420 implementing big.LITTLE.
-- 
1.9.1

