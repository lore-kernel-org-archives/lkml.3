Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318AbaDAL1D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 07:27:03 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42737 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967AbaDALSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:18:55 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ilya Dryomov <ilya.dryomov@inktank.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 129/144] libceph: rename front to front_len in get_reply()
Date: Tue,  1 Apr 2014 12:15:33 +0100
Message-Id: <1396350948-29910-130-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
References: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Dryomov <ilya.dryomov@inktank.com>

commit 3f0a4ac55fe036902e3666be740da63528ad8639 upstream.

Rename front local variable to front_len in get_reply() to make its
purpose more clear.

Signed-off-by: Ilya Dryomov <ilya.dryomov@inktank.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ceph/osd_client.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index 1ee21cd..47eaf53 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -2447,7 +2447,7 @@ static struct ceph_msg *get_reply(struct ceph_connection *con,
 	struct ceph_osd_client *osdc = osd->o_osdc;
 	struct ceph_msg *m;
 	struct ceph_osd_request *req;
-	int front = le32_to_cpu(hdr->front_len);
+	int front_len = le32_to_cpu(hdr->front_len);
 	int data_len = le32_to_cpu(hdr->data_len);
 	u64 tid;
 
@@ -2467,12 +2467,13 @@ static struct ceph_msg *get_reply(struct ceph_connection *con,
 		     req->r_reply, req->r_reply->con);
 	ceph_msg_revoke_incoming(req->r_reply);
 
-	if (front > req->r_reply->front.iov_len) {
+	if (front_len > req->r_reply->front.iov_len) {
 		pr_warning("get_reply front %d > preallocated %d (%u#%llu)\n",
-			   front, (int)req->r_reply->front.iov_len,
+			   front_len, (int)req->r_reply->front.iov_len,
 			   (unsigned int)con->peer_name.type,
 			   le64_to_cpu(con->peer_name.num));
-		m = ceph_msg_new(CEPH_MSG_OSD_OPREPLY, front, GFP_NOFS, false);
+		m = ceph_msg_new(CEPH_MSG_OSD_OPREPLY, front_len, GFP_NOFS,
+				 false);
 		if (!m)
 			goto out;
 		ceph_msg_put(req->r_reply);
-- 
1.9.1

