Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757092Ab3GLHIf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 03:08:35 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:17275 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289Ab3GLHIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 03:08:34 -0400
X-AuditID: cbfee61b-b7f8e6d00000524c-9b-51dfab7092db
From: Sunghan Suh <sunghan.suh@samsung.com>
To: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, minchan@kernel.org,
        sjenning@linux.vnet.ibm.com, Sunghan Suh <sunghan.suh@samsung.com>
Subject: [PATCH] staging: zsmalloc: access page->private by using page_private
 macro
Date: Fri, 12 Jul 2013 16:08:13 +0900
Message-id: <1373612893-13058-1-git-send-email-sunghan.suh@samsung.com>
X-Mailer: git-send-email 1.8.1.2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJJMWRmVeSWpSXmKPExsVy+t9jAd2C1fcDDR69ELbYc+YXu0Xz4vVs
	Fpd3zWGzWPb1PbvFoX2r2C1O3z7E5MDmcW/fYRaPTas62TweHNrM4rF/7hp2j74tqxg9Pm+S
	C2CL4rJJSc3JLEst0rdL4Mp4OGkrS0EjR8XJi1ENjGfYuhg5OSQETCR2HzrJDmGLSVy4tx4o
	zsUhJLCIUaL1zUmwIiGBFiaJr2tqQWw2AW2JqztuMYHYIgI2Ejv23gOq4eBgFqiQWHncASQs
	LBAm8f/CGmYQm0VAVaLt2kEWEJtXwF2i5+QHJohdChI/L59gm8DIvYCRYRWjaGpBckFxUnqu
	kV5xYm5xaV66XnJ+7iZGcIA8k97BuKrB4hCjAAejEg9vwYl7gUKsiWXFlbmHGCU4mJVEeG+a
	3Q8U4k1JrKxKLcqPLyrNSS0+xCjNwaIkznuw1TpQSCA9sSQ1OzW1ILUIJsvEwSnVwMh46veB
	A2UcHkHBPFqVe47sb92xboVmZjOvpojgZ46bdaH+q8VS9aS+fz50yGzmvrkrzxTwJlm69f/I
	Vyy4tejD8dv/jQ/2cdYEr57lmnts4V1pbaYLe3yvCQqtsTYP293/8FHNnge7p8378+RykIHV
	Eze/whXbGM97nPTfpRbrZR3keOVNkokSS3FGoqEWc1FxIgAtoCsZDAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sunghan Suh <sunghan.suh@samsung.com>
---
 drivers/staging/zsmalloc/zsmalloc-main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/zsmalloc/zsmalloc-main.c b/drivers/staging/zsmalloc/zsmalloc-main.c
index 4bb275b..1a67537 100644
--- a/drivers/staging/zsmalloc/zsmalloc-main.c
+++ b/drivers/staging/zsmalloc/zsmalloc-main.c
@@ -423,7 +423,7 @@ static struct page *get_next_page(struct page *page)
 	if (is_last_page(page))
 		next = NULL;
 	else if (is_first_page(page))
-		next = (struct page *)page->private;
+		next = (struct page *)page_private(page);
 	else
 		next = list_entry(page->lru.next, struct page, lru);
 
@@ -581,7 +581,7 @@ static struct page *alloc_zspage(struct size_class *class, gfp_t flags)
 			first_page->inuse = 0;
 		}
 		if (i == 1)
-			first_page->private = (unsigned long)page;
+			set_page_private(first_page, (unsigned long)page);
 		if (i >= 1)
 			page->first_page = first_page;
 		if (i >= 2)
-- 
1.8.1.2

