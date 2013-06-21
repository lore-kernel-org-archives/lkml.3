Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161091Ab3FUK7U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 06:59:20 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:10995 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754067Ab3FUK6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 06:58:50 -0400
X-IronPort-AV: E=Sophos;i="4.87,912,1363132800"; 
   d="scan'208";a="5916356"
From: Roger Pau Monne <roger.pau@citrix.com>
To: <xen-devel@lists.xen.org>, <linux-kernel@vger.kernel.org>
CC: Roger Pau Monne <roger.pau@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 2/4] xen-blkfront: set blk_queue_max_hw_sectors correctly
Date: Fri, 21 Jun 2013 12:56:54 +0200
Message-ID: <1371812216-17093-3-git-send-email-roger.pau@citrix.com>
X-Mailer: git-send-email 1.7.7.5 (Apple Git-26)
In-Reply-To: <1371812216-17093-1-git-send-email-roger.pau@citrix.com>
References: <1371812216-17093-1-git-send-email-roger.pau@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that indirect segments are enabled blk_queue_max_hw_sectors must
be set to match the maximum number of sectors we can handle in a
request.

Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
Reported-by: Felipe Franciosi <felipe.franciosi@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/block/xen-blkfront.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 1a0f67c..2e1ee34 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -633,7 +633,7 @@ static int xlvbd_init_blk_queue(struct gendisk *gd, u16 sector_size,
 	/* Hard sector size and max sectors impersonate the equiv. hardware. */
 	blk_queue_logical_block_size(rq, sector_size);
 	blk_queue_physical_block_size(rq, physical_sector_size);
-	blk_queue_max_hw_sectors(rq, 512);
+	blk_queue_max_hw_sectors(rq, (segments * PAGE_SIZE) / 512);
 
 	/* Each segment in a request is up to an aligned page in size. */
 	blk_queue_segment_boundary(rq, PAGE_SIZE - 1);
-- 
1.7.7.5 (Apple Git-26)

