Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751197AbaCZEHb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 00:07:31 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:57458 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbaCZEH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 00:07:29 -0400
From: SeongJae Park <sj38.park@gmail.com>
To: agk@redhat.com, trivial@kernel.org, snitzer@redhat.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        SeongJae Park <sj38.park@gmail.com>
Subject: [PATCH] dm cache: remove unused function too_many_discard_blocks
Date: Wed, 26 Mar 2014 13:09:48 +0900
Message-Id: <1395806988-29189-1-git-send-email-sj38.park@gmail.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix following trivial build warning:
drivers/md/dm-cache-target.c:2182:13: warning:
‘too_many_discard_blocks’ defined but not used [-Wunused-function]
 static bool too_many_discard_blocks(sector_t discard_block_size,
             ^

It's usage removed by ab1f4c35b7("dm cache: prevent corruption caused by
discard_block_size > cache_block_size") as work-around and the
definition was not removed though it was only one usage. Let's remove
the definition now for clean build result and get back the definition
again after the workarounded problem solved well.

Signed-off-by: SeongJae Park <sj38.park@gmail.com>
---
 drivers/md/dm-cache-target.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 9f96e7a..2c1d347 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -2178,6 +2178,8 @@ static int create_cache_policy(struct cache *cache, struct cache_args *ca,
  */
 #define MAX_DISCARD_BLOCKS (1 << 14)
 
+#if 0
+/* FIXME: remove if 0 macro after stop-gap workaround solved */
 static bool too_many_discard_blocks(sector_t discard_block_size,
 				    sector_t origin_size)
 {
@@ -2185,6 +2187,7 @@ static bool too_many_discard_blocks(sector_t discard_block_size,
 
 	return origin_size > MAX_DISCARD_BLOCKS;
 }
+#endif
 
 static sector_t calculate_discard_block_size(sector_t cache_block_size,
 					     sector_t origin_size)
-- 
1.8.3.2

