Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254AbaH0Hgh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 03:36:37 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:53778 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395AbaH0Hgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 03:36:32 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Grant Likely <grant.likely@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH/RFC 2/2] lib: string: Make all calls to strnicmp into calls to strncasecmp
Date: Wed, 27 Aug 2014 09:36:02 +0200
Message-Id: <1409124962-11527-3-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1409124962-11527-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1409124962-11527-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The previous patch made strnicmp into a wrapper for strncasecmp. This
patch makes all in-tree users of strnicmp call strncasecmp directly,
while still making sure that the strnicmp symbol can be used by
out-of-tree modules. It should be considered a temporary hack until
all in-tree callers have been converted.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 include/linux/string.h | 2 +-
 lib/string.c           | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/string.h b/include/linux/string.h
index d36977e..e6edfe5 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -41,7 +41,7 @@ extern int strcmp(const char *,const char *);
 extern int strncmp(const char *,const char *,__kernel_size_t);
 #endif
 #ifndef __HAVE_ARCH_STRNICMP
-extern int strnicmp(const char *, const char *, __kernel_size_t);
+#define strnicmp strncasecmp
 #endif
 #ifndef __HAVE_ARCH_STRCASECMP
 extern int strcasecmp(const char *s1, const char *s2);
diff --git a/lib/string.c b/lib/string.c
index 92c33e1..d171554 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -59,6 +59,7 @@ int strncasecmp(const char *s1, const char *s2, size_t len)
 EXPORT_SYMBOL(strncasecmp);
 #endif
 #ifndef __HAVE_ARCH_STRNICMP
+#undef strnicmp
 int strnicmp(const char *s1, const char *s2, size_t len)
 {
 	return strncasecmp(s1, s2, len);
-- 
2.0.4

