Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932224AbaLDMa7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 07:30:59 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:13097 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753959AbaLDMa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 07:30:56 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-93-548053fdb58f
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Russell King <linux@arm.linux.org.uk>, Kukjin Kim <kgene@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH] ARM: EXYNOS: Add missing static to file-scope declarations
Date: Thu, 04 Dec 2014 13:30:41 +0100
Message-id: <1417696241-26726-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGJMWRmVeSWpSXmKPExsVy+t/xq7p/gxtCDLomGFtsnLGe1eL1C0OL
	/sevmS3ONr1ht9j0+BqrxeVdc9gsZpzfx2Rx+zKvxdojd9kdOD1amnvYPDat6mTz2Lyk3qNv
	yypGj8+b5AJYo7hsUlJzMstSi/TtErgy3s3qZyu4wFvx5k0PcwPjVe4uRk4OCQETia7We+wQ
	tpjEhXvr2boYuTiEBJYyShyeOJ0ZJCEk0Mck0dJaC2KzCRhLbF6+BKxIRGAzo0R/425WEIdZ
	4CijxPTet0wgVcIC3hJfz2xiAbFZBFQlXmy4zQpi8wq4S9zf/ZMFYp2cxMljk1knMHIvYGRY
	xSiaWppcUJyUnmuoV5yYW1yal66XnJ+7iRESNl92MC4+ZnWIUYCDUYmHd8HT+hAh1sSy4src
	Q4wSHMxKIrxavg0hQrwpiZVVqUX58UWlOanFhxiZODilGhiNNpaxVb/NaN59O2GN68QFon8/
	ternznxT+8NkN/8kV/f7pTOt5ttX7t8i3Nv81fmsRL7779bf1/k11q9J8G8x/xC90iKUIap1
	sss7hskF0cvnVxxpEMzh1XBMU9wmKd9i+5P5qZWypurbEnXjV7+zo+X5TKzdDKU856yf+zGO
	eT7zjuNvs5RYijMSDbWYi4oTARHra835AQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'pm_data', 'exynos_release_ret_regs' and
'exynos5420_release_ret_regs' are not exported nor used outside of
suspend.c file. Make them static.

This fixes following sparse warnings:
arch/arm/mach-exynos/suspend.c:83:23: warning: symbol 'pm_data' was not declared. Should it be static?
arch/arm/mach-exynos/suspend.c:106:14: warning: symbol 'exynos_release_ret_regs' was not declared. Should it be static?
arch/arm/mach-exynos/suspend.c:117:14: warning: symbol 'exynos5420_release_ret_regs' was not declared. Should it be static?

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 arch/arm/mach-exynos/suspend.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-exynos/suspend.c b/arch/arm/mach-exynos/suspend.c
index f8e7dcd17055..6131c16a4a5d 100644
--- a/arch/arm/mach-exynos/suspend.c
+++ b/arch/arm/mach-exynos/suspend.c
@@ -80,7 +80,7 @@ struct exynos_pm_data {
 	int (*cpu_suspend)(unsigned long);
 };
 
-struct exynos_pm_data *pm_data;
+static struct exynos_pm_data *pm_data;
 
 static int exynos5420_cpu_state;
 static unsigned int exynos_pmu_spare3;
@@ -103,7 +103,7 @@ static const struct exynos_wkup_irq exynos5250_wkup_irq[] = {
 	{ /* sentinel */ },
 };
 
-unsigned int exynos_release_ret_regs[] = {
+static unsigned int exynos_release_ret_regs[] = {
 	S5P_PAD_RET_MAUDIO_OPTION,
 	S5P_PAD_RET_GPIO_OPTION,
 	S5P_PAD_RET_UART_OPTION,
@@ -114,7 +114,7 @@ unsigned int exynos_release_ret_regs[] = {
 	REG_TABLE_END,
 };
 
-unsigned int exynos5420_release_ret_regs[] = {
+static unsigned int exynos5420_release_ret_regs[] = {
 	EXYNOS_PAD_RET_DRAM_OPTION,
 	EXYNOS_PAD_RET_MAUDIO_OPTION,
 	EXYNOS_PAD_RET_JTAG_OPTION,
-- 
1.9.1

