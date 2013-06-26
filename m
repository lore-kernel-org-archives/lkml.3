Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841Ab3FZX6A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 19:58:00 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:59057 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671Ab3FZX56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 19:57:58 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Pekka Enberg <penberg@kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>
Cc: Glauber Costa <glommer@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <js1304@gmail.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH 3/3] mm/slub: Use node_nr_slabs and node_nr_objs in get_slabinfo
Date: Thu, 27 Jun 2013 07:57:39 +0800
Message-Id: <1372291059-9880-3-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1372291059-9880-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1372291059-9880-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062623-6102-0000-0000-000003C38894
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use existing interface node_nr_slabs and node_nr_objs to get
nr_slabs and nr_objs.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 mm/slub.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index e303b04..52098c2 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5287,8 +5287,8 @@ void get_slabinfo(struct kmem_cache *s, struct slabinfo *sinfo)
 		if (!n)
 			continue;
 
-		nr_slabs += atomic_long_read(&n->nr_slabs);
-		nr_objs += atomic_long_read(&n->total_objects);
+		nr_slabs += node_nr_slabs(n);
+		nr_objs += node_nr_objs(n);
 		nr_free += count_partial(n, &nr_inactive, count_free);
 		nr_inactive_slabs += nr_inactive;
 	}
-- 
1.8.1.2

