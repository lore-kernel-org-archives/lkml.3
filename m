Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932955AbaGVW6J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 18:58:09 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:33932 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932213AbaGVW6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 18:58:03 -0400
Date: Tue, 22 Jul 2014 15:58:01 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Vladimir Davydov <vdavydov@parallels.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Christoph Lameter <cl@linux.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [patch 2/2] mm, slub: fix some indenting in cmpxchg_double_slab()
In-Reply-To: <alpine.DEB.2.02.1407221550500.9885@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.02.1407221557040.9885@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1407221550500.9885@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

The return statement goes with the cmpxchg_double() condition so it
needs to be indented another tab.

Also these days the fashion is to line function parameters up, and it
looks nicer that way because then the "freelist_new" is not at the same
indent level as the "return 1;".

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/slub.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -382,9 +382,9 @@ static inline bool __cmpxchg_double_slab(struct kmem_cache *s, struct page *page
     defined(CONFIG_HAVE_ALIGNED_STRUCT_PAGE)
 	if (s->flags & __CMPXCHG_DOUBLE) {
 		if (cmpxchg_double(&page->freelist, &page->counters,
-			freelist_old, counters_old,
-			freelist_new, counters_new))
-		return 1;
+				   freelist_old, counters_old,
+				   freelist_new, counters_new))
+			return 1;
 	} else
 #endif
 	{
@@ -418,9 +418,9 @@ static inline bool cmpxchg_double_slab(struct kmem_cache *s, struct page *page,
     defined(CONFIG_HAVE_ALIGNED_STRUCT_PAGE)
 	if (s->flags & __CMPXCHG_DOUBLE) {
 		if (cmpxchg_double(&page->freelist, &page->counters,
-			freelist_old, counters_old,
-			freelist_new, counters_new))
-		return 1;
+				   freelist_old, counters_old,
+				   freelist_new, counters_new))
+			return 1;
 	} else
 #endif
 	{
