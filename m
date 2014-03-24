Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197AbaCXM7d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 08:59:33 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:51790 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753040AbaCXM7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 08:59:31 -0400
Message-Id: <20140324125926.111035579@openvz.org>
User-Agent: quilt/0.60-1
Date: Mon, 24 Mar 2014 16:28:41 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: hughd@google.com, xemul@parallels.com, akpm@linux-foundation.org,
        gorcunov@openvz.org
Subject: [patch 3/4] mm: Dont forget to save file map softdiry bit on unmap
References: <20140324122838.490106581@openvz.org>
Content-Disposition: inline; filename=mm-file-pte-softdirty-try_to_unmap_cluster
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pte_file_mksoft_dirty operates with argument passed by
a value and returns modified result thus need to assign
@ptfile here, otherwise it's nop operation which may lead
to lose of softdirty bit.

CC: Pavel Emelyanov <xemul@parallels.com>
CC: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 mm/rmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.git/mm/rmap.c
===================================================================
--- linux-2.6.git.orig/mm/rmap.c
+++ linux-2.6.git/mm/rmap.c
@@ -1339,7 +1339,7 @@ static int try_to_unmap_cluster(unsigned
 		if (page->index != linear_page_index(vma, address)) {
 			pte_t ptfile = pgoff_to_pte(page->index);
 			if (pte_soft_dirty(pteval))
-				pte_file_mksoft_dirty(ptfile);
+				ptfile = pte_file_mksoft_dirty(ptfile);
 			set_pte_at(mm, address, pte, ptfile);
 		}
 

