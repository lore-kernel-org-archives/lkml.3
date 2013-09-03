Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932728Ab3ICKho (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 06:37:44 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:55507 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932704Ab3ICKhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 06:37:42 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>, David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH v5 2/4] mm/vmalloc: revert "mm/vmalloc.c: emit the failure message before return"
Date: Tue,  3 Sep 2013 18:37:26 +0800
Message-Id: <1378204648-28392-2-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1378204648-28392-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1378204648-28392-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13090310-1396-0000-0000-0000037F7703
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changelog:
 *v2 -> v3: revert commit 46c001a2 directly

Don't warning twice in __vmalloc_area_node and __vmalloc_node_range if
__vmalloc_area_node allocation failure. This patch revert commit 46c001a2
(mm/vmalloc.c: emit the failure message before return).

Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 mm/vmalloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index d78d117..e3ec8b4 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1635,7 +1635,7 @@ void *__vmalloc_node_range(unsigned long size, unsigned long align,
 
 	addr = __vmalloc_area_node(area, gfp_mask, prot, node, caller);
 	if (!addr)
-		goto fail;
+		return NULL;
 
 	/*
 	 * In this function, newly allocated vm_struct has VM_UNINITIALIZED
-- 
1.8.1.2

