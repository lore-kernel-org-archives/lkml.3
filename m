Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709Ab3KTSVt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 13:21:49 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:62732 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753729Ab3KTSVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 13:21:42 -0500
From: Daniel Kurtz <djkurtz@chromium.org>
To: Russell King <linux@arm.linux.org.uk>, Kukjin Kim <kgene.kim@samsung.com>,
        Ben Dooks <ben-linux@fluff.org>
Cc: Tomasz Figa <t.figa@samsung.com>, Heiko Stuebner <heiko@sntech.de>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Doug Andersen <dianders@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 1/3] ARM: EXYNOS: pmu: Constify data tables
Date: Thu, 21 Nov 2013 02:21:24 +0800
Message-Id: <1384971686-7208-1-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.8.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These tables are all immutable, make them const to save 4416 bytes of RAM.

size arch/arm/mach-exynos/pmu.o
   text	   data	    bss
    848	   4420	      4		// before
   5264	      4	      4		// after

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 arch/arm/mach-exynos/pmu.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/arm/mach-exynos/pmu.c b/arch/arm/mach-exynos/pmu.c
index 97d6885..6609145 100644
--- a/arch/arm/mach-exynos/pmu.c
+++ b/arch/arm/mach-exynos/pmu.c
@@ -17,9 +17,9 @@
 
 #include "common.h"
 
-static struct exynos_pmu_conf *exynos_pmu_config;
+static const struct exynos_pmu_conf *exynos_pmu_config;
 
-static struct exynos_pmu_conf exynos4210_pmu_config[] = {
+static const struct exynos_pmu_conf exynos4210_pmu_config[] = {
 	/* { .reg = address, .val = { AFTR, LPA, SLEEP } */
 	{ S5P_ARM_CORE0_LOWPWR,			{ 0x0, 0x0, 0x2 } },
 	{ S5P_DIS_IRQ_CORE0,			{ 0x0, 0x0, 0x0 } },
@@ -95,7 +95,7 @@ static struct exynos_pmu_conf exynos4210_pmu_config[] = {
 	{ PMU_TABLE_END,},
 };
 
-static struct exynos_pmu_conf exynos4x12_pmu_config[] = {
+static const struct exynos_pmu_conf exynos4x12_pmu_config[] = {
 	{ S5P_ARM_CORE0_LOWPWR,			{ 0x0, 0x0, 0x2 } },
 	{ S5P_DIS_IRQ_CORE0,			{ 0x0, 0x0, 0x0 } },
 	{ S5P_DIS_IRQ_CENTRAL0,			{ 0x0, 0x0, 0x0 } },
@@ -203,7 +203,7 @@ static struct exynos_pmu_conf exynos4x12_pmu_config[] = {
 	{ PMU_TABLE_END,},
 };
 
-static struct exynos_pmu_conf exynos4412_pmu_config[] = {
+static const struct exynos_pmu_conf exynos4412_pmu_config[] = {
 	{ S5P_ARM_CORE2_LOWPWR,			{ 0x0, 0x0, 0x2 } },
 	{ S5P_DIS_IRQ_CORE2,			{ 0x0, 0x0, 0x0 } },
 	{ S5P_DIS_IRQ_CENTRAL2,			{ 0x0, 0x0, 0x0 } },
@@ -213,7 +213,7 @@ static struct exynos_pmu_conf exynos4412_pmu_config[] = {
 	{ PMU_TABLE_END,},
 };
 
-static struct exynos_pmu_conf exynos5250_pmu_config[] = {
+static const struct exynos_pmu_conf exynos5250_pmu_config[] = {
 	/* { .reg = address, .val = { AFTR, LPA, SLEEP } */
 	{ EXYNOS5_ARM_CORE0_SYS_PWR_REG,		{ 0x0, 0x0, 0x2} },
 	{ EXYNOS5_DIS_IRQ_ARM_CORE0_LOCAL_SYS_PWR_REG,	{ 0x0, 0x0, 0x0} },
@@ -317,7 +317,7 @@ static struct exynos_pmu_conf exynos5250_pmu_config[] = {
 	{ PMU_TABLE_END,},
 };
 
-static void __iomem *exynos5_list_both_cnt_feed[] = {
+static void __iomem * const exynos5_list_both_cnt_feed[] = {
 	EXYNOS5_ARM_CORE0_OPTION,
 	EXYNOS5_ARM_CORE1_OPTION,
 	EXYNOS5_ARM_COMMON_OPTION,
@@ -331,7 +331,7 @@ static void __iomem *exynos5_list_both_cnt_feed[] = {
 	EXYNOS5_TOP_PWR_SYSMEM_OPTION,
 };
 
-static void __iomem *exynos5_list_diable_wfi_wfe[] = {
+static void __iomem * const exynos5_list_diable_wfi_wfe[] = {
 	EXYNOS5_ARM_CORE1_OPTION,
 	EXYNOS5_FSYS_ARM_OPTION,
 	EXYNOS5_ISP_ARM_OPTION,
-- 
1.8.4.1

