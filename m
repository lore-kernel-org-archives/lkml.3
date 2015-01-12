Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704AbbALSXm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:23:42 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57569 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753561AbbALSGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:06:08 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 060/216] dm cache: only use overwrite optimisation for promotion when in writeback mode
Date: Mon, 12 Jan 2015 18:02:57 +0000
Message-Id: <1421085933-32536-61-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Thornber <ejt@redhat.com>

commit f29a3147e251d7ae20d3194ff67f109d71e501b4 upstream.

Overwrite causes the cache block and origin blocks to diverge, which
is only allowed in writeback mode.

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/md/dm-cache-target.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index c892e48655c2..e5bb12810ccc 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -1043,7 +1043,8 @@ static void issue_copy(struct dm_cache_migration *mg)
 
 		avoid = is_discarded_oblock(cache, mg->new_oblock);
 
-		if (!avoid && bio_writes_complete_block(cache, bio)) {
+		if (writeback_mode(&cache->features) &&
+		    !avoid && bio_writes_complete_block(cache, bio)) {
 			issue_overwrite(mg, bio);
 			return;
 		}
-- 
2.1.4

