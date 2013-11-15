Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757478Ab3KOEdk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 23:33:40 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:43755 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757176Ab3KOEdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 23:33:32 -0500
Message-ID: <5285A3F4.4040000@oracle.com>
Date: Fri, 15 Nov 2013 12:32:52 +0800
From: Jeff Liu <jeff.liu@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: akpm@linux-foundation.org, "xfs@oss.sgi.com" <xfs@oss.sgi.com>,
        cluster-devel@redhat.com, linux-mtd@lists.infradead.org,
        jfs-discussion@lists.sourceforge.net, oleg@redhat.com,
        jiri@resnulli.us, gregkh@linuxfoundation.org
Subject: [PATCH 3/6] gfs2: simplify current_tail() via list_last_entry_or_null()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jie Liu <jeff.liu@oracle.com>

Simplify the code in current_tail() via list_last_entry_or_null().

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/gfs2/log.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index 610613f..555f767 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -441,13 +441,9 @@ static unsigned int current_tail(struct gfs2_sbd *sdp)
 
 	spin_lock(&sdp->sd_ail_lock);
 
-	if (list_empty(&sdp->sd_ail1_list)) {
-		tail = sdp->sd_log_head;
-	} else {
-		tr = list_entry(sdp->sd_ail1_list.prev, struct gfs2_trans,
-				tr_list);
-		tail = tr->tr_first;
-	}
+	tr = list_last_entry_or_null(&sdp->sd_ail1_list, struct gfs2_trans,
+				     tr_list);
+	tail = tr ? tr->tr_first : sdp->sd_log_head;
 
 	spin_unlock(&sdp->sd_ail_lock);
 
-- 
1.8.3.2
