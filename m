Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938AbaD0VSg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 17:18:36 -0400
Received: from linuxhacker.ru ([217.76.32.60]:49646 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752763AbaD0VRp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 17:17:45 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Dmitry Eremin <dmitry.eremin@intel.com>,
        Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 4/5] staging/lustre/lnet: fix potential null pointer dereference
Date: Sun, 27 Apr 2014 17:17:25 -0400
Message-Id: <1398633446-16719-5-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1398633446-16719-1-git-send-email-green@linuxhacker.ru>
References: <1398633446-16719-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Eremin <dmitry.eremin@intel.com>

Null pointer 'cp' that comes from line 2544 may be dereferenced
at line 2618.
found by Klocwork Insight tool

Signed-off-by: Dmitry Eremin <dmitry.eremin@intel.com>
Reviewed-on: http://review.whamcloud.com/9386
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-4629
Reviewed-by: John L. Hammond <john.hammond@intel.com>
Reviewed-by: Isaac Huang <he.huang@intel.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c
index 6173e74..9bf6c94 100644
--- a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c
+++ b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c
@@ -2609,13 +2609,17 @@ kiblnd_rejected (kib_conn_t *conn, int reason, void *priv, int priv_nob)
 
 			case IBLND_REJECT_MSG_QUEUE_SIZE:
 				CERROR("%s rejected: incompatible message queue depth %d, %d\n",
-				       libcfs_nid2str(peer->ibp_nid), cp->ibcp_queue_depth,
+				       libcfs_nid2str(peer->ibp_nid),
+				       cp != NULL ? cp->ibcp_queue_depth :
+				       IBLND_MSG_QUEUE_SIZE(rej->ibr_version),
 				       IBLND_MSG_QUEUE_SIZE(conn->ibc_version));
 				break;
 
 			case IBLND_REJECT_RDMA_FRAGS:
 				CERROR("%s rejected: incompatible # of RDMA fragments %d, %d\n",
-				       libcfs_nid2str(peer->ibp_nid), cp->ibcp_max_frags,
+				       libcfs_nid2str(peer->ibp_nid),
+				       cp != NULL ? cp->ibcp_max_frags :
+				       IBLND_RDMA_FRAGS(rej->ibr_version),
 				       IBLND_RDMA_FRAGS(conn->ibc_version));
 				break;
 
-- 
1.9.0

