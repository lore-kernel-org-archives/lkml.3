Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656Ab3G3Mku (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 08:40:50 -0400
Received: from mail-qe0-f52.google.com ([209.85.128.52]:58460 "EHLO
	mail-qe0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752685Ab3G3Mki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 08:40:38 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com
Cc: shli@kernel.org, Tejun Heo <tj@kernel.org>, Chris Ball <cjb@laptop.org>,
        linux-mmc@vger.kernel.org
Subject: [PATCH 3/9] mmc: WQ_NON_REENTRANT is meaningless and going away
Date: Tue, 30 Jul 2013 08:40:22 -0400
Message-Id: <1375188028-11910-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1375188028-11910-1-git-send-email-tj@kernel.org>
References: <1375188028-11910-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Please route this through the subsystem tree.  As written in the
description, this shouldn't make any functional difference and just
prepares for the removal of WQ_NON_REENTRANT which is already noop.

Thanks.

------ 8< -------
dbf2576e37 ("workqueue: make all workqueues non-reentrant") made
WQ_NON_REENTRANT no-op and the flag is going away.  Remove its usages.

This patch doesn't introduce any behavior changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Chris Ball <cjb@laptop.org>
Cc: linux-mmc@vger.kernel.org
---
 drivers/mmc/host/dw_mmc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
index ee5f167..b37e3c2 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -2340,7 +2340,7 @@ int dw_mci_probe(struct dw_mci *host)
 
 	tasklet_init(&host->tasklet, dw_mci_tasklet_func, (unsigned long)host);
 	host->card_workqueue = alloc_workqueue("dw-mci-card",
-			WQ_MEM_RECLAIM | WQ_NON_REENTRANT, 1);
+					       WQ_MEM_RECLAIM, 1);
 	if (!host->card_workqueue) {
 		ret = -ENOMEM;
 		goto err_dmaunmap;
-- 
1.8.3.1

