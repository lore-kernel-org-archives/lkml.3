Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794AbaATJWL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 04:22:11 -0500
Received: from relay.parallels.com ([195.214.232.42]:46490 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030AbaATJWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 04:22:07 -0500
From: Vladimir Davydov <vdavydov@parallels.com>
To: <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: [PATCH TRIVIAL] memcg: remove unused code from kmem_cache_destroy_work_func
Date: Mon, 20 Jan 2014 13:22:03 +0400
Message-ID: <1390209723-11869-1-git-send-email-vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.30.16.96]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
---
 mm/memcontrol.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 7f1a356..7f1511d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3311,11 +3311,9 @@ static void kmem_cache_destroy_work_func(struct work_struct *w)
 	 * So if we aren't down to zero, we'll just schedule a worker and try
 	 * again
 	 */
-	if (atomic_read(&cachep->memcg_params->nr_pages) != 0) {
+	if (atomic_read(&cachep->memcg_params->nr_pages) != 0)
 		kmem_cache_shrink(cachep);
-		if (atomic_read(&cachep->memcg_params->nr_pages) == 0)
-			return;
-	} else
+	else
 		kmem_cache_destroy(cachep);
 }
 
-- 
1.7.10.4

