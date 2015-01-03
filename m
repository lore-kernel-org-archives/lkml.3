Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750856AbbACHB3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2015 02:01:29 -0500
Received: from mail-lb0-f173.google.com ([209.85.217.173]:59129 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778AbbACHB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2015 02:01:27 -0500
From: Alexander Kuleshov <kuleshovmail@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Alexander Kuleshov <kuleshovmail@gmail.com>
Subject: [PATCH] x86,setup: Rename myisspace to isspace and move it to ctype.h
Date: Sat,  3 Jan 2015 13:01:20 +0600
Message-Id: <1420268480-962-1-git-send-email-kuleshovmail@gmail.com>
X-Mailer: git-send-email 2.2.1.202.g44ae4ee.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

isspace is a subset of ctype.h functionality, so move it to ctype.h

Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
---
 arch/x86/boot/cmdline.c | 19 +++++++------------
 arch/x86/boot/ctype.h   |  9 +++++++--
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/x86/boot/cmdline.c b/arch/x86/boot/cmdline.c
index 625d21b..bc1e25f 100644
--- a/arch/x86/boot/cmdline.c
+++ b/arch/x86/boot/cmdline.c
@@ -14,11 +14,6 @@
 
 #include "boot.h"
 
-static inline int myisspace(u8 c)
-{
-	return c <= ' ';	/* Close enough approximation */
-}
-
 /*
  * Find a non-boolean option, that is, "option=argument".  In accordance
  * with standard Linux practice, if this option is repeated, this returns
@@ -50,7 +45,7 @@ int __cmdline_find_option(unsigned long cmdline_ptr, const char *option, char *b
 	while (cptr < 0x10000 && (c = rdfs8(cptr++))) {
 		switch (state) {
 		case st_wordstart:
-			if (myisspace(c))
+			if (isspace(c))
 				break;
 
 			/* else */
@@ -63,7 +58,7 @@ int __cmdline_find_option(unsigned long cmdline_ptr, const char *option, char *b
 				len = 0;
 				bufptr = buffer;
 				state = st_bufcpy;
-			} else if (myisspace(c)) {
+			} else if (isspace(c)) {
 				state = st_wordstart;
 			} else if (c != *opptr++) {
 				state = st_wordskip;
@@ -71,12 +66,12 @@ int __cmdline_find_option(unsigned long cmdline_ptr, const char *option, char *b
 			break;
 
 		case st_wordskip:
-			if (myisspace(c))
+			if (isspace(c))
 				state = st_wordstart;
 			break;
 
 		case st_bufcpy:
-			if (myisspace(c)) {
+			if (isspace(c)) {
 				state = st_wordstart;
 			} else {
 				if (len < bufsize-1)
@@ -125,7 +120,7 @@ int __cmdline_find_option_bool(unsigned long cmdline_ptr, const char *option)
 		case st_wordstart:
 			if (!c)
 				return 0;
-			else if (myisspace(c))
+			else if (isspace(c))
 				break;
 
 			state = st_wordcmp;
@@ -135,7 +130,7 @@ int __cmdline_find_option_bool(unsigned long cmdline_ptr, const char *option)
 
 		case st_wordcmp:
 			if (!*opptr)
-				if (!c || myisspace(c))
+				if (!c || isspace(c))
 					return wstart;
 				else
 					state = st_wordskip;
@@ -148,7 +143,7 @@ int __cmdline_find_option_bool(unsigned long cmdline_ptr, const char *option)
 		case st_wordskip:
 			if (!c)
 				return 0;
-			else if (myisspace(c))
+			else if (isspace(c))
 				state = st_wordstart;
 			break;
 		}
diff --git a/arch/x86/boot/ctype.h b/arch/x86/boot/ctype.h
index 25e1340..c172741 100644
--- a/arch/x86/boot/ctype.h
+++ b/arch/x86/boot/ctype.h
@@ -1,6 +1,6 @@
-#ifndef BOOT_ISDIGIT_H
+#ifndef BOOT_CTYPE_H
 
-#define BOOT_ISDIGIT_H
+#define BOOT_CTYPE_H
 
 static inline int isdigit(int ch)
 {
@@ -18,4 +18,9 @@ static inline int isxdigit(int ch)
 	return (ch >= 'A') && (ch <= 'F');
 }
 
+static inline int isspace(u8 c)
+{
+	return c <= ' ';	/* Close enough approximation */
+}
+
 #endif
-- 
2.2.1.202.g44ae4ee.dirty

