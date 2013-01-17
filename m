Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758953Ab3AQCzF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 21:55:05 -0500
Received: from smtp.outflux.net ([198.145.64.163]:55782 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758901Ab3AQCzC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 21:55:02 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Steve French <sfrench@samba.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 77/86] fs/cifs: remove depends on CONFIG_EXPERIMENTAL
Date: Wed, 16 Jan 2013 18:54:09 -0800
Message-Id: <1358391258-1771-78-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358391258-1771-1-git-send-email-keescook@chromium.org>
References: <1358391258-1771-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
while now and is almost always enabled by default. As agreed during the
Linux kernel summit, remove it from any "depends on" lines in Kconfigs.

CC: Steve French <sfrench@samba.org>
CC: Al Viro <viro@zeniv.linux.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 fs/cifs/Kconfig |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
index 21ff76c..2906ee2 100644
--- a/fs/cifs/Kconfig
+++ b/fs/cifs/Kconfig
@@ -155,14 +155,14 @@ config CIFS_DFS_UPCALL
 	    points. If unsure, say N.
 
 config CIFS_NFSD_EXPORT
-	  bool "Allow nfsd to export CIFS file system (EXPERIMENTAL)"
-	  depends on CIFS && EXPERIMENTAL && BROKEN
+	  bool "Allow nfsd to export CIFS file system"
+	  depends on CIFS && BROKEN
 	  help
 	   Allows NFS server to export a CIFS mounted share (nfsd over cifs)
 
 config CIFS_SMB2
-	bool "SMB2 network file system support (EXPERIMENTAL)"
-	depends on CIFS && EXPERIMENTAL && INET
+	bool "SMB2 network file system support"
+	depends on CIFS && INET
 	select NLS
 	select KEYS
 	select FSCACHE
-- 
1.7.9.5

