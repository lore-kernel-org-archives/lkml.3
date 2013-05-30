Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030458Ab3E3KJH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 06:09:07 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:51230 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968061Ab3E3KIm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 06:08:42 -0400
From: Andrii Tseglytskyi <andrii.tseglytskyi@ti.com>
To: <khilman@linaro.org>, <j-keerthy@ti.com>
CC: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-pm@vger.kernel.org>
Subject: [PATCH v2 2/3] PM / AVS: SmartReflex: disable runtime PM on driver remove
Date: Thu, 30 May 2013 13:08:35 +0300
Message-ID: <1369908516-26573-3-git-send-email-andrii.tseglytskyi@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1369908516-26573-1-git-send-email-andrii.tseglytskyi@ti.com>
References: <1369908516-26573-1-git-send-email-andrii.tseglytskyi@ti.com>
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

