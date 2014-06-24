Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010AbaFXOAO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 10:00:14 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:45202 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482AbaFXOAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 10:00:12 -0400
Message-ID: <1403618407.3796.15.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: [PATCH] mm/vmalloc.c: add a schedule point to vmalloc()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hugh Dickins <hughd@google.com>, David Rientjes <rientjes@google.com>
Date: Tue, 24 Jun 2014 07:00:07 -0700
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

It is not uncommon on busy servers to get stuck hundred of ms in
vmalloc() calls (like file descriptor expansions).

Add a cond_resched() to __vmalloc_area_node() to be gentle to
other tasks.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: David Rientjes <rientjes@google.com>
---
 mm/vmalloc.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index f64632b67196..05a145ed1332 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1602,6 +1602,7 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 			goto fail;
 		}
 		area->pages[i] = page;
+		cond_resched();
 	}
 
 	if (map_vm_area(area, prot, &pages))


