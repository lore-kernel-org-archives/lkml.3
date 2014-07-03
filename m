Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759990AbaGCWnr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 18:43:47 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:57254 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759962AbaGCWno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 18:43:44 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: linux-kernel@vger.kernel.org
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH 15/18] lib: bitmap: Micro-optimize bitmap_allocate_region
Date: Fri,  4 Jul 2014 00:43:01 +0200
Message-Id: <1404427384-11422-16-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1404427384-11422-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1404427384-11422-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__reg_op(..., REG_OP_ALLOC) always returns 0, so we might as well use
that and save an instruction.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 lib/bitmap.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/lib/bitmap.c b/lib/bitmap.c
index c2f3807..faaf720 100644
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -1154,8 +1154,7 @@ int bitmap_allocate_region(unsigned long *bitmap, unsigned int pos, int order)
 {
 	if (!__reg_op(bitmap, pos, order, REG_OP_ISFREE))
 		return -EBUSY;
-	__reg_op(bitmap, pos, order, REG_OP_ALLOC);
-	return 0;
+	return __reg_op(bitmap, pos, order, REG_OP_ALLOC);
 }
 EXPORT_SYMBOL(bitmap_allocate_region);
 
-- 
1.9.2

