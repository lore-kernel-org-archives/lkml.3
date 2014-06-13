Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171AbaFMHfi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 03:35:38 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:60447 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018AbaFMHfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 03:35:37 -0400
From: Mathias Krause <minipli@googlemail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Mathias Krause <minipli@googlemail.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH] lib/string_helpers.c: constify static arrays
Date: Fri, 13 Jun 2014 09:34:42 +0200
Message-Id: <1402644882-26185-1-git-send-email-minipli@googlemail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Complement commit 68aecfb979 ("lib/string_helpers.c: make arrays
static") by making the arrays const -- not only pointing to const
strings. This moves them out of the data section to the r/o data
section:

   text    data     bss     dec     hex filename
   1150     176       0    1326     52e lib/string_helpers.old.o
   1326       0       0    1326     52e lib/string_helpers.new.o

Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Mathias Krause <minipli@googlemail.com>
---
 lib/string_helpers.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/lib/string_helpers.c b/lib/string_helpers.c
index ed5c1454dd..29033f319a 100644
--- a/lib/string_helpers.c
+++ b/lib/string_helpers.c
@@ -25,12 +25,15 @@
 int string_get_size(u64 size, const enum string_size_units units,
 		    char *buf, int len)
 {
-	static const char *units_10[] = { "B", "kB", "MB", "GB", "TB", "PB",
-				   "EB", "ZB", "YB", NULL};
-	static const char *units_2[] = {"B", "KiB", "MiB", "GiB", "TiB", "PiB",
-				 "EiB", "ZiB", "YiB", NULL };
-	static const char **units_str[] = {
-		[STRING_UNITS_10] =  units_10,
+	static const char *const units_10[] = {
+		"B", "kB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB", NULL
+	};
+	static const char *const units_2[] = {
+		"B", "KiB", "MiB", "GiB", "TiB", "PiB", "EiB", "ZiB", "YiB",
+		NULL
+	};
+	static const char *const *const units_str[] = {
+		[STRING_UNITS_10] = units_10,
 		[STRING_UNITS_2] = units_2,
 	};
 	static const unsigned int divisor[] = {
-- 
1.7.10.4

