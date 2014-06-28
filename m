Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786AbaF1Nt4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 09:49:56 -0400
Received: from mailrelay010.isp.belgacom.be ([195.238.6.177]:42155 "EHLO
	mailrelay010.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751710AbaF1Nty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 09:49:54 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkUHAH/FrlNbsk2v/2dsb2JhbABagw2regUBAQEBAQEFAW0BmQKBCBd1hDEvI4EaN4hGAcVMF4VkiFNOHYQtBZpdiz+IPIIAgUQ7
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Kevin Hilman <khilman@kernel.org>,
        Nishanth Menon <nm@ti.com>, linux-pm@vger.kernel.org
Subject: [PATCH V2] PM / AVS: SmartReflex: remove unnecessary NULL test before debugfs_remove_recursive
Date: Sat, 28 Jun 2014 15:48:33 +0200
Message-Id: <1403963313-8895-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch warning:
WARNING: debugfs_remove_recursive(NULL) is safe this check is probably not required

Cc: Kevin Hilman <khilman@kernel.org>
Cc: Nishanth Menon <nm@ti.com>
Cc: linux-pm@vger.kernel.org
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---

V2:
	-Subject update (suggested by Nishanth Menon)
	-Blank line before debugfs_remove not after

 drivers/power/avs/smartreflex.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/power/avs/smartreflex.c b/drivers/power/avs/smartreflex.c
index db9973b..ed67616 100644
--- a/drivers/power/avs/smartreflex.c
+++ b/drivers/power/avs/smartreflex.c
@@ -1001,9 +1001,8 @@ static int omap_sr_remove(struct platform_device *pdev)
 
 	if (sr_info->autocomp_active)
 		sr_stop_vddautocomp(sr_info);
-	if (sr_info->dbg_dir)
-		debugfs_remove_recursive(sr_info->dbg_dir);
 
+	debugfs_remove_recursive(sr_info->dbg_dir);
 	pm_runtime_disable(&pdev->dev);
 	list_del(&sr_info->node);
 	return 0;
-- 
1.8.4.5

