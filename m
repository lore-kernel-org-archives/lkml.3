Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755753AbaGNOtz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 10:49:55 -0400
Received: from g4t3425.houston.hp.com ([15.201.208.53]:15298 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469AbaGNOtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 10:49:46 -0400
From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
To: "axboe@kernel.dk" <axboe@kernel.dk>,
        "Elliott, Robert (Server Storage)" <Elliott@hp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] block: make blkdev_issue_flush check for NULL from bio_alloc
Thread-Topic: [PATCH] block: make blkdev_issue_flush check for NULL from
 bio_alloc
Thread-Index: AQHPm4OWoDGsxRdqX0q2jWuNXBuUbg==
Date: Mon, 14 Jul 2014 14:49:20 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958BA10D3@G9W0745.americas.hpqcorp.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: StGit/0.16
x-originating-ip: [16.210.48.37]
Content-Type: text/plain; charset="utf-8"
Content-ID: <FE3FFE6773D9FA4E9D72BBD49151BA06@Compaq.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s6EEnv2t005602

bio_alloc can return NULL if gfp_mask does not contain __GPF_WAIT
and it doesn't use a mempool.  Since blkdev_issue_flush passes
along gfp_mask, it needs to check if bio_alloc returns NULL.

Signed-off-by: Robert Elliott <elliott@hp.com>
---
 block/blk-flush.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/block/blk-flush.c b/block/blk-flush.c
index 3cb5e9e..2a9fd20 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -457,6 +457,8 @@ int blkdev_issue_flush(struct block_device *bdev, gfp_t gfp_mask,
 		return -ENXIO;
 
 	bio = bio_alloc(gfp_mask, 0);
+	if (!bio)
+		return -ENOMEM;
 	bio->bi_bdev = bdev;
 
 	ret = submit_bio_wait(WRITE_FLUSH, bio);

---
Rob Elliott    HP Server Storage



ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
