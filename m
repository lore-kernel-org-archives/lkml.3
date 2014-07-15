Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758497AbaGORZA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 13:25:00 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:51775 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755316AbaGORCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 13:02:09 -0400
From: Sam Asadi <asadi.samuel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>, sam-the-6 <asadi.samuel@gmail.com>
Subject: [PATCH 21/94] ARM: EXYNOS: Fix the check for non-smp configuration
Date: Tue, 15 Jul 2014 20:00:36 +0300
Message-Id: <1405443709-15288-21-git-send-email-asadi.samuel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
References: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Abhilash Kesavan <a.kesavan@samsung.com>

Commit 1754c42e3db5("ARM: exynos: move sysram info to exynos.c") missed
out the CONFIG_ prefix causing exynos_sysram_init() to get called twice
for SMP configurations.

Signed-off-by: Abhilash Kesavan <a.kesavan@samsung.com>
Reviewed-by: Sachin Kamat <sachin.kamat@samsug.com>
Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: sam-the-6 <asadi.samuel@gmail.com>
---
 arch/arm/mach-exynos/exynos.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-exynos/exynos.c b/arch/arm/mach-exynos/exynos.c
index f38cf7c..95cad25 100644
--- a/arch/arm/mach-exynos/exynos.c
+++ b/arch/arm/mach-exynos/exynos.c
@@ -297,7 +297,7 @@ static void __init exynos_dt_machine_init(void)
 	 * This is called from smp_prepare_cpus if we've built for SMP, but
 	 * we still need to set it up for PM and firmware ops if not.
 	 */
-	if (!IS_ENABLED(SMP))
+	if (!IS_ENABLED(CONFIG_SMP))
 		exynos_sysram_init();
 
 	exynos_cpuidle_init();
-- 
1.7.10.4

