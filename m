Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634Ab3B1KcA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 05:32:00 -0500
Received: from smtp.eu.citrix.com ([46.33.159.39]:54669 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752282Ab3B1K3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 05:29:36 -0500
X-IronPort-AV: E=Sophos;i="4.84,754,1355097600"; 
   d="scan'208";a="2012277"
From: Roger Pau Monne <roger.pau@citrix.com>
To: <linux-kernel@vger.kernel.org>, <xen-devel@lists.xen.org>
CC: Roger Pau Monne <roger.pau@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH RFC 02/12] xen-blkback: fix foreach_grant_safe to handle empty lists
Date: Thu, 28 Feb 2013 11:28:45 +0100
Message-ID: <1362047335-26402-3-git-send-email-roger.pau@citrix.com>
X-Mailer: git-send-email 1.7.7.5 (Apple Git-26)
In-Reply-To: <1362047335-26402-1-git-send-email-roger.pau@citrix.com>
References: <1362047335-26402-1-git-send-email-roger.pau@citrix.com>
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
index d40beb3..415a0c7 100644
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

