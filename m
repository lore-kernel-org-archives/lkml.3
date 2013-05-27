Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757839Ab3E0LHz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 07:07:55 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:57919 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757702Ab3E0LHd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 07:07:33 -0400
From: Andrii Tseglytskyi <andrii.tseglytskyi@ti.com>
To: Kevin Hilman <khilman@linaro.org>, J Keerthy <j-keerthy@ti.com>
CC: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>
Subject: [PATCH v1 2/3] PM / AVS: SmartReflex: disable runtime PM on driver remove
Date: Mon, 27 May 2013 14:07:25 +0300
Message-ID: <1369652846-14412-3-git-send-email-andrii.tseglytskyi@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1369652846-14412-1-git-send-email-andrii.tseglytskyi@ti.com>
References: <1369652846-14412-1-git-send-email-andrii.tseglytskyi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Runtime PM should be disabled for device on driver remove,
otherwise runtime PM will be not balanced, and this will cause
an error message, on next driver probe.

Signed-off-by: Andrii Tseglytskyi <andrii.tseglytskyi@ti.com>
Acked-by: Nishanth Menon <nm@ti.com>
---
 drivers/power/avs/smartreflex.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/power/avs/smartreflex.c b/drivers/power/avs/smartreflex.c
index f34d34d..9b56648 100644
--- a/drivers/power/avs/smartreflex.c
+++ b/drivers/power/avs/smartreflex.c
@@ -1032,6 +1032,7 @@ static int omap_sr_remove(struct platform_device *pdev)
 	if (sr_info->dbg_dir)
 		debugfs_remove_recursive(sr_info->dbg_dir);
 
+	pm_runtime_disable(&pdev->dev);
 	list_del(&sr_info->node);
 	iounmap(sr_info->base);
 	kfree(sr_info->name);
-- 
1.7.9.5

