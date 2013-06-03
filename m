Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758840Ab3FCPfR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 11:35:17 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:65027 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756753Ab3FCPfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 11:35:12 -0400
Message-ID: <51ACB7AA.5050705@gmail.com>
Date: Mon, 03 Jun 2013 23:35:06 +0800
From: Zhang Yanfei <zhangyanfei.yes@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120607 Thunderbird/10.0.5
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Joonsoo Kim <iamjoonsoo.kim@lge.com>, Joonsoo Kim <js1304@gmail.com>,
        Linux MM <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] mm, vmalloc: Remove insert_vmalloc_vm
References: <51ACB6DB.6040809@gmail.com>
In-Reply-To: <51ACB6DB.6040809@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>

Now this function is nowhere used, we can remove it directly.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 mm/vmalloc.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index edbfad0..e0a786d 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1322,13 +1322,6 @@ static void clear_vm_unlist(struct vm_struct *vm)
 	vm->flags &= ~VM_UNLIST;
 }
 
-static void insert_vmalloc_vm(struct vm_struct *vm, struct vmap_area *va,
-			      unsigned long flags, const void *caller)
-{
-	setup_vmalloc_vm(vm, va, flags, caller);
-	clear_vm_unlist(vm);
-}
-
 static struct vm_struct *__get_vm_area_node(unsigned long size,
 		unsigned long align, unsigned long flags, unsigned long start,
 		unsigned long end, int node, gfp_t gfp_mask, const void *caller)
-- 
1.7.1

