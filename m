Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884Ab3HWMdV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 08:33:21 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:58242 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755478Ab3HWMYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 08:24:08 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@linaro.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 08/40] ARM: ux500: Disable Snowball's CPUFreq functionality when booting with ATAGs enabled
Date: Fri, 23 Aug 2013 13:23:08 +0100
Message-Id: <1377260620-18829-9-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1377260620-18829-1-git-send-email-lee.jones@linaro.org>
References: <1377260620-18829-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's time to remove all ATAG support from ux500 and rely solely on
Device Tree booting. This patch is part of that endeavour.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/board-mop500.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index 68bd9d3..deda6a1 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -108,10 +108,6 @@ struct ab8500_platform_data ab8500_platdata = {
 	.codec		= &ab8500_codec_pdata,
 };
 
-static struct platform_device u8500_cpufreq_cooling_device = {
-	.name           = "db8500-cpufreq-cooling",
-};
-
 /*
  * TC35892
  */
@@ -351,7 +347,6 @@ static void __init u8500_cryp1_hash1_init(struct device *parent)
 }
 
 static struct platform_device *snowball_platform_devs[] __initdata = {
-	&u8500_cpufreq_cooling_device,
 	&sdi0_regulator,
 };
 
-- 
1.8.1.2

