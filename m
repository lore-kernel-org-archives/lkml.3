Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751181AbaI3Ut4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 16:49:56 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:54016 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbaI3Utz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 16:49:55 -0400
Message-ID: <542B176E.6000007@gmail.com>
Date: Tue, 30 Sep 2014 21:49:50 +0100
From: Paul McQuade <paulmcquad@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        =?UTF-8?B?S3J6eXN6dG9mIEhh?= =?UTF-8?B?xYJhc2E=?= 
	<khalasa@piap.pl>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        jiri Kosina <jkosina@suse.cz>, Hiroshige Sato <sato.vintage@gmail.com>,
        Daeseok Youn <daeseok.youn@gmail.com>, linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Paul McQuade <paulmcquad@gmail.com>
Subject: [PATCH] MM: dmapool: Fixed a brace coding style issue
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 33890970bfffc2bd64b307c41e5c1c92aaba8a2e Mon Sep 17 00:00:00 2001
From: Paul McQuade <paulmcquad@gmail.com>
Date: Tue, 30 Sep 2014 21:39:37 +0100
Subject: [PATCH] MM: dmapool: Fixed a brace coding style issue

Removed 3 brace coding style for any arm of this statement

Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
---
 mm/dmapool.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/mm/dmapool.c b/mm/dmapool.c
index ba8019b..8b3b050 100644
--- a/mm/dmapool.c
+++ b/mm/dmapool.c
@@ -133,28 +133,27 @@ struct dma_pool *dma_pool_create(const char *name, struct device *dev,
     struct dma_pool *retval;
     size_t allocation;
 
-    if (align == 0) {
+    if (align == 0)
         align = 1;
-    } else if (align & (align - 1)) {
+    else if (align & (align - 1))
         return NULL;
-    }
 
-    if (size == 0) {
+
+    if (size == 0)
         return NULL;
-    } else if (size < 4) {
+    else if (size < 4)
         size = 4;
-    }
+
 
     if ((size % align) != 0)
         size = ALIGN(size, align);
 
     allocation = max_t(size_t, size, PAGE_SIZE);
 
-    if (!boundary) {
+    if (!boundary)
         boundary = allocation;
-    } else if ((boundary < size) || (boundary & (boundary - 1))) {
+    else if ((boundary < size) || (boundary & (boundary - 1)))
         return NULL;
-    }
 
     retval = kmalloc_node(sizeof(*retval), GFP_KERNEL, dev_to_node(dev));
     if (!retval)
-- 
1.9.1

