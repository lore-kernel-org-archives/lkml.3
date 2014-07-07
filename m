Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080AbaGGMAj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 08:00:39 -0400
Received: from mx2.parallels.com ([199.115.105.18]:33070 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753022AbaGGMAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 08:00:34 -0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: <akpm@linux-foundation.org>
CC: <mhocko@suse.cz>, <hannes@cmpxchg.org>, <cl@linux.com>,
        <glommer@gmail.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH -mm 4/8] slub: remove kmemcg id from create_unique_id
Date: Mon, 7 Jul 2014 16:00:09 +0400
Message-ID: <314566c1c65e0d0b391539d828a6c499ca291ef6.1404733720.git.vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <cover.1404733720.git.vdavydov@parallels.com>
References: <cover.1404733720.git.vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function is never called for memcg caches, because they are
unmergeable, so remove the dead code.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
---
 mm/slub.c |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 1821e2096cbb..81f3823f3e03 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5153,12 +5153,6 @@ static char *create_unique_id(struct kmem_cache *s)
 		*p++ = '-';
 	p += sprintf(p, "%07d", s->size);
 
-#ifdef CONFIG_MEMCG_KMEM
-	if (!is_root_cache(s))
-		p += sprintf(p, "-%08d",
-				memcg_cache_id(s->memcg_params->memcg));
-#endif
-
 	BUG_ON(p > name + ID_STR_LENGTH - 1);
 	return name;
 }
-- 
1.7.10.4

