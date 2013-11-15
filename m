Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757701Ab3KOEek (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 23:34:40 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:51041 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756703Ab3KOEef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 23:34:35 -0500
Message-ID: <5285A434.2080608@oracle.com>
Date: Fri, 15 Nov 2013 12:33:56 +0800
From: Jeff Liu <jeff.liu@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: akpm@linux-foundation.org, "xfs@oss.sgi.com" <xfs@oss.sgi.com>,
        cluster-devel@redhat.com, linux-mtd@lists.infradead.org,
        jfs-discussion@lists.sourceforge.net, oleg@redhat.com,
        jiri@resnulli.us, gregkh@linuxfoundation.org
Subject: [PATCH 4/6] ubifs: simplify drop_last_node() via list_last_entry_or_null()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jie Liu <jeff.liu@oracle.com>

Simplify the code in drop_last_node() via list_last_entry_or_null().

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/ubifs/recovery.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/ubifs/recovery.c b/fs/ubifs/recovery.c
index 065096e..e46c394 100644
--- a/fs/ubifs/recovery.c
+++ b/fs/ubifs/recovery.c
@@ -603,12 +603,10 @@ static void drop_last_group(struct ubifs_scan_leb *sleb, int *offs)
  */
 static void drop_last_node(struct ubifs_scan_leb *sleb, int *offs)
 {
-	struct ubifs_scan_node *snod;
-
-	if (!list_empty(&sleb->nodes)) {
-		snod = list_entry(sleb->nodes.prev, struct ubifs_scan_node,
-				  list);
+	struct ubifs_scan_node *snod = list_last_entry_or_null(&sleb->nodes,
+				       struct ubifs_scan_node, list);
 
+	if (snod) {
 		dbg_rcvry("dropping last node at %d:%d",
 			  sleb->lnum, snod->offs);
 		*offs = snod->offs;
-- 
1.8.3.2
