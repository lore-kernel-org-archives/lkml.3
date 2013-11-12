Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910Ab3KLGgp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 01:36:45 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:6048 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264Ab3KLGgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 01:36:41 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 11 Nov 2013 22:35:14 -0800
From: Alexandre Courbot <acourbot@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <gnurou@gmail.com>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH] ARM: tegra: init fuse before setting reset handler
Date: Tue, 12 Nov 2013 15:36:26 +0900
Message-ID: <1384238186-8473-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.4.2
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CPU reset handler was set before fuse is initialized, but
tegra_cpu_reset_handler_enable() uses tegra_chip_id, which is set by
tegra_init_fuse(). This patch reorders the calls so the CPU reset
handler code does not read an uninitialized variable.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 arch/arm/mach-tegra/tegra.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-tegra/tegra.c b/arch/arm/mach-tegra/tegra.c
index 80b801a94677..0fbdadcd96b7 100644
--- a/arch/arm/mach-tegra/tegra.c
+++ b/arch/arm/mach-tegra/tegra.c
@@ -92,9 +92,9 @@ static void __init tegra_init_cache(void)
 
 static void __init tegra_init_early(void)
 {
-	tegra_cpu_reset_handler_init();
 	tegra_apb_io_init();
 	tegra_init_fuse();
+	tegra_cpu_reset_handler_init();
 	tegra_init_cache();
 	tegra_powergate_init();
 	tegra_hotplug_init();
-- 
1.8.4.2

