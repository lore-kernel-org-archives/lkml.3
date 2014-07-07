Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842AbaGGPWR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 11:22:17 -0400
Received: from mga03.intel.com ([143.182.124.21]:52390 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753639AbaGGPWK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 11:22:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,618,1400050800"; 
   d="scan'208";a="454061915"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: "John W . Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>, devel@driverdev.osuosl.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v2 01/10] lib / string_helpers: move documentation to c-file
Date: Mon,  7 Jul 2014 18:21:43 +0300
Message-Id: <1404746512-12749-2-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1404746512-12749-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1404746512-12749-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The documentation of API belongs to c-file. This patch moves it accordingly.

There is no functional change.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 include/linux/string_helpers.h | 34 ----------------------------------
 lib/string_helpers.c           | 38 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+), 34 deletions(-)

diff --git a/include/linux/string_helpers.h b/include/linux/string_helpers.h
index 3eeee96..5a30f2a 100644
--- a/include/linux/string_helpers.h
+++ b/include/linux/string_helpers.h
@@ -20,40 +20,6 @@ int string_get_size(u64 size, enum string_size_units units,
 #define UNESCAPE_ANY		\
 	(UNESCAPE_SPACE | UNESCAPE_OCTAL | UNESCAPE_HEX | UNESCAPE_SPECIAL)
 
-/**
- * string_unescape - unquote characters in the given string
- * @src:	source buffer (escaped)
- * @dst:	destination buffer (unescaped)
- * @size:	size of the destination buffer (0 to unlimit)
- * @flags:	combination of the flags (bitwise OR):
- *	%UNESCAPE_SPACE:
- *		'\f' - form feed
- *		'\n' - new line
- *		'\r' - carriage return
- *		'\t' - horizontal tab
- *		'\v' - vertical tab
- *	%UNESCAPE_OCTAL:
- *		'\NNN' - byte with octal value NNN (1 to 3 digits)
- *	%UNESCAPE_HEX:
- *		'\xHH' - byte with hexadecimal value HH (1 to 2 digits)
- *	%UNESCAPE_SPECIAL:
- *		'\"' - double quote
- *		'\\' - backslash
- *		'\a' - alert (BEL)
- *		'\e' - escape
- *	%UNESCAPE_ANY:
- *		all previous together
- *
- * Returns amount of characters processed to the destination buffer excluding
- * trailing '\0'.
- *
- * Because the size of the output will be the same as or less than the size of
- * the input, the transformation may be performed in place.
- *
- * Caller must provide valid source and destination pointers. Be aware that
- * destination buffer will always be NULL-terminated. Source string must be
- * NULL-terminated as well.
- */
 int string_unescape(char *src, char *dst, size_t size, unsigned int flags);
 
 static inline int string_unescape_inplace(char *buf, unsigned int flags)
diff --git a/lib/string_helpers.c b/lib/string_helpers.c
index 29033f3..74ec604 100644
--- a/lib/string_helpers.c
+++ b/lib/string_helpers.c
@@ -168,6 +168,44 @@ static bool unescape_special(char **src, char **dst)
 	return true;
 }
 
+/**
+ * string_unescape - unquote characters in the given string
+ * @src:	source buffer (escaped)
+ * @dst:	destination buffer (unescaped)
+ * @size:	size of the destination buffer (0 to unlimit)
+ * @flags:	combination of the flags (bitwise OR):
+ *	%UNESCAPE_SPACE:
+ *		'\f' - form feed
+ *		'\n' - new line
+ *		'\r' - carriage return
+ *		'\t' - horizontal tab
+ *		'\v' - vertical tab
+ *	%UNESCAPE_OCTAL:
+ *		'\NNN' - byte with octal value NNN (1 to 3 digits)
+ *	%UNESCAPE_HEX:
+ *		'\xHH' - byte with hexadecimal value HH (1 to 2 digits)
+ *	%UNESCAPE_SPECIAL:
+ *		'\"' - double quote
+ *		'\\' - backslash
+ *		'\a' - alert (BEL)
+ *		'\e' - escape
+ *	%UNESCAPE_ANY:
+ *		all previous together
+ *
+ * Description:
+ * The function unquotes characters in the given string.
+ *
+ * Because the size of the output will be the same as or less than the size of
+ * the input, the transformation may be performed in place.
+ *
+ * Caller must provide valid source and destination pointers. Be aware that
+ * destination buffer will always be NULL-terminated. Source string must be
+ * NULL-terminated as well.
+ *
+ * Return:
+ * The amount of the characters processed to the destination buffer excluding
+ * trailing '\0' is returned.
+ */
 int string_unescape(char *src, char *dst, size_t size, unsigned int flags)
 {
 	char *out = dst;
-- 
2.0.1

