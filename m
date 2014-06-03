Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495AbaFCLmL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 07:42:11 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43639 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932822AbaFCLl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 07:41:59 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sagi Grimberg <sagig@mellanox.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 084/138] Target/iser: Fix wrong connection requests list addition
Date: Tue,  3 Jun 2014 12:38:50 +0100
Message-Id: <1401795584-22664-85-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
References: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sagi Grimberg <sagig@mellanox.com>

commit 9fe63c88b1d59f1ce054d6948ccd3096496ecedb upstream.

Should be adding list_add_tail($new, $head) and not
the other way around.

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 0e28266315b1..f1741e62647c 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -459,7 +459,7 @@ isert_connect_request(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
 		goto out_conn_dev;
 
 	mutex_lock(&isert_np->np_accept_mutex);
-	list_add_tail(&isert_np->np_accept_list, &isert_conn->conn_accept_node);
+	list_add_tail(&isert_conn->conn_accept_node, &isert_np->np_accept_list);
 	mutex_unlock(&isert_np->np_accept_mutex);
 
 	pr_debug("isert_connect_request() waking up np_accept_wq: %p\n", np);
-- 
1.9.1

