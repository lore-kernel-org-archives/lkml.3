Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752112AbaFFMpU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 08:45:20 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:56428 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986AbaFFMpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 08:45:14 -0400
From: Simon Horman <horms+renesas@verge.net.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        Magnus Damm <magnus.damm@gmail.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Simon Horman <horms+renesas@verge.net.au>
Subject: [PATCH 1/4] drivers: sh: pm_runtime does not need idle callback
Date: Fri,  6 Jun 2014 21:44:32 +0900
Message-Id: <fe95c932a31e7f12bcb6a4e07434462da2ac6e1d.1402058435.git.horms+renesas@verge.net.au>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <cover.1402058435.git.horms+renesas@verge.net.au>
References: <cover.1402058435.git.horms+renesas@verge.net.au>
In-Reply-To: <cover.1402058435.git.horms+renesas@verge.net.au>
References: <cover.1402058435.git.horms+renesas@verge.net.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Dooks <ben.dooks@codethink.co.uk>

In the runtime_pm idle callback the code assumes that a NULL .runtime_idle
entry is the same as a .runtime_idle entry that returns 0 as a result. This
means the entry in drivers/sh/pm_runtime can be removed in favour of just
leaving the entry NULL.

Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Tested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com> [r8a7779 legacy]
Signed-off-by: Simon Horman <horms+renesas@verge.net.au>
---
 drivers/sh/pm_runtime.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/sh/pm_runtime.c b/drivers/sh/pm_runtime.c
index 10c65eb..00b82ec 100644
--- a/drivers/sh/pm_runtime.c
+++ b/drivers/sh/pm_runtime.c
@@ -21,18 +21,10 @@
 #include <linux/slab.h>
 
 #ifdef CONFIG_PM_RUNTIME
-
-static int default_platform_runtime_idle(struct device *dev)
-{
-	/* suspend synchronously to disable clocks immediately */
-	return 0;
-}
-
 static struct dev_pm_domain default_pm_domain = {
 	.ops = {
 		.runtime_suspend = pm_clk_suspend,
 		.runtime_resume = pm_clk_resume,
-		.runtime_idle = default_platform_runtime_idle,
 		USE_PLATFORM_PM_SLEEP_OPS
 	},
 };
-- 
1.8.4

