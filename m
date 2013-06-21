Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030339Ab3FUK7S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 06:59:18 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:10995 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757911Ab3FUK6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 06:58:51 -0400
X-IronPort-AV: E=Sophos;i="4.87,912,1363132800"; 
   d="scan'208";a="5916358"
From: Roger Pau Monne <roger.pau@citrix.com>
To: <xen-devel@lists.xen.org>, <linux-kernel@vger.kernel.org>
CC: Roger Pau Monne <roger.pau@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 4/4] xen-blkfront: increase the default number of indirect segments
Date: Fri, 21 Jun 2013 12:56:56 +0200
Message-ID: <1371812216-17093-5-git-send-email-roger.pau@citrix.com>
X-Mailer: git-send-email 1.7.7.5 (Apple Git-26)
In-Reply-To: <1371812216-17093-1-git-send-email-roger.pau@citrix.com>
References: <1371812216-17093-1-git-send-email-roger.pau@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using certain storage devices (like RAID) having a bigger number
of segments per request provides better performance.

Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
Reported-by: Steven Haigh <netwiz@crc.id.au>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/block/xen-blkfront.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 2e1ee34..4e3ab34 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -94,9 +94,9 @@ static const struct block_device_operations xlvbd_block_fops;
  * by the backend driver.
  */
 
-static unsigned int xen_blkif_max_segments = 32;
+static unsigned int xen_blkif_max_segments = 64;
 module_param_named(max, xen_blkif_max_segments, int, S_IRUGO);
-MODULE_PARM_DESC(max, "Maximum amount of segments in indirect requests (default is 32)");
+MODULE_PARM_DESC(max, "Maximum amount of segments in indirect requests (default is 64)");
 
 #define BLK_RING_SIZE __CONST_RING_SIZE(blkif, PAGE_SIZE)
 
-- 
1.7.7.5 (Apple Git-26)

