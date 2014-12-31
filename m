Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536AbaLaBWh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 20:22:37 -0500
Received: from mail-la0-f48.google.com ([209.85.215.48]:42484 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490AbaLaBWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 20:22:32 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-kernel@vger.kernel.org
Subject: [PATCH 15/19] lib/sort.c: Move include inside #if 0
Date: Wed, 31 Dec 2014 02:21:50 +0100
Message-Id: <1419988915-20730-16-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1419988915-20730-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1419988915-20730-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sort function and its helpers don't do memory allocation, so the
slab.h include is redundant. Move it inside the #if 0 protecting the
self-test, similar to how it is done in lib/list_sort.c. This removes
over 450 lines from the generated dependency file.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 lib/sort.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/sort.c b/lib/sort.c
index 14fc1dfadb3f..43c9fe73ae2e 100644
--- a/lib/sort.c
+++ b/lib/sort.c
@@ -7,7 +7,6 @@
 #include <linux/types.h>
 #include <linux/export.h>
 #include <linux/sort.h>
-#include <linux/slab.h>
 
 static void u32_swap(void *a, void *b, int size)
 {
@@ -85,6 +84,7 @@ void sort(void *base, size_t num, size_t size,
 EXPORT_SYMBOL(sort);
 
 #if 0
+#include <linux/slab.h>
 /* a simple boot-time regression test */
 
 int cmpint(const void *a, const void *b)
-- 
2.1.3

