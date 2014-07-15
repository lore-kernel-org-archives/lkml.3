Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933235AbaGOTSV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 15:18:21 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:38410 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933204AbaGOTSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 15:18:18 -0400
From: Nicholas Krause <xerofoify@gmail.com>
To: rth@twiddle.net
Cc: ink@jurassic.park.msu.ru, mattst88@gmail.com, linux-alpha@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] alpha: Fix complex marco definitions
Date: Tue, 15 Jul 2014 15:18:09 -0400
Message-Id: <1405451890-6057-4-git-send-email-xerofoify@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405451890-6057-1-git-send-email-xerofoify@gmail.com>
References: <1405451890-6057-1-git-send-email-xerofoify@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes all macro defintions that need parthesises as stated
by checkpatch when run against this file.
---
 arch/alpha/boot/misc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/alpha/boot/misc.c b/arch/alpha/boot/misc.c
index 174b7c6..886e469 100644
--- a/arch/alpha/boot/misc.c
+++ b/arch/alpha/boot/misc.c
@@ -23,7 +23,7 @@
 
 #include <asm/uaccess.h>
 
-#define memzero (s, n)	memset((s), 0 , (n))
+#define memzero { (s, n)	memset((s), 0 , (n)) }
 #define puts		srm_printk
 extern long srm_printk(const char *, ...)
 	__attribute__ ((format (printf, 1, 2)));
@@ -61,8 +61,8 @@ static unsigned outcnt;		/* bytes in output buffer */
 
 /* Diagnostic functions */
 #ifdef DEBUG
-#  define Assert (cond, msg) {if (!(cond)) error(msg) ; }
-#  define Trace(x) fprintf x
+#  define Assert { (cond, msg) {if (!(cond)) error(msg) ; } }
+#  define Trace { (x) fprintf x }
 #  define Tracev(x) {if (verbose) fprintf x ; }
 #  define Tracevv(x) {if (verbose > 1) fprintf x ; }
 #  define Tracec(c, x) {if (verbose && (c)) fprintf x ; }
-- 
1.9.1

