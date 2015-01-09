Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932789AbbAIQEz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 11:04:55 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:36283 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752293AbbAIQEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 11:04:53 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-a8-54affc220cdf
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Kukjin Kim <kgene@kernel.org>, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [RESEND PATCH] ARM: EXYNOS: Add missing static to file-scope
 declarations
Date: Fri, 09 Jan 2015 17:04:36 +0100
Message-id: <1420819476-23344-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHJMWRmVeSWpSXmKPExsVy+t/xy7pKf9aHGCyYZm3x+oWhRf/j18wW
	mx5fY7W4vGsOm8WM8/uYHFg9Nq3qZPPYvKTeo2/LKkaPz5vkAliiuGxSUnMyy1KL9O0SuDJe
	nTjNVHCOt+LhisMsDYyXubsYOTkkBEwk3rw7xgxhi0lcuLeerYuRi0NIYCmjxL3n+5khnD4m
	iS2da9lBqtgEjCU2L18CViUi0MUoMWvLbzaQBLOAocTPd3/AioQFQiTWTF8PFmcRUJV4cmU+
	I4jNK+Au0fH8NxPEOjmJk8cms05g5F7AyLCKUTS1NLmgOCk911CvODG3uDQvXS85P3cTIyQM
	vuxgXHzM6hCjAAejEg/vDtX1IUKsiWXFlbmHGCU4mJVEeBs2A4V4UxIrq1KL8uOLSnNSiw8x
	MnFwSjUwCmrdlJn2QtY03LCyliEyfOvVNzt4jP5WL4g6kPxKoTvTzX7CzGkzzpi9kbLrn3+E
	rdVg8dZ9k558DfCU5Toq/WHZQUUpA1HVoqSD1y95ZO7Jje1XfHW/1XF707ZlG56YOj5vy/0W
	V/bjZWX1lXUJRYu2X0gtSmUU1pCoKNFo5J2vXzw3a1uoEktxRqKhFnNRcSIAZn4ihOEBAAA=
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
index 342797b9bf3b..fef091f8e59f 100644
--- a/arch/arm/mach-exynos/suspend.c
+++ b/arch/arm/mach-exynos/suspend.c
@@ -75,7 +75,7 @@ struct exynos_pm_data {
 	int (*cpu_suspend)(unsigned long);
 };
 
-struct exynos_pm_data *pm_data;
+static struct exynos_pm_data *pm_data;
 
 static int exynos5420_cpu_state;
 static unsigned int exynos_pmu_spare3;
@@ -98,7 +98,7 @@ static const struct exynos_wkup_irq exynos5250_wkup_irq[] = {
 	{ /* sentinel */ },
 };
 
-unsigned int exynos_release_ret_regs[] = {
+static unsigned int exynos_release_ret_regs[] = {
 	S5P_PAD_RET_MAUDIO_OPTION,
 	S5P_PAD_RET_GPIO_OPTION,
 	S5P_PAD_RET_UART_OPTION,
@@ -109,7 +109,7 @@ unsigned int exynos_release_ret_regs[] = {
 	REG_TABLE_END,
 };
 
-unsigned int exynos5420_release_ret_regs[] = {
+static unsigned int exynos5420_release_ret_regs[] = {
 	EXYNOS_PAD_RET_DRAM_OPTION,
 	EXYNOS_PAD_RET_MAUDIO_OPTION,
 	EXYNOS_PAD_RET_JTAG_OPTION,
-- 
1.9.1

