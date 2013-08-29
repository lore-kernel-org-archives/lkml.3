Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757281Ab3H2ULy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 16:11:54 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:59185 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757112Ab3H2ULv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 16:11:51 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org
Subject: [PATCH 4/6] aio: Convert kmem_cache_alloc(...GFP_ZERO) to kmem_cache_zalloc
Date: Thu, 29 Aug 2013 13:11:08 -0700
Message-Id: <b9649ad775290bd037d4af8ca9b6ddff64c1345b.1377806578.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1377806578.git.joe@perches.com>
References: <cover.1377806578.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The helper exists, might as well use it instead of __GFP_ZERO.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/aio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/aio.c b/fs/aio.c
index 9f783e3..f680878 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -774,7 +774,7 @@ static inline struct kiocb *aio_get_req(struct kioctx *ctx)
 	if (!get_reqs_available(ctx))
 		return NULL;
 
-	req = kmem_cache_alloc(kiocb_cachep, GFP_KERNEL|__GFP_ZERO);
+	req = kmem_cache_zalloc(kiocb_cachep, GFP_KERNEL);
 	if (unlikely(!req))
 		goto out_put;
 
-- 
1.8.1.2.459.gbcd45b4.dirty

