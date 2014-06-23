Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812AbaFWIce (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 04:32:34 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:55452 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752433AbaFWIc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:32:28 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Heinz Mauelshagen <heinzm@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 034/111] dm cache: always split discards on cache block boundaries
Date: Mon, 23 Jun 2014 10:31:09 +0200
Message-Id: <3ae4e547f5106b3610ff4e2ead70e4b6263477c2.1403512281.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
References: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
In-Reply-To: <cover.1403512280.git.jslaby@suse.cz>
References: <cover.1403512280.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heinz Mauelshagen <heinzm@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit f1daa838e861ae1a0fb7cd9721a21258430fcc8c upstream.

The DM cache target cannot cope with discards that span multiple cache
blocks, so each discard bio that spans more than one cache block must
get split by the DM core.

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Acked-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/md/dm-cache-target.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index d64bf7d6c8fe..0cf3700bfe9e 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -1932,6 +1932,8 @@ static int cache_create(struct cache_args *ca, struct cache **result)
 	ti->num_discard_bios = 1;
 	ti->discards_supported = true;
 	ti->discard_zeroes_data_unsupported = true;
+	/* Discard bios must be split on a block boundary */
+	ti->split_discard_bios = true;
 
 	cache->features = ca->features;
 	ti->per_bio_data_size = get_per_bio_data_size(cache);
-- 
2.0.0

