Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758797Ab3FCPjn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 11:39:43 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:34192 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758696Ab3FCPjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 11:39:40 -0400
Message-ID: <51ACB8B6.60603@gmail.com>
Date: Mon, 03 Jun 2013 23:39:34 +0800
From: Zhang Yanfei <zhangyanfei.yes@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120607 Thunderbird/10.0.5
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>
Subject: [PATCH] mm, vmalloc: Use clamp to simplify code
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 mm/vmalloc.c |   12 ++----------
 1 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index d365724..2d7eb81 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1337,16 +1337,8 @@ static struct vm_struct *__get_vm_area_node(unsigned long size,
 	struct vm_struct *area;
 
 	BUG_ON(in_interrupt());
-	if (flags & VM_IOREMAP) {
-		int bit = fls(size);
-
-		if (bit > IOREMAP_MAX_ORDER)
-			bit = IOREMAP_MAX_ORDER;
-		else if (bit < PAGE_SHIFT)
-			bit = PAGE_SHIFT;
-
-		align = 1ul << bit;
-	}
+	if (flags & VM_IOREMAP)
+		align = 1ul << clamp(fls(size), PAGE_SHIFT, IOREMAP_MAX_ORDER);
 
 	size = PAGE_ALIGN(size);
 	if (unlikely(!size))
-- 
1.7.1
