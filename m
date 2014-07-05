Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932774AbaGEUvW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 16:51:22 -0400
Received: from message.langara.bc.ca ([142.35.159.25]:48183 "EHLO
	message.langara.bc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753401AbaGEUvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 16:51:20 -0400
X-Greylist: delayed 3601 seconds by postgrey-1.27 at vger.kernel.org; Sat, 05 Jul 2014 16:51:20 EDT
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-disposition: inline
Content-type: text/plain; charset=us-ascii
From: Steven Stewart-Gallus <sstewartgallus00@mylangara.bc.ca>
To: linux-kernel@vger.kernel.org
Cc: Jeff Layton <jlayton@poochiereds.net>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>
Message-id: <fb469d6277ef.53b85737@langara.bc.ca>
Date: Sat, 05 Jul 2014 19:51:19 +0000 (GMT)
X-Mailer: Sun Java(tm) System Messenger Express 6.3-6.03 (built Mar 14 2008;
 32bit)
Content-language: en
Subject: [PATCH 1/1] include/uapi: Define AT_FDNODIR constant as future
 guarantee
X-Accept-Language: en
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Stewart-Gallus <sstewartgallus00@mylangara.bc.ca

This constant means that in the far future it might be possible to
define other AT_FD* constants.

Signed-off-by: Steven Stewart-Gallus <sstewartgallus00@mylangara.bc.ca>
---

This is my first kernel patch but this is really trivial so I hope I'm doing
this right.

diff --git a/include/uapi/linux/fcntl.h b/include/uapi/linux/fcntl.h
index 074b886..92223f0 100644
--- a/include/uapi/linux/fcntl.h
+++ b/include/uapi/linux/fcntl.h
@@ -38,9 +38,15 @@
 #define DN_ATTRIB	0x00000020	/* File changed attibutes */
 #define DN_MULTISHOT	0x80000000	/* Don't remove notifier */
 
+#define AT_FDNODDIR		-1      /* Special value used to indicate
+					   openat should not use any directory.
+					   Currently, other values work for this
+					   but in the future that might
+					   change. */
 #define AT_FDCWD		-100    /* Special value used to indicate
-                                           openat should use the current
-                                           working directory. */
+					   openat should use the current
+					   working directory. */
+
 #define AT_SYMLINK_NOFOLLOW	0x100   /* Do not follow symbolic links.  */
 #define AT_REMOVEDIR		0x200   /* Remove directory instead of
                                            unlinking file.  */

