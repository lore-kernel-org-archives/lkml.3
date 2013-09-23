Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934Ab3IWMEi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 08:04:38 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:4084 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753456Ab3IWMEh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 08:04:37 -0400
X-IronPort-AV: E=Sophos;i="4.90,938,1371052800"; 
   d="scan'208";a="8595929"
From: chaiwen <chaiw.fnst@cn.fujitsu.com>
To: npiggin@kernel.dk
Cc: linux-kernel@vger.kernel.org, chaiwen <chaiw.fnst@cn.fujitsu.com>
Subject: [PATCH] brd: return register_blkdev err code when it fails
Date: Mon, 23 Sep 2013 20:04:00 +0800
Message-Id: <1379937840-9041-1-git-send-email-chaiw.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.1
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/09/23 20:02:55,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/09/23 20:02:55,
	Serialize complete at 2013/09/23 20:02:55
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Nick

when register_blk fails,no matter what reasons,brd_init always
returns a "-EIO" error code. if brd_init returns the error code
returned by register_blkdev,the formatted error info reported
when module inserting failed(caused by register_blkdev failing)
could be more meaningfull.

Signed-off-by: chaiwen <chaiw.fnst@cn.fujitsu.com>
---
 drivers/block/brd.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index 9bf4371..361204d 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -557,6 +557,7 @@ static int __init brd_init(void)
 	int i, nr;
 	unsigned long range;
 	struct brd_device *brd, *next;
+	int ret;
 
 	/*
 	 * brd module now has a feature to instantiate underlying device
@@ -602,8 +603,8 @@ static int __init brd_init(void)
 		range = 1UL << MINORBITS;
 	}
 
-	if (register_blkdev(RAMDISK_MAJOR, "ramdisk"))
-		return -EIO;
+	if (ret = register_blkdev(RAMDISK_MAJOR, "ramdisk"))
+		return ret;
 
 	for (i = 0; i < nr; i++) {
 		brd = brd_alloc(i);
-- 
1.7.1

