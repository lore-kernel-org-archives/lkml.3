Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890AbaGIXvM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 19:51:12 -0400
Received: from message.langara.bc.ca ([142.35.159.25]:50265 "EHLO
	message.langara.bc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbaGIXvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 19:51:11 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-disposition: inline
Content-type: text/plain; charset=us-ascii
From: Steven Stewart-Gallus <sstewartgallus00@mylangara.bc.ca>
To: linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>
Message-id: <fb4eb72f7cd0.53bdd56f@langara.bc.ca>
Date: Wed, 09 Jul 2014 23:51:11 +0000 (GMT)
X-Mailer: Sun Java(tm) System Messenger Express 6.3-6.03 (built Mar 14 2008;
 32bit)
Content-language: en
Subject: [PATCH v2 1/2] include/uapi: Define AT_ABSOLUTE to allow only absolute
 paths
X-Accept-Language: en
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This way people can use existing functionality (passing an invalid value
for dirfd to allow only absolute paths in *at style functions) and be
compatible for the future if Linux ever adds in new AT_* flags.

Signed-off-by: Steven Stewart-Gallus <sstewartgallus00@mylangara.bc.ca>
---
 include/uapi/linux/fcntl.h |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/fcntl.h b/include/uapi/linux/fcntl.h
index 074b886..c4c5705 100644
--- a/include/uapi/linux/fcntl.h
+++ b/include/uapi/linux/fcntl.h
@@ -38,9 +38,16 @@
 #define DN_ATTRIB	0x00000020	/* File changed attibutes */
 #define DN_MULTISHOT	0x80000000	/* Don't remove notifier */
 
+#define AT_FDABSOLUTE		-1      /* Special value used to indicate
+					   openat should not use any directory
+					   and only accept absolute values.
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
-- 
1.7.9.5


