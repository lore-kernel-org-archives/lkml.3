Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531AbaFWNYE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 09:24:04 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36893 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754233AbaFWNEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 09:04:15 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Heinz Mauelshagen <heinzm@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 38/93] dm cache: always split discards on cache block boundaries
Date: Mon, 23 Jun 2014 14:02:17 +0100
Message-Id: <1403528592-2163-39-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403528592-2163-1-git-send-email-luis.henriques@canonical.com>
References: <1403528592-2163-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heinz Mauelshagen <heinzm@redhat.com>

commit f1daa838e861ae1a0fb7cd9721a21258430fcc8c upstream.

The DM cache target cannot cope with discards that span multiple cache
blocks, so each discard bio that spans more than one cache block must
get split by the DM core.

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Acked-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/md/dm-cache-target.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 8175041200c7..cb51c1d05417 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -1929,6 +1929,8 @@ static int cache_create(struct cache_args *ca, struct cache **result)
 	ti->num_discard_bios = 1;
 	ti->discards_supported = true;
 	ti->discard_zeroes_data_unsupported = true;
+	/* Discard bios must be split on a block boundary */
+	ti->split_discard_bios = true;
 
 	cache->features = ca->features;
 	ti->per_bio_data_size = get_per_bio_data_size(cache);
-- 
1.9.1

