Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968AbbATTO3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 14:14:29 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:41759 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753080AbbATTNQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 14:13:16 -0500
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: initramfs <initramfs@vger.kernel.org>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, Al Viro <viro@ZenIV.linux.org.uk>,
        linux-ima-devel@lists.sourceforge.net,
        linux-security-module <linux-security-module@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH v1 05/11] gen_init_cpio: replace inline format string with common variable
Date: Tue, 20 Jan 2015 14:12:54 -0500
Message-Id: <1421781180-24425-6-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1421781180-24425-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1421781180-24425-1-git-send-email-zohar@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012019-0033-0000-0000-0000019BE02F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The same printf format string is used in a number of places.  This
patch replaces the inline format string with a single common variable
called newcfmt.

Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
---
 usr/gen_init_cpio.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/usr/gen_init_cpio.c b/usr/gen_init_cpio.c
index 225ad24..ee35361 100644
--- a/usr/gen_init_cpio.c
+++ b/usr/gen_init_cpio.c
@@ -20,6 +20,9 @@
 #define xstr(s) #s
 #define str(s) xstr(s)
 
+static char *newcfmt = "%s%08X%08X%08lX%08lX%08X%08lX"
+			"%08X%08X%08X%08X%08X%08X%08X";
+
 static unsigned int offset;
 static unsigned int ino = 721;
 static time_t default_mtime;
@@ -74,8 +77,7 @@ static void cpio_trailer(void)
 	char s[256];
 	const char name[] = "TRAILER!!!";
 
-	sprintf(s, "%s%08X%08X%08lX%08lX%08X%08lX"
-	       "%08X%08X%08X%08X%08X%08X%08X",
+	sprintf(s, newcfmt,
 		"070701",		/* magic */
 		0,			/* ino */
 		0,			/* mode */
@@ -106,8 +108,7 @@ static int cpio_mkslink(const char *name, const char *target,
 
 	if (name[0] == '/')
 		name++;
-	sprintf(s,"%s%08X%08X%08lX%08lX%08X%08lX"
-	       "%08X%08X%08X%08X%08X%08X%08X",
+	sprintf(s, newcfmt,
 		"070701",		/* magic */
 		ino++,			/* ino */
 		S_IFLNK | mode,		/* mode */
@@ -155,8 +156,7 @@ static int cpio_mkgeneric(const char *name, unsigned int mode,
 
 	if (name[0] == '/')
 		name++;
-	sprintf(s,"%s%08X%08X%08lX%08lX%08X%08lX"
-	       "%08X%08X%08X%08X%08X%08X%08X",
+	sprintf(s, newcfmt,
 		"070701",		/* magic */
 		ino++,			/* ino */
 		mode,			/* mode */
@@ -249,8 +249,7 @@ static int cpio_mknod(const char *name, unsigned int mode,
 
 	if (name[0] == '/')
 		name++;
-	sprintf(s,"%s%08X%08X%08lX%08lX%08X%08lX"
-	       "%08X%08X%08X%08X%08X%08X%08X",
+	sprintf(s, newcfmt,
 		"070701",		/* magic */
 		ino++,			/* ino */
 		mode,			/* mode */
@@ -339,8 +338,7 @@ static int cpio_mkfile(const char *name, const char *location,
 		if (name[0] == '/')
 			name++;
 		namesize = strlen(name) + 1;
-		sprintf(s,"%s%08X%08X%08lX%08lX%08X%08lX"
-		       "%08lX%08X%08X%08X%08X%08X%08X",
+		sprintf(s, newcfmt,
 			"070701",		/* magic */
 			ino,			/* ino */
 			mode,			/* mode */
-- 
1.8.1.4

