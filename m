Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935297AbaH0Pv0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 11:51:26 -0400
Received: from g4t3425.houston.hp.com ([15.201.208.53]:5729 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935001AbaH0PvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 11:51:24 -0400
Subject: [PATCH 1/2] block: make blk_update_request print prefix match
	ratelimited prefix
To: axboe@kernel.dk, webbnh@hp.com, linux-kernel@vger.kernel.org,
        relliott@beardog.cce.hp.com, linux-fsdevel@vger.kernel.org,
        viro@zeniv.linux.org.uk, elliott@hp.com, scameron@beardog.cce.hp.com
From: Robert Elliott <elliott@hp.com>
Date: Wed, 27 Aug 2014 10:50:31 -0500
Message-ID: <20140827155031.32075.49783.stgit@beardog.cce.hp.com>
In-Reply-To: <20140827154628.32075.3821.stgit@beardog.cce.hp.com>
References: <20140827154628.32075.3821.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In blk_update_request, change the printk_ratelimited
prefix from end_request to blk_update_request so it
matches the name printed if rate limiting occurs.

Old:
[10234.933106] blk_update_request: 174 callbacks suppressed
[10234.934940] end_request: critical target error, dev sdr, sector 16
[10234.949788] end_request: critical target error, dev sdr, sector 16

New:
[16863.445173] blk_update_request: 398 callbacks suppressed
[16863.447029] blk_update_request: critical target error, dev sdr, sector
1442066176
[16863.449383] blk_update_request: critical target error, dev sdr, sector
802802888
[16863.451680] blk_update_request: critical target error, dev sdr, sector
1609535456

Signed-off-by: Robert Elliott <elliott@hp.com>
Reviewed-by: Webb Scales <webbnh@hp.com>
---
 block/blk-core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index c359d72..9c5a5b9 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2450,8 +2450,8 @@ bool blk_update_request(struct request *req, int error, unsigned int nr_bytes)
 			error_type = "I/O";
 			break;
 		}
-		printk_ratelimited(KERN_ERR "end_request: %s error, dev %s, sector %llu\n",
-				   error_type, req->rq_disk ?
+		printk_ratelimited(KERN_ERR "%s: %s error, dev %s, sector %llu\n",
+				   __func__, error_type, req->rq_disk ?
 				   req->rq_disk->disk_name : "?",
 				   (unsigned long long)blk_rq_pos(req));
 

