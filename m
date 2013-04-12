Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752515Ab3DLFzb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 01:55:31 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:33132 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370Ab3DLFza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 01:55:30 -0400
Message-ID: <1365746124.4025.2.camel@phoenix>
Subject: [RESEND][PATCH 2/3] PM / devfreq: exynos4_bus: Constify clock
 divider table
From: Axel Lin <axel.lin@ingics.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 12 Apr 2013 13:55:24 +0800
In-Reply-To: <1365746058.4025.1.camel@phoenix>
References: <1365746058.4025.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These tables are never modified, make them const.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/devfreq/exynos4_bus.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/devfreq/exynos4_bus.c b/drivers/devfreq/exynos4_bus.c
index 3f37f3b..45d00d1 100644
--- a/drivers/devfreq/exynos4_bus.c
+++ b/drivers/devfreq/exynos4_bus.c
@@ -177,7 +177,7 @@ static unsigned int exynos4x12_int_volt[][EX4x12_LV_NUM] = {
 };
 
 /*** Clock Divider Data for Exynos4210 ***/
-static unsigned int exynos4210_clkdiv_dmc0[][8] = {
+static const unsigned int exynos4210_clkdiv_dmc0[][8] = {
 	/*
 	 * Clock divider value for following
 	 * { DIVACP, DIVACP_PCLK, DIVDPHY, DIVDMC, DIVDMCD
@@ -191,7 +191,7 @@ static unsigned int exynos4210_clkdiv_dmc0[][8] = {
 	/* DMC L2: 133MHz */
 	{ 5, 1, 1, 5, 1, 1, 3, 1 },
 };
-static unsigned int exynos4210_clkdiv_top[][5] = {
+static const unsigned int exynos4210_clkdiv_top[][5] = {
 	/*
 	 * Clock divider value for following
 	 * { DIVACLK200, DIVACLK100, DIVACLK160, DIVACLK133, DIVONENAND }
@@ -203,7 +203,7 @@ static unsigned int exynos4210_clkdiv_top[][5] = {
 	/* ACLK200 L2: 133MHz */
 	{ 5, 7, 7, 7, 1 },
 };
-static unsigned int exynos4210_clkdiv_lr_bus[][2] = {
+static const unsigned int exynos4210_clkdiv_lr_bus[][2] = {
 	/*
 	 * Clock divider value for following
 	 * { DIVGDL/R, DIVGPL/R }
@@ -217,7 +217,7 @@ static unsigned int exynos4210_clkdiv_lr_bus[][2] = {
 };
 
 /*** Clock Divider Data for Exynos4212/4412 ***/
-static unsigned int exynos4x12_clkdiv_dmc0[][6] = {
+static const unsigned int exynos4x12_clkdiv_dmc0[][6] = {
 	/*
 	 * Clock divider value for following
 	 * { DIVACP, DIVACP_PCLK, DIVDPHY, DIVDMC, DIVDMCD
@@ -235,7 +235,7 @@ static unsigned int exynos4x12_clkdiv_dmc0[][6] = {
 	/* DMC L4: 100MHz */
 	{7, 1, 1, 7, 1, 1},
 };
-static unsigned int exynos4x12_clkdiv_dmc1[][6] = {
+static const unsigned int exynos4x12_clkdiv_dmc1[][6] = {
 	/*
 	 * Clock divider value for following
 	 * { G2DACP, DIVC2C, DIVC2C_ACLK }
@@ -252,7 +252,7 @@ static unsigned int exynos4x12_clkdiv_dmc1[][6] = {
 	/* DMC L4: 100MHz */
 	{7, 7, 1},
 };
-static unsigned int exynos4x12_clkdiv_top[][5] = {
+static const unsigned int exynos4x12_clkdiv_top[][5] = {
 	/*
 	 * Clock divider value for following
 	 * { DIVACLK266_GPS, DIVACLK100, DIVACLK160,
@@ -270,7 +270,7 @@ static unsigned int exynos4x12_clkdiv_top[][5] = {
 	/* ACLK_GDL/R L4: 100MHz */
 	{7, 7, 7, 7, 1},
 };
-static unsigned int exynos4x12_clkdiv_lr_bus[][2] = {
+static const unsigned int exynos4x12_clkdiv_lr_bus[][2] = {
 	/*
 	 * Clock divider value for following
 	 * { DIVGDL/R, DIVGPL/R }
@@ -287,7 +287,7 @@ static unsigned int exynos4x12_clkdiv_lr_bus[][2] = {
 	/* ACLK_GDL/R L4: 100MHz */
 	{7, 1},
 };
-static unsigned int exynos4x12_clkdiv_sclkip[][3] = {
+static const unsigned int exynos4x12_clkdiv_sclkip[][3] = {
 	/*
 	 * Clock divider value for following
 	 * { DIVMFC, DIVJPEG, DIVFIMC0~3}
-- 
1.7.9.5



