Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757859Ab3KOEfb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 23:35:31 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:51258 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755912Ab3KOEfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 23:35:24 -0500
Message-ID: <5285A464.1070904@oracle.com>
Date: Fri, 15 Nov 2013 12:34:44 +0800
From: Jeff Liu <jeff.liu@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: akpm@linux-foundation.org, "xfs@oss.sgi.com" <xfs@oss.sgi.com>,
        cluster-devel@redhat.com, linux-mtd@lists.infradead.org,
        jfs-discussion@lists.sourceforge.net, oleg@redhat.com,
        jiri@resnulli.us, gregkh@linuxfoundation.org
Subject: [PATCH 5/6] jfs: simplify lmNextPage() via list_last_entry_or_null()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jie Liu <jeff.liu@oracle.com>

Simplify the code in lmNextPage via list_last_entry_or_null().

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/jfs/jfs_logmgr.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/jfs/jfs_logmgr.c b/fs/jfs/jfs_logmgr.c
index 360d27c..7b565d0 100644
--- a/fs/jfs/jfs_logmgr.c
+++ b/fs/jfs/jfs_logmgr.c
@@ -591,10 +591,7 @@ static int lmNextPage(struct jfs_log * log)
 	 *	write or queue the full page at the tail of write queue
 	 */
 	/* get the tail tblk on commit queue */
-	if (list_empty(&log->cqueue))
-		tblk = NULL;
-	else
-		tblk = list_entry(log->cqueue.prev, struct tblock, cqueue);
+	tblk = list_last_entry_or_null(&log->cqueue, struct tblock, cqueue);
 
 	/* every tblk who has COMMIT record on the current page,
 	 * and has not been committed, must be on commit queue
-- 
1.8.3.2
