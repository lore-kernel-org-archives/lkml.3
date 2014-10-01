Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916AbaJAUxd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 16:53:33 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:44354 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192AbaJAUxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 16:53:32 -0400
From: Paul McQuade <paulmcquad@gmail.com>
To: paulmcquad@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, sato.vintage@gmail.com,
        daeseok.youn@gmail.com, andriy.shevchenko@linux.intel.com,
        jkosina@suse.cz, khalasa@piap.pl, akpm@linux-foundation.org
Subject: [PATCH] MM: dmapool: Fixed a brace coding style issue
Date: Wed,  1 Oct 2014 21:53:27 +0100
Message-Id: <1412196807-9990-1-git-send-email-paulmcquad@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed 3 brace coding style for any arm of this statement

Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
---
 mm/dmapool.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/mm/dmapool.c b/mm/dmapool.c
index ba8019b..8f4a79a 100644
--- a/mm/dmapool.c
+++ b/mm/dmapool.c
@@ -133,28 +133,25 @@ struct dma_pool *dma_pool_create(const char *name, struct device *dev,
 	struct dma_pool *retval;
 	size_t allocation;
 
-	if (align == 0) {
+	if (align == 0)
 		align = 1;
-	} else if (align & (align - 1)) {
+	else if (align & (align - 1))
 		return NULL;
-	}
 
-	if (size == 0) {
+	if (size == 0)
 		return NULL;
-	} else if (size < 4) {
+	else if (size < 4)
 		size = 4;
-	}
 
 	if ((size % align) != 0)
 		size = ALIGN(size, align);
 
 	allocation = max_t(size_t, size, PAGE_SIZE);
 
-	if (!boundary) {
+	if (!boundary)
 		boundary = allocation;
-	} else if ((boundary < size) || (boundary & (boundary - 1))) {
+	else if ((boundary < size) || (boundary & (boundary - 1)))
 		return NULL;
-	}
 
 	retval = kmalloc_node(sizeof(*retval), GFP_KERNEL, dev_to_node(dev));
 	if (!retval)
-- 
1.9.1

