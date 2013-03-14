Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269Ab3CNJI1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 05:08:27 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:9914 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039Ab3CNJIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 05:08:24 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 14 Mar 2013 02:01:42 -0700
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: Russell King <linux@arm.linux.org.uk>
CC: <linux-tegra@vger.kernel.org>, Hiroshi Doyu <hdoyu@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/1] amba: tegra-ahb: Fix build error w/ PM_SLEEP w/o PM_RUNTIME
Date: Thu, 14 Mar 2013 11:08:09 +0200
Message-ID: <1363252089-4120-1-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make this depend on CONFIG_PM. This protection is necessary to not
cause any build errors with any combination of PM features especially
when supporting a new SoC where each PM features are being enabled
one-by-one during its depelopment.

Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
Reported-by: Joseph Lo <josephl@nvidia.com>
---
 drivers/amba/tegra-ahb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/amba/tegra-ahb.c b/drivers/amba/tegra-ahb.c
index 093c435..1f44e56 100644
--- a/drivers/amba/tegra-ahb.c
+++ b/drivers/amba/tegra-ahb.c
@@ -158,7 +158,7 @@ int tegra_ahb_enable_smmu(struct device_node *dn)
 EXPORT_SYMBOL(tegra_ahb_enable_smmu);
 #endif
 
-#ifdef CONFIG_PM_SLEEP
+#ifdef CONFIG_PM
 static int tegra_ahb_suspend(struct device *dev)
 {
 	int i;
-- 
1.8.1.5

