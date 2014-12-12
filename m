Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968230AbaLLOoK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 09:44:10 -0500
Received: from mail-la0-f51.google.com ([209.85.215.51]:42783 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968081AbaLLOoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 09:44:05 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] lib: string_get_size: Return void
Date: Fri, 12 Dec 2014 15:43:48 +0100
Message-Id: <1418395428-25980-3-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418395428-25980-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1418395428-25980-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

string_get_size was documented to return an error, but in fact always
returned 0. Since the output always fits in 9 bytes, just document
that and let callers do what they do now: Pass a small stack buffer
and ignore the return value.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 include/linux/string_helpers.h |  4 ++--
 lib/string_helpers.c           | 10 ++++------
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/include/linux/string_helpers.h b/include/linux/string_helpers.h
index 6eb567ac56bc..657571817260 100644
--- a/include/linux/string_helpers.h
+++ b/include/linux/string_helpers.h
@@ -10,8 +10,8 @@ enum string_size_units {
 	STRING_UNITS_2,		/* use binary powers of 2^10 */
 };
 
-int string_get_size(u64 size, enum string_size_units units,
-		    char *buf, int len);
+void string_get_size(u64 size, enum string_size_units units,
+		     char *buf, int len);
 
 #define UNESCAPE_SPACE		0x01
 #define UNESCAPE_OCTAL		0x02
diff --git a/lib/string_helpers.c b/lib/string_helpers.c
index 2b3757f84b3b..8f8c4417f228 100644
--- a/lib/string_helpers.c
+++ b/lib/string_helpers.c
@@ -20,12 +20,12 @@
  * @len:	length of buffer
  *
  * This function returns a string formatted to 3 significant figures
- * giving the size in the required units.  Returns 0 on success or
- * error on failure.  @buf is always zero terminated.
+ * giving the size in the required units.  @buf should have room for
+ * at least 9 bytes and will always be zero terminated.
  *
  */
-int string_get_size(u64 size, const enum string_size_units units,
-		    char *buf, int len)
+void string_get_size(u64 size, const enum string_size_units units,
+		     char *buf, int len)
 {
 	static const char *const units_10[] = {
 		"B", "kB", "MB", "GB", "TB", "PB", "EB"
@@ -67,8 +67,6 @@ int string_get_size(u64 size, const enum string_size_units units,
 
 	snprintf(buf, len, "%u%s %s", (u32)size,
 		 tmp, units_str[units][i]);
-
-	return 0;
 }
 EXPORT_SYMBOL(string_get_size);
 
-- 
2.1.3

