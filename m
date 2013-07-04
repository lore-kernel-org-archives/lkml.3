Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933588Ab3GDAd7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 20:33:59 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:59144 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932424Ab3GDAdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 20:33:45 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Pekka Enberg <penberg@kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>
Cc: Glauber Costa <glommer@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <js1304@gmail.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH v3 5/5] mm/slub: Use node_nr_slabs and node_nr_objs in get_slabinfo
Date: Thu,  4 Jul 2013 08:33:26 +0800
Message-Id: <1372898006-6308-5-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1372898006-6308-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1372898006-6308-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13070400-0260-0000-0000-000003426575
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use existing interface node_nr_slabs and node_nr_objs to get
nr_slabs and nr_objs.

Acked-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 mm/slub.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 84b84f4..d9135a8 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5280,8 +5280,8 @@ void get_slabinfo(struct kmem_cache *s, struct slabinfo *sinfo)
 		if (!n)
 			continue;
 
-		nr_slabs += atomic_long_read(&n->nr_slabs);
-		nr_objs += atomic_long_read(&n->total_objects);
+		nr_slabs += node_nr_slabs(n);
+		nr_objs += node_nr_objs(n);
 		nr_free += count_partial(n, count_free);
 	}
 
-- 
1.8.1.2

