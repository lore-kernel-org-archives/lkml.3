Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890Ab3GQJFd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 05:05:33 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:53503 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995Ab3GQJFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 05:05:31 -0400
From: Dragos Foianu <dragos.foianu@gmail.com>
To: gregkh@linuxfoundation.org
Cc: andreas.dilger@intel.com, tao.peng@emc.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Dragos Foianu <dragos.foianu@gmail.com>
Subject: [PATCH] staging/lustre/libcfs: removed dead code from libcfs_string
Date: Wed, 17 Jul 2013 12:05:24 +0100
Message-Id: <1374059124-4126-1-git-send-email-dragos.foianu@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Confirmed by cscope that the functions are not used anymore. A fresh compilation does not yield any errors.

Signed-off-by: Dragos Foianu <dragos.foianu@gmail.com>
---
 .../staging/lustre/lustre/libcfs/libcfs_string.c   |   48 --------------------
 1 file changed, 48 deletions(-)

diff --git a/drivers/staging/lustre/lustre/libcfs/libcfs_string.c b/drivers/staging/lustre/lustre/libcfs/libcfs_string.c
index 9edccc9..c7a1971 100644
--- a/drivers/staging/lustre/lustre/libcfs/libcfs_string.c
+++ b/drivers/staging/lustre/lustre/libcfs/libcfs_string.c
@@ -132,54 +132,6 @@ int cfs_str2mask(const char *str, const char *(*bit2str)(int bit),
 }
 EXPORT_SYMBOL(cfs_str2mask);
 
-/* Duplicate a string in a platform-independent way */
-char *cfs_strdup(const char *str, u_int32_t flags)
-{
-	size_t lenz; /* length of str + zero byte */
-	char *dup_str;
-
-	lenz = strlen(str) + 1;
-
-	dup_str = kmalloc(lenz, flags);
-	if (dup_str == NULL)
-		return NULL;
-
-	memcpy(dup_str, str, lenz);
-
-	return dup_str;
-}
-EXPORT_SYMBOL(cfs_strdup);
-
-/**
- * cfs_{v}snprintf() return the actual size that is printed rather than
- * the size that would be printed in standard functions.
- */
-/* safe vsnprintf */
-int cfs_vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
-{
-	int i;
-
-	LASSERT(size > 0);
-	i = vsnprintf(buf, size, fmt, args);
-
-	return  (i >= size ? size - 1 : i);
-}
-EXPORT_SYMBOL(cfs_vsnprintf);
-
-/* safe snprintf */
-int cfs_snprintf(char *buf, size_t size, const char *fmt, ...)
-{
-	va_list args;
-	int i;
-
-	va_start(args, fmt);
-	i = cfs_vsnprintf(buf, size, fmt, args);
-	va_end(args);
-
-	return  i;
-}
-EXPORT_SYMBOL(cfs_snprintf);
-
 /* get the first string out of @str */
 char *cfs_firststr(char *str, size_t size)
 {
-- 
1.7.10.4

