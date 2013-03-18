Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480Ab3CRQvX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 12:51:23 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:36533 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754409Ab3CRQvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 12:51:17 -0400
X-IronPort-AV: E=Sophos;i="4.84,865,1355097600"; 
   d="scan'208";a="2617149"
From: Roger Pau Monne <roger.pau@citrix.com>
To: <xen-devel@lists.xen.org>, <linux-kernel@vger.kernel.org>
CC: Roger Pau Monne <roger.pau@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 2/5] xen-blkback: fix foreach_grant_safe to handle empty lists
Date: Mon, 18 Mar 2013 17:49:33 +0100
Message-ID: <1363625376-35612-3-git-send-email-roger.pau@citrix.com>
X-Mailer: git-send-email 1.7.7.5 (Apple Git-26)
In-Reply-To: <1363625376-35612-1-git-send-email-roger.pau@citrix.com>
References: <1363625376-35612-1-git-send-email-roger.pau@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We may use foreach_grant_safe in the future with empty lists, so make
sure we can handle them.

Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
Cc: xen-devel@lists.xen.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/block/xen-blkback/blkback.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
index d909acf0..7319f67 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -164,7 +164,7 @@ static void make_response(struct xen_blkif *blkif, u64 id,
 
 #define foreach_grant_safe(pos, n, rbtree, node) \
 	for ((pos) = container_of(rb_first((rbtree)), typeof(*(pos)), node), \
-	     (n) = rb_next(&(pos)->node); \
+	     (n) = (&(pos)->node != NULL) ? rb_next(&(pos)->node) : NULL; \
 	     &(pos)->node != NULL; \
 	     (pos) = container_of(n, typeof(*(pos)), node), \
 	     (n) = (&(pos)->node != NULL) ? rb_next(&(pos)->node) : NULL)
-- 
1.7.7.5 (Apple Git-26)

