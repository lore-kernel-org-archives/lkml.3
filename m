Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160Ab3IRMQY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 08:16:24 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:58209 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752972Ab3IRMP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 08:15:28 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@linaro.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 39/41] ARM: ux500: Reclassify PRCMU AUXDATA entry
Date: Wed, 18 Sep 2013 13:14:36 +0100
Message-Id: <1379506478-16625-40-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379506478-16625-1-git-send-email-lee.jones@linaro.org>
References: <1379506478-16625-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We still need to utilise the AUXDATA system for the PRCMU to pass
through platform data which can not be DT:ed i.e. regulator initialisation
values. All we're doing in this patch is changing the comment header to be
more accurate.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/cpu-db8500.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-ux500/cpu-db8500.c b/arch/arm/mach-ux500/cpu-db8500.c
index 844c2fe..28a69d1 100644
--- a/arch/arm/mach-ux500/cpu-db8500.c
+++ b/arch/arm/mach-ux500/cpu-db8500.c
@@ -232,7 +232,7 @@ static struct of_dev_auxdata u8500_auxdata_lookup[] __initdata = {
 		       "ux500-msp-i2s.2", &msp2_platform_data),
 	OF_DEV_AUXDATA("stericsson,ux500-msp-i2s", 0x80125000,
 		       "ux500-msp-i2s.3", &msp3_platform_data),
-	/* Requires clock name bindings. */
+	/* Requires non-DT:able platform data. */
 	OF_DEV_AUXDATA("stericsson,db8500-prcmu", 0x80157000, "db8500-prcmu",
 			&db8500_prcmu_pdata),
 	OF_DEV_AUXDATA("stericsson,ux500-cryp", 0xa03cb000, "cryp1", NULL),
-- 
1.8.1.2

