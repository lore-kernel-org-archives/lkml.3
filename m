Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221Ab3IJAOe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 20:14:34 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:60997 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755850Ab3IJAOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 20:14:31 -0400
Message-Id: <22aafb8a75c10dfc082093f7ff346de66927904f.1378771874.git.joshc@codeaurora.org>
In-Reply-To: <5350fa5571d24b68d6bb27959d3ef761ccb95b00.1378771874.git.joshc@codeaurora.org>
References: <5350fa5571d24b68d6bb27959d3ef761ccb95b00.1378771874.git.joshc@codeaurora.org>
From: Josh Cartwright <joshc@codeaurora.org>
Date: Mon, 9 Sep 2013 19:02:07 -0500
Subject: [PATCH 2/2] ARM: msm: trout: fix uninit var warning
To: David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, arm@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following warning when !CONFIG_MMC:

arch/arm/mach-msm/board-trout.c: In function 'trout_init':
arch/arm/mach-msm/board-trout.c:67:6: warning: unused variable 'rc' [-Wunused-variable]
  int rc;
      ^

Also, while we're here, rework explicit printk(KERN_CRIT..) to use
pr_crit.

Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
---
 arch/arm/mach-msm/board-trout.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-msm/board-trout.c b/arch/arm/mach-msm/board-trout.c
index ccf6621..015d544 100644
--- a/arch/arm/mach-msm/board-trout.c
+++ b/arch/arm/mach-msm/board-trout.c
@@ -13,6 +13,7 @@
  * GNU General Public License for more details.
  *
  */
+#define pr_fmt(fmt) "%s: " fmt, __func__
 
 #include <linux/kernel.h>
 #include <linux/init.h>
@@ -68,12 +69,11 @@ static void __init trout_init(void)
 
 	platform_add_devices(devices, ARRAY_SIZE(devices));
 
-#ifdef CONFIG_MMC
-        rc = trout_init_mmc(system_rev);
-        if (rc)
-                printk(KERN_CRIT "%s: MMC init failure (%d)\n", __func__, rc);
-#endif
-
+	if (IS_ENABLED(CONFIG_MMC)) {
+		rc = trout_init_mmc(system_rev);
+		if (rc)
+			pr_crit("MMC init failure (%d)\n", rc);
+	}
 }
 
 static struct map_desc trout_io_desc[] __initdata = {
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

