Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934001Ab3JOXhA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 19:37:00 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:44710 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933597Ab3JOXg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 19:36:58 -0400
From: Felipe Pena <felipensp@gmail.com>
To: Kent Overstreet <kmo@daterainc.com>, Neil Brown <neilb@suse.de>
Cc: linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org, Felipe Pena <felipensp@gmail.com>
Subject: [PATCH] drivers: md: bcache: Fix wrong check on can_attach_cache
Date: Tue, 15 Oct 2013 20:37:22 -0300
Message-Id: <1381880242-3858-1-git-send-email-felipensp@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a wrong check on can_attach_cache() function which
bucket_size is compared to block_size value.

Signed-off-by: Felipe Pena <felipensp@gmail.com>
---
 drivers/md/bcache/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 547c4c5..d5bc1eb 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1650,7 +1650,7 @@ err:
 static bool can_attach_cache(struct cache *ca, struct cache_set *c)
 {
 	return ca->sb.block_size	== c->sb.block_size &&
-		ca->sb.bucket_size	== c->sb.block_size &&
+		ca->sb.bucket_size	== c->sb.bucket_size &&
 		ca->sb.nr_in_set	== c->sb.nr_in_set;
 }

--
1.7.10.4

