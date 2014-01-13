Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754972AbaAMQe7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:34:59 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53389 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754093AbaAMQDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:03:41 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 120/208] libceph: create_singlethread_workqueue() doesn't return ERR_PTRs
Date: Mon, 13 Jan 2014 15:59:21 +0000
Message-Id: <1389628849-1614-121-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit dbcae088fa660086bde6e10d63bb3c9264832d85 upstream.

create_singlethread_workqueue() returns NULL on error, and it doesn't
return ERR_PTRs.

I tweaked the error handling a little to be consistent with earlier in
the function.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ceph/osd_client.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index 56f1fe5..0c49ec4 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -2257,12 +2257,10 @@ int ceph_osdc_init(struct ceph_osd_client *osdc, struct ceph_client *client)
 	if (err < 0)
 		goto out_msgpool;
 
+	err = -ENOMEM;
 	osdc->notify_wq = create_singlethread_workqueue("ceph-watch-notify");
-	if (IS_ERR(osdc->notify_wq)) {
-		err = PTR_ERR(osdc->notify_wq);
-		osdc->notify_wq = NULL;
+	if (!osdc->notify_wq)
 		goto out_msgpool;
-	}
 	return 0;
 
 out_msgpool:
-- 
1.8.3.2

