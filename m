Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406AbaFNU5m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 16:57:42 -0400
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:63492 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751987AbaFNU5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 16:57:41 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AswIAHC2nFNXQyDr/2dsb2JhbABagw2rDgUBAQEBAQEFAZkkgQMXdYRgI4EaN4hGAc9EF4VjiC9kHYQtBJpDizCIKINCO4Ex
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/1] block/bio.c: use GFP_NOFS
Date: Sat, 14 Jun 2014 22:57:47 +0200
Message-Id: <1402779467-6398-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use GFP_NOFS instead of its definition.

Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 block/bio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/bio.c b/block/bio.c
index 8c2e55e..ec5d172 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -211,7 +211,7 @@ fallback:
 		bvl = mempool_alloc(pool, gfp_mask);
 	} else {
 		struct biovec_slab *bvs = bvec_slabs + *idx;
-		gfp_t __gfp_mask = gfp_mask & ~(__GFP_WAIT | __GFP_IO);
+		gfp_t __gfp_mask = gfp_mask & ~GFP_NOFS;
 
 		/*
 		 * Make this allocation restricted and don't dump info on
-- 
1.8.4.5

