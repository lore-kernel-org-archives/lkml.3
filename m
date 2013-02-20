Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756539Ab3BTI3n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 03:29:43 -0500
Received: from mail-ee0-f45.google.com ([74.125.83.45]:54647 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791Ab3BTI3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 03:29:41 -0500
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH] ARM: ux500: read the correct soc_id number
Date: Wed, 20 Feb 2013 09:29:16 +0100
Message-Id: <1361348956-4387-1-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.7.12.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix db8500_read_soc_id() to read all five soc_id number locations
instead of repeating the second one two times.

Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 arch/arm/mach-ux500/cpu-db8500.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-ux500/cpu-db8500.c b/arch/arm/mach-ux500/cpu-db8500.c
index 5b286e0..4b5602b 100644
--- a/arch/arm/mach-ux500/cpu-db8500.c
+++ b/arch/arm/mach-ux500/cpu-db8500.c
@@ -199,7 +199,7 @@ static const char *db8500_read_soc_id(void)
 	/* Throw these device-specific numbers into the entropy pool */
 	add_device_randomness(uid, 0x14);
 	return kasprintf(GFP_KERNEL, "%08x%08x%08x%08x%08x",
-			 readl((u32 *)uid+1),
+			 readl((u32 *)uid+0),
 			 readl((u32 *)uid+1), readl((u32 *)uid+2),
 			 readl((u32 *)uid+3), readl((u32 *)uid+4));
 }
-- 
1.7.12.1

