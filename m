Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548AbaLWEti (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 23:49:38 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:38322 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002AbaLWEth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 23:49:37 -0500
X-Original-SENDERIP: 10.177.222.213
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Bolle <pebolle@tiscali.nl>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH] mm/debug_pagealloc: remove obsolete Kconfig options
Date: Tue, 23 Dec 2014 13:53:57 +0900
Message-Id: <1419310437-9193-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are obsolete since commit e30825f1869a ("mm/debug-pagealloc:
prepare boottime configurable on/off") is merged. Remove them.

Reported-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
---
 mm/Kconfig.debug |    9 ---------
 1 file changed, 9 deletions(-)

diff --git a/mm/Kconfig.debug b/mm/Kconfig.debug
index 56badfc..957d3da 100644
--- a/mm/Kconfig.debug
+++ b/mm/Kconfig.debug
@@ -14,7 +14,6 @@ config DEBUG_PAGEALLOC
 	depends on !KMEMCHECK
 	select PAGE_EXTENSION
 	select PAGE_POISONING if !ARCH_SUPPORTS_DEBUG_PAGEALLOC
-	select PAGE_GUARD if ARCH_SUPPORTS_DEBUG_PAGEALLOC
 	---help---
 	  Unmap pages from the kernel linear mapping after free_pages().
 	  This results in a large slowdown, but helps to find certain types
@@ -27,13 +26,5 @@ config DEBUG_PAGEALLOC
 	  that would result in incorrect warnings of memory corruption after
 	  a resume because free pages are not saved to the suspend image.
 
-config WANT_PAGE_DEBUG_FLAGS
-	bool
-
 config PAGE_POISONING
 	bool
-	select WANT_PAGE_DEBUG_FLAGS
-
-config PAGE_GUARD
-	bool
-	select WANT_PAGE_DEBUG_FLAGS
-- 
1.7.9.5

