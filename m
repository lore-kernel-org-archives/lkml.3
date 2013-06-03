Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758404Ab3FCNoY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 09:44:24 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:42412 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758128Ab3FCNne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 09:43:34 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, ulf.hansson@linaro.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 20/21] ARM: ux500: Reclassify PRCMU AUXDATA entry
Date: Mon,  3 Jun 2013 14:42:44 +0100
Message-Id: <1370266965-7901-21-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1370266965-7901-1-git-send-email-lee.jones@linaro.org>
References: <1370266965-7901-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We still need to utilise the AUXDATA system for the PRCMU to pass
through platform data which can not be DT:ed i.e. regulator initialisation
values. All we're doing in this patch is changing the comment header to be
more accurate.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/cpu-db8500.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-ux500/cpu-db8500.c b/arch/arm/mach-ux500/cpu-db8500.c
index ddea9c7..5f9b089 100644
--- a/arch/arm/mach-ux500/cpu-db8500.c
+++ b/arch/arm/mach-ux500/cpu-db8500.c
@@ -220,7 +220,7 @@ static struct of_dev_auxdata u8500_auxdata_lookup[] __initdata = {
 	OF_DEV_AUXDATA("arm,cortex-a9-pmu", 0, "arm-pmu", &db8500_pmu_platdata),
 	/* Requires DMA bindings. */
 	OF_DEV_AUXDATA("arm,pl022", 0x80002000, "ssp0",  &ssp0_plat),
-	/* Requires clock name bindings. */
+	/* Requires non-DT:able platform data. */
 	OF_DEV_AUXDATA("stericsson,db8500-prcmu", 0x80157000, "db8500-prcmu",
 			&db8500_prcmu_pdata),
 	/* Requires device name bindings. */
-- 
1.7.10.4

