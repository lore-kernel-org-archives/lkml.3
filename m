Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933057AbbA2D1S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 22:27:18 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46923 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755522AbbA2CfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:35:16 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 059/139] dm cache: only use overwrite optimisation for promotion when in writeback mode
Date: Wed, 28 Jan 2015 14:20:02 -0800
Message-Id: <1422483682-15393-60-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422483682-15393-1-git-send-email-kamal@canonical.com>
References: <1422483682-15393-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Thornber <ejt@redhat.com>

commit f29a3147e251d7ae20d3194ff67f109d71e501b4 upstream.

Overwrite causes the cache block and origin blocks to diverge, which
is only allowed in writeback mode.

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/md/dm-cache-target.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 99474ef..b943ef1 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -1049,7 +1049,8 @@ static void issue_copy(struct dm_cache_migration *mg)
 
 		avoid = is_discarded_oblock(cache, mg->new_oblock);
 
-		if (!avoid && bio_writes_complete_block(cache, bio)) {
+		if (writeback_mode(&cache->features) &&
+		    !avoid && bio_writes_complete_block(cache, bio)) {
 			issue_overwrite(mg, bio);
 			return;
 		}
-- 
1.9.1

