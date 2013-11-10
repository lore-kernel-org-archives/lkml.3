Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041Ab3KJS6w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 13:58:52 -0500
Received: from mail-ea0-f169.google.com ([209.85.215.169]:48657 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762Ab3KJS6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 13:58:46 -0500
From: Michal Nazarewicz <mpn@google.com>
To: Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michal Nazarewicz <mina86@mina86.com>
Subject: [PATCH] drivers: infiniband: remove unused argument and minor dead code
Date: Sun, 10 Nov 2013 19:58:35 +0100
Message-Id: <1384109915-24095-1-git-send-email-mpn@google.com>
X-Mailer: git-send-email 1.8.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Nazarewicz <mina86@mina86.com>

The dev variable is never assigned after being initialised.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 drivers/infiniband/core/cma.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index da9611d..33f114f 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -1452,7 +1452,6 @@ static int iw_conn_req_handler(struct iw_cm_id *cm_id,
 {
 	struct rdma_cm_id *new_cm_id;
 	struct rdma_id_private *listen_id, *conn_id;
-	struct net_device *dev = NULL;
 	struct rdma_cm_event event;
 	int ret;
 	struct ib_device_attr attr;
@@ -1530,8 +1529,6 @@ static int iw_conn_req_handler(struct iw_cm_id *cm_id,
 	cma_deref_id(conn_id);
 
 out:
-	if (dev)
-		dev_put(dev);
 	mutex_unlock(&listen_id->handler_mutex);
 	return ret;
 }
-- 
1.8.3.2

