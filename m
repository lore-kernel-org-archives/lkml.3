Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756433AbbAHMVw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 07:21:52 -0500
Received: from mail-lb0-f178.google.com ([209.85.217.178]:57044 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527AbbAHMVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 07:21:50 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Andrew Morton <akpm@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>,
        Randy Dunlap <rdunlap@infradead.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] lib/vsprintf.c: Consume 'p' in format_decode
Date: Thu,  8 Jan 2015 13:14:44 +0100
Message-Id: <1420719287-10222-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems a little simpler to consume the p from a %p specifier in
format_decode, just as it is done for the surrounding %c, %s and %%
cases.

While there, delete a redundant and misplaced comment.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 lib/vsprintf.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index ec337f64f52d..98ad170b10e0 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -1604,8 +1604,7 @@ qualifier:
 
 	case 'p':
 		spec->type = FORMAT_TYPE_PTR;
-		return fmt - start;
-		/* skip alnum */
+		return ++fmt - start;
 
 	case '%':
 		spec->type = FORMAT_TYPE_PERCENT_CHAR;
@@ -1794,7 +1793,7 @@ int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
 			break;
 
 		case FORMAT_TYPE_PTR:
-			str = pointer(fmt+1, str, end, va_arg(args, void *),
+			str = pointer(fmt, str, end, va_arg(args, void *),
 				      spec);
 			while (isalnum(*fmt))
 				fmt++;
@@ -2232,7 +2231,7 @@ int bstr_printf(char *buf, size_t size, const char *fmt, const u32 *bin_buf)
 		}
 
 		case FORMAT_TYPE_PTR:
-			str = pointer(fmt+1, str, end, get_arg(void *), spec);
+			str = pointer(fmt, str, end, get_arg(void *), spec);
 			while (isalnum(*fmt))
 				fmt++;
 			break;
-- 
2.1.3

