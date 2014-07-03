Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964868AbaGCWp0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 18:45:26 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:58360 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759847AbaGCWnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 18:43:40 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: linux-kernel@vger.kernel.org
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH 12/18] lib: bitmap: Simplify bitmap_parselist
Date: Fri,  4 Jul 2014 00:42:58 +0200
Message-Id: <1404427384-11422-13-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1404427384-11422-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1404427384-11422-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We want len to be the index of the first '\n', or the length of the
string if there is no newline. This is a good example of the
usefulness of strchrnul(). Use that instead, thus eliminating a branch
and a call to strlen().

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 lib/bitmap.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/lib/bitmap.c b/lib/bitmap.c
index 5d25403..d4b3a6d 100644
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -665,13 +665,8 @@ static int __bitmap_parselist(const char *buf, unsigned int buflen,
 
 int bitmap_parselist(const char *bp, unsigned long *maskp, int nmaskbits)
 {
-	char *nl  = strchr(bp, '\n');
-	int len;
-
-	if (nl)
-		len = nl - bp;
-	else
-		len = strlen(bp);
+	char *nl  = strchrnul(bp, '\n');
+	int len = nl - bp;
 
 	return __bitmap_parselist(bp, len, 0, maskp, nmaskbits);
 }
-- 
1.9.2

