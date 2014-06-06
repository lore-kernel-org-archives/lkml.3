Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665AbaFFRhr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 13:37:47 -0400
Received: from mout.web.de ([212.227.17.11]:60004 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751497AbaFFReu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 13:34:50 -0400
From: Ken Helias <kenhelias@web.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Ken Helias <kenhelias@firemail.de>,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 05/13] powerpc: Use list_add_(before|after) macros
Date: Fri,  6 Jun 2014 19:34:24 +0200
Message-Id: <1402076072-4044-5-git-send-email-kenhelias@web.de>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1402076072-4044-1-git-send-email-kenhelias@web.de>
References: <1402076072-4044-1-git-send-email-kenhelias@web.de>
X-Provags-ID: V03:K0:BjgfYiCFiWMPH2zru2OZfhULN35wf5uqJ488BApgTfKIiC8k0NF
 /2AEd0rksnxUoLFjAoMYA+1CigvYhNcFq/OMttHAZmlfecwqDcztuIO3CTZQqztDNJs+Fbo
 K22OWFYTrecVcvdmy4a3kBRUXoWo2KIsaZ6w2leViHEMcptccFXgHqqIYBfcgupc2n2pg7f
 JL9PxkxzSJ3Szd9S4wAbw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ken Helias <kenhelias@firemail.de>

Many places in the code uses list_add_tail/list_add to insert an entry
before/after another entry. This confuses the reader because these are usually
used to add an item to a list_head and not an entry. Better use the self
explaining function name.

Signed-off-by: Ken Helias <kenhelias@firemail.de>
Cc: linuxppc-dev@lists.ozlabs.org
---
 arch/powerpc/lib/rheap.c          | 2 +-
 arch/powerpc/mm/dma-noncoherent.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/lib/rheap.c b/arch/powerpc/lib/rheap.c
index a1060a8..d8c5f16 100644
--- a/arch/powerpc/lib/rheap.c
+++ b/arch/powerpc/lib/rheap.c
@@ -486,7 +486,7 @@ unsigned long rh_alloc_align(rh_info_t * info, int size, int alignment, const ch
 			spblk->start = blk->start;
 			spblk->size = sp_size;
 			/* add before the blk */
-			list_add(&spblk->list, blk->list.prev);
+			list_add_before(&spblk->list, &blk->list);
 		}
 		newblk = get_slot(info);
 		newblk->start = start;
diff --git a/arch/powerpc/mm/dma-noncoherent.c b/arch/powerpc/mm/dma-noncoherent.c
index d85e86a..222ae97 100644
--- a/arch/powerpc/mm/dma-noncoherent.c
+++ b/arch/powerpc/mm/dma-noncoherent.c
@@ -120,7 +120,7 @@ ppc_vm_region_alloc(struct ppc_vm_region *head, size_t size, gfp_t gfp)
 	/*
 	 * Insert this entry _before_ the one we found.
 	 */
-	list_add_tail(&new->vm_list, &c->vm_list);
+	list_add_before(&new->vm_list, &c->vm_list);
 	new->vm_start = addr;
 	new->vm_end = addr + size;
 
-- 
2.0.0

