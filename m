Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301Ab3KPRkP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 12:40:15 -0500
Received: from mail-ob0-f170.google.com ([209.85.214.170]:33445 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984Ab3KPRjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 12:39:40 -0500
From: Felipe Contreras <felipe.contreras@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Levente Kurusa <levex@linux.com>,
        Felipe Contreras <felipe.contreras@gmail.com>
Subject: [PATCH 3/5] cmdline: declare exported symbols immediately
Date: Sat, 16 Nov 2013 11:32:29 -0600
Message-Id: <1384623151-31302-4-git-send-email-felipe.contreras@gmail.com>
X-Mailer: git-send-email 1.8.4.2+fc1
In-Reply-To: <1384623151-31302-1-git-send-email-felipe.contreras@gmail.com>
References: <1384623151-31302-1-git-send-email-felipe.contreras@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
+EXPORT_SYMBOL(memparse);

WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
+EXPORT_SYMBOL(get_option);

WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
+EXPORT_SYMBOL(get_options);

Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
---
 lib/cmdline.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/lib/cmdline.c b/lib/cmdline.c
index 5466333..d4932f7 100644
--- a/lib/cmdline.c
+++ b/lib/cmdline.c
@@ -67,6 +67,7 @@ int get_option(char **str, int *pint)
 
 	return 1;
 }
+EXPORT_SYMBOL(get_option);
 
 /**
  *	get_options - Parse a string into a list of integers
@@ -112,6 +113,7 @@ char *get_options(const char *str, int nints, int *ints)
 	ints[0] = i - 1;
 	return (char *)str;
 }
+EXPORT_SYMBOL(get_options);
 
 /**
  *	memparse - parse a string with mem suffixes into a number
@@ -152,7 +154,4 @@ unsigned long long memparse(const char *ptr, char **retptr)
 
 	return ret;
 }
-
 EXPORT_SYMBOL(memparse);
-EXPORT_SYMBOL(get_option);
-EXPORT_SYMBOL(get_options);
-- 
1.8.4.2+fc1

