Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207AbaIPUwF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 16:52:05 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:54001 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755027AbaIPUv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 16:51:59 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 01/22] ARM: Replace strnicmp with strncasecmp
Date: Tue, 16 Sep 2014 22:51:15 +0200
Message-Id: <1410900696-6481-2-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1410900696-6481-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1410900696-6481-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel used to contain two functions for length-delimited,
case-insensitive string comparison, strnicmp with correct semantics
and a slightly buggy strncasecmp. The latter is the POSIX name, so
strnicmp was renamed to strncasecmp, and strnicmp made into a wrapper
for the new strncasecmp to avoid breaking existing users.

To allow the compat wrapper strnicmp to be removed at some point in
the future, and to avoid the extra indirection cost, do
s/strnicmp/strncasecmp/g.

Cc: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org
Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 arch/arm/mach-pxa/lpd270.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-pxa/lpd270.c b/arch/arm/mach-pxa/lpd270.c
index 9f6ec16..ad777b3 100644
--- a/arch/arm/mach-pxa/lpd270.c
+++ b/arch/arm/mach-pxa/lpd270.c
@@ -416,17 +416,17 @@ static struct pxafb_mach_info *lpd270_lcd_to_use;
 
 static int __init lpd270_set_lcd(char *str)
 {
-	if (!strnicmp(str, "lq057q3dc02", 11)) {
+	if (!strncasecmp(str, "lq057q3dc02", 11)) {
 		lpd270_lcd_to_use = &sharp_lq057q3dc02;
-	} else if (!strnicmp(str, "lq121s1dg31", 11)) {
+	} else if (!strncasecmp(str, "lq121s1dg31", 11)) {
 		lpd270_lcd_to_use = &sharp_lq121s1dg31;
-	} else if (!strnicmp(str, "lq036q1da01", 11)) {
+	} else if (!strncasecmp(str, "lq036q1da01", 11)) {
 		lpd270_lcd_to_use = &sharp_lq036q1da01;
-	} else if (!strnicmp(str, "lq64d343", 8)) {
+	} else if (!strncasecmp(str, "lq64d343", 8)) {
 		lpd270_lcd_to_use = &sharp_lq64d343;
-	} else if (!strnicmp(str, "lq10d368", 8)) {
+	} else if (!strncasecmp(str, "lq10d368", 8)) {
 		lpd270_lcd_to_use = &sharp_lq10d368;
-	} else if (!strnicmp(str, "lq035q7db02-20", 14)) {
+	} else if (!strncasecmp(str, "lq035q7db02-20", 14)) {
 		lpd270_lcd_to_use = &sharp_lq035q7db02_20;
 	} else {
 		printk(KERN_INFO "lpd270: unknown lcd panel [%s]\n", str);
-- 
2.0.4

