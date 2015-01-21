Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128AbbAUMpp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 07:45:45 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52327 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752039AbbAUMpp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 07:45:45 -0500
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>
Subject: [PATCH] genalloc: Check result of devres_alloc()
Date: Wed, 21 Jan 2015 13:45:41 +0100
Message-Id: <1421844341-15293-1-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_gen_pool_create() calls devres_alloc() and dereferences its result
without checking whether devres_alloc() succeeded. Check for error and
bail out if it happened.

Coverity-id: 1016493
Signed-off-by: Jan Kara <jack@suse.cz>
---
 lib/genalloc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/genalloc.c b/lib/genalloc.c
index 2e65d206b01c..094f8bee021f 100644
--- a/lib/genalloc.c
+++ b/lib/genalloc.c
@@ -587,6 +587,8 @@ struct gen_pool *devm_gen_pool_create(struct device *dev, int min_alloc_order,
 	struct gen_pool **ptr, *pool;
 
 	ptr = devres_alloc(devm_gen_pool_release, sizeof(*ptr), GFP_KERNEL);
+	if (!ptr)
+		return NULL;
 
 	pool = gen_pool_create(min_alloc_order, nid);
 	if (pool) {
-- 
2.1.2

