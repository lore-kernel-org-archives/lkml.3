Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751255AbaFLRpZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 13:45:25 -0400
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:1086 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751074AbaFLRpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 13:45:24 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjoIAAjmmVNbsHy//2dsb2JhbABagw2qdQUBAQEBAQEFAZkegQoXdYQxLyOBGjeIRgG4M5oRF4VciBsNVx2EKwSPaIpKk1KDPjuBMAEf
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/1] block/partitions/aix.c: replace count*size kzalloc by kcalloc
Date: Thu, 12 Jun 2014 19:45:17 +0200
Message-Id: <1402595117-3219-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kcalloc manages count*sizeof overflow.

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 block/partitions/aix.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/partitions/aix.c b/block/partitions/aix.c
index 43be471..0a6ed54 100644
--- a/block/partitions/aix.c
+++ b/block/partitions/aix.c
@@ -215,7 +215,7 @@ int aix_partition(struct parsed_partitions *state)
 		numlvs = be16_to_cpu(p->numlvs);
 		put_dev_sector(sect);
 	}
-	lvip = kzalloc(sizeof(struct lv_info) * state->limit, GFP_KERNEL);
+	lvip = kcalloc(state->limit, sizeof(struct lv_info), GFP_KERNEL);
 	if (!lvip)
 		return 0;
 	if (numlvs && (d = read_part_sector(state, vgda_sector + 1, &sect))) {
-- 
1.9.1

