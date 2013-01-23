Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817Ab3AWK2P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 05:28:15 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:61902 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754581Ab3AWK2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 05:28:11 -0500
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org,
        Maxime Coquelin <maxime.coquelin@stericsson.com>,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH] ARM: mach-ux500: enable 128KB way L2 cache on DB8540
Date: Wed, 23 Jan 2013 11:27:58 +0100
Message-Id: <1358936878-29806-1-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.7.12.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maxime Coquelin <maxime.coquelin@stericsson.com>

DB8540 L2 was configured with 64KB way size, but it has 128KB as AP9540.

Fix this by modifying ux500_l2x0_init() to use 128KB way size for all
cpus in the x540 family.

Signed-off-by: Maxime Coquelin <maxime.coquelin@stericsson.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 arch/arm/mach-ux500/cache-l2x0.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-ux500/cache-l2x0.c b/arch/arm/mach-ux500/cache-l2x0.c
index 75d5b51..1682dfe 100644
--- a/arch/arm/mach-ux500/cache-l2x0.c
+++ b/arch/arm/mach-ux500/cache-l2x0.c
@@ -46,8 +46,8 @@ static int __init ux500_l2x0_init(void)
 	/* Unlock before init */
 	ux500_l2x0_unlock();
 
-	/* DB9540's L2 has 128KB way size */
-	if (cpu_is_u9540())
+	/* DBx540's L2 has 128KB way size */
+	if (cpu_is_ux540_family())
 		/* 128KB way size */
 		aux_val |= (0x4 << L2X0_AUX_CTRL_WAY_SIZE_SHIFT);
 	else
-- 
1.7.12.1

