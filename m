Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030434AbaGCKQD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 06:16:03 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51566 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758206AbaGCJVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:21:35 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sagi Grimberg <sagig@mellanox.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 033/198] Target/iser: Wait for proper cleanup before unloading
Date: Thu,  3 Jul 2014 10:17:56 +0100
Message-Id: <1404379241-8590-34-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sagi Grimberg <sagig@mellanox.com>

commit f5ebec9629cf78eeeea4b8258882a9f439ab2404 upstream.

disconnected_handler works are scheduled on system_wq.
When attempting to unload, first make sure all works
have cleaned up.

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index cfb8824d6a9e..f1208f9ba702 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -2452,6 +2452,7 @@ destroy_rx_wq:
 
 static void __exit isert_exit(void)
 {
+	flush_scheduled_work();
 	kmem_cache_destroy(isert_cmd_cache);
 	destroy_workqueue(isert_comp_wq);
 	destroy_workqueue(isert_rx_wq);
-- 
1.9.1

