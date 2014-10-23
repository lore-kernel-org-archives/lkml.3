Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221AbaJWQ1o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 12:27:44 -0400
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:6553 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752438AbaJWQ1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 12:27:43 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AswNADErSVRbtA79/2dsb2JhbABcgw66QwUBdJo+gRMXAX2EMC8jgRo3iEUBuh6OeIYliVxXHYQ1BZ1djGiJRYFHAWyBRjsvgQeBRAEBAQ
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/1 linux-next] block: remove struct partition_meta_info from rescan_partitions
Date: Thu, 23 Oct 2014 18:27:34 +0200
Message-Id: <1414081654-6573-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

&state->parts[p].info is directly passed to
add_partition(). local info is initialized but unused.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 block/partition-generic.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/block/partition-generic.c b/block/partition-generic.c
index 0d9e5f9..646c0e3 100644
--- a/block/partition-generic.c
+++ b/block/partition-generic.c
@@ -475,7 +475,6 @@ rescan:
 	/* add partitions */
 	for (p = 1; p < state->limit; p++) {
 		sector_t size, from;
-		struct partition_meta_info *info = NULL;
 
 		size = state->parts[p].size;
 		if (!size)
@@ -510,8 +509,6 @@ rescan:
 			}
 		}
 
-		if (state->parts[p].has_info)
-			info = &state->parts[p].info;
 		part = add_partition(disk, p, from, size,
 				     state->parts[p].flags,
 				     &state->parts[p].info);
-- 
1.9.3

