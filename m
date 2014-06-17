Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966766AbaFQVvN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 17:51:13 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54527 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966746AbaFQVvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:51:07 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Heinz Mauelshagen <heinzm@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 179/212] dm cache: always split discards on cache block boundaries
Date: Tue, 17 Jun 2014 14:44:33 -0700
Message-Id: <1403041506-13646-180-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heinz Mauelshagen <heinzm@redhat.com>

commit f1daa838e861ae1a0fb7cd9721a21258430fcc8c upstream.

The DM cache target cannot cope with discards that span multiple cache
blocks, so each discard bio that spans more than one cache block must
get split by the DM core.

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Acked-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/md/dm-cache-target.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 1d30f65..fd92101 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -2184,6 +2184,8 @@ static int cache_create(struct cache_args *ca, struct cache **result)
 	ti->num_discard_bios = 1;
 	ti->discards_supported = true;
 	ti->discard_zeroes_data_unsupported = true;
+	/* Discard bios must be split on a block boundary */
+	ti->split_discard_bios = true;
 
 	cache->features = ca->features;
 	ti->per_bio_data_size = get_per_bio_data_size(cache);
-- 
1.9.1

