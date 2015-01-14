Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988AbbANVCM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 16:02:12 -0500
Received: from mail-la0-f45.google.com ([209.85.215.45]:39820 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbbANVCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 16:02:07 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-kernel@vger.kernel.org
Subject: [PATCH] lib/string.c: Improve strrchr
Date: Wed, 14 Jan 2015 22:01:51 +0100
Message-Id: <1421269311-28965-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of potentially passing over the string twice in case c is not
found, just keep track of the last occurrence. According to
bloat-o-meter, this also cuts the generated code by a third (54 vs 36
bytes). Oh, and we get rid of those 7-space indented lines.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 lib/string.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/lib/string.c b/lib/string.c
index 10063300b830..f112a7fd1893 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -321,12 +321,12 @@ EXPORT_SYMBOL(strchrnul);
  */
 char *strrchr(const char *s, int c)
 {
-       const char *p = s + strlen(s);
-       do {
-           if (*p == (char)c)
-               return (char *)p;
-       } while (--p >= s);
-       return NULL;
+	const char *last = NULL;
+	do {
+		if (*s == (char)c)
+			last = s;
+	} while (*s++);
+	return (char *)last;
 }
 EXPORT_SYMBOL(strrchr);
 #endif
-- 
2.1.3

