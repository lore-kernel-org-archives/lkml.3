Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758405AbaGXBQj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 21:16:39 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:49778 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788AbaGXBQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 21:16:35 -0400
Date: Wed, 23 Jul 2014 18:16:32 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [patch 2/3] mm, oom: remove unnecessary check for NULL zonelist
In-Reply-To: <alpine.DEB.2.02.1407231814110.22326@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.02.1407231815090.22326@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1407231814110.22326@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the pagefault handler is modified to pass a non-NULL zonelist then an 
unnecessary check for a NULL zonelist in constrained_alloc() can be removed.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/oom_kill.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -208,8 +208,6 @@ static enum oom_constraint constrained_alloc(struct zonelist *zonelist,
 	/* Default to all available memory */
 	*totalpages = totalram_pages + total_swap_pages;
 
-	if (!zonelist)
-		return CONSTRAINT_NONE;
 	/*
 	 * Reach here only when __GFP_NOFAIL is used. So, we should avoid
 	 * to kill current.We have to random task kill in this case.
@@ -696,7 +694,7 @@ void pagefault_out_of_memory(void)
 
 	zonelist = node_zonelist(first_memory_node, GFP_KERNEL);
 	if (try_set_zonelist_oom(zonelist, GFP_KERNEL)) {
-		out_of_memory(NULL, 0, 0, NULL, false);
+		out_of_memory(zonelist, 0, 0, NULL, false);
 		clear_zonelist_oom(zonelist, GFP_KERNEL);
 	}
 }
