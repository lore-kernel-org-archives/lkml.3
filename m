Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978AbaK1QBv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 11:01:51 -0500
Received: from mail-lb0-f170.google.com ([209.85.217.170]:60014 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408AbaK1QBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 11:01:49 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/7] lib: bitmap: Remove redundant code from __bitmap_shift_right
Date: Fri, 28 Nov 2014 17:01:06 +0100
Message-Id: <1417190476-18066-4-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1417190476-18066-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1417190476-18066-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the condition k==lim-1 is true, we must have off == 0 (otherwise, k
could never become that big). But in that case we have upper == 0 and
hence dst[k] == (src[k] & mask) >> rem. Since mask consists of a
consecutive range of bits starting from the LSB, anding dst[k] with
mask is a no-op.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 lib/bitmap.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/lib/bitmap.c b/lib/bitmap.c
index 9250c3f..20bb314 100644
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -134,8 +134,6 @@ void __bitmap_shift_right(unsigned long *dst, const unsigned long *src,
 			lower &= mask;
 		lower >>= rem;
 		dst[k] = lower | upper;
-		if (left && k == lim - 1)
-			dst[k] &= mask;
 	}
 	if (off)
 		memset(&dst[lim - off], 0, off*sizeof(unsigned long));
-- 
2.0.4

