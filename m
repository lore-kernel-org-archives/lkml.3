Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751673Ab3FHIkY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jun 2013 04:40:24 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:53961 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475Ab3FHIkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jun 2013 04:40:19 -0400
Message-ID: <51B2EDE4.1070109@gmail.com>
Date: Sat, 08 Jun 2013 16:40:04 +0800
From: Zhang Yanfei <zhangyanfei.yes@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120607 Thunderbird/10.0.5
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>
Subject: [PATCH -mm] mm, vmalloc: Prompt the failure message before return
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>

Use goto to jump to the fail label to give a failure message before
returning NULL. This makes the failure handling in this function
consistent.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 mm/vmalloc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 91a1047..9a0d711 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1664,7 +1664,7 @@ void *__vmalloc_node_range(unsigned long size, unsigned long align,
 
 	addr = __vmalloc_area_node(area, gfp_mask, prot, node, caller);
 	if (!addr)
-		return NULL;
+		goto fail;
 
 	/*
 	 * In this function, newly allocated vm_struct has VM_UNLIST flag.
-- 
1.7.1
