Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757319Ab3KOEcR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 23:32:17 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:50471 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757060Ab3KOEcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 23:32:06 -0500
Message-ID: <5285A39C.4030507@oracle.com>
Date: Fri, 15 Nov 2013 12:31:24 +0800
From: Jeff Liu <jeff.liu@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: akpm@linux-foundation.org, "xfs@oss.sgi.com" <xfs@oss.sgi.com>,
        cluster-devel@redhat.com, linux-mtd@lists.infradead.org,
        jfs-discussion@lists.sourceforge.net, oleg@redhat.com,
        jiri@resnulli.us, gregkh@linuxfoundation.org
Subject: [PATCH 2/6] xfs: simplify xfs_ail_max() via list_last_entry_or_null()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jie Liu <jeff.liu@oracle.com>

Simplify xfs_ail_max() with list_last_entry_or_null(), and move it to
xfs_trans_priv.h as an inline function as now it is one line.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/xfs/xfs_trans_ail.c  | 14 --------------
 fs/xfs/xfs_trans_priv.h | 12 ++++++++++++
 2 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index a728735..af605d0 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -62,20 +62,6 @@ xfs_ail_check(
 #endif /* DEBUG */
 
 /*
- * Return a pointer to the last item in the AIL.  If the AIL is empty, then
- * return NULL.
- */
-static xfs_log_item_t *
-xfs_ail_max(
-	struct xfs_ail  *ailp)
-{
-	if (list_empty(&ailp->xa_ail))
-		return NULL;
-
-	return list_entry(ailp->xa_ail.prev, xfs_log_item_t, li_ail);
-}
-
-/*
  * Return a pointer to the item which follows the given item in the AIL.  If
  * the given item is the last item in the list, then return NULL.
  */
diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
index 12e86af..b1d93ae 100644
--- a/fs/xfs/xfs_trans_priv.h
+++ b/fs/xfs/xfs_trans_priv.h
@@ -97,6 +97,18 @@ xfs_ail_min(
 					li_ail);
 }
 
+/*
+ * Return a pointer to the last item in the AIL.  If the AIL is empty, then
+ * return NULL.
+ */
+static inline struct xfs_log_item *
+xfs_ail_max(
+	struct xfs_ail  *ailp)
+{
+	return list_last_entry_or_null(&ailp->xa_ail, struct xfs_log_item,
+				       li_ail);
+}
+
 static inline void
 xfs_trans_ail_update(
 	struct xfs_ail		*ailp,
-- 
1.8.3.2
