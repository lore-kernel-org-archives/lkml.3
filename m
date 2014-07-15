Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964993AbaGOWEF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 18:04:05 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54603 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759076AbaGOVhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 17:37:16 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sagi Grimberg <sagig@mellanox.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 042/198] Target/iser: Wait for proper cleanup before unloading
Date: Tue, 15 Jul 2014 14:28:32 -0700
Message-Id: <1405459868-15089-43-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405459868-15089-1-git-send-email-kamal@canonical.com>
References: <1405459868-15089-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sagi Grimberg <sagig@mellanox.com>

commit f5ebec9629cf78eeeea4b8258882a9f439ab2404 upstream.

disconnected_handler works are scheduled on system_wq.
When attempting to unload, first make sure all works
have cleaned up.

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index a281a7f..bde56da 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -2832,6 +2832,7 @@ destroy_rx_wq:
 
 static void __exit isert_exit(void)
 {
+	flush_scheduled_work();
 	destroy_workqueue(isert_comp_wq);
 	destroy_workqueue(isert_rx_wq);
 	iscsit_unregister_transport(&iser_target_transport);
-- 
1.9.1

