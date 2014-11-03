Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751338AbaKCIOG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 03:14:06 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:54493 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751852AbaKCINO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 03:13:14 -0500
X-Sasl-enc: sg0UOuqZctC590UidLL/xyZFmyTG3P6cZAAJOnl/v2z7 1415002393
Subject: [PATCH 11/13] autofs - update fs/autofs4/Kconfig
From: Ian Kent <raven@themaw.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        autofs mailing list <autofs@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 03 Nov 2014 16:13:11 +0800
Message-ID: <20141103081311.6215.40881.stgit@perseus.themaw.net>
In-Reply-To: <20141103081218.6215.85903.stgit@perseus.themaw.net>
References: <20141103081218.6215.85903.stgit@perseus.themaw.net>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update Kconfig and add a depricated warning.

Signed-off-by: Ian Kent <raven@themaw.net>
---
 fs/autofs4/Kconfig |   32 ++++++++++++++++++++++----------
 1 file changed, 22 insertions(+), 10 deletions(-)

diff --git a/fs/autofs4/Kconfig b/fs/autofs4/Kconfig
index 1204d63..26dbb00 100644
--- a/fs/autofs4/Kconfig
+++ b/fs/autofs4/Kconfig
@@ -1,5 +1,6 @@
 config AUTOFS4_FS
-	tristate "Kernel automounter version 4 support (also supports v3)"
+	tristate "Kernel automounter support (supports v3, v4 and v5)"
+	depends on AUTOFS_FS = n
 	help
 	  The automounter is a tool to automatically mount remote file systems
 	  on demand. This implementation is partially kernel-based to reduce
@@ -7,14 +8,25 @@ config AUTOFS4_FS
 	  automounter (amd), which is a pure user space daemon.
 
 	  To use the automounter you need the user-space tools from
-	  <ftp://ftp.kernel.org/pub/linux/daemons/autofs/v4/>; you also
-	  want to answer Y to "NFS file system support", below.
+	  <ftp://ftp.kernel.org/pub/linux/daemons/autofs/>; you also want
+	  to answer Y to "NFS file system support", below.
 
-	  To compile this support as a module, choose M here: the module will be
-	  called autofs4.  You will need to add "alias autofs autofs4" to your
-	  modules configuration file.
+	  This module is in the process of being renamed from autofs4 to
+	  autofs. Since autofs is now the only module that provides the
+	  autofs file system the module is not version 4 specific.
 
-	  If you are not a part of a fairly large, distributed network or
-	  don't have a laptop which needs to dynamically reconfigure to the
-	  local network, you probably do not need an automounter, and can say
-	  N here.
+	  The autofs4 module is now built from the source located in
+	  fs/autofs. The autofs4 directory and its configuration entry
+	  will be removed two kernel version from the inclusion of this
+	  change.
+
+	  Changes that will need to be made should be limited to:
+	  - source include statments should be changed from autofs_fs4.h to
+	    autofs_fs.h since these two header files have been merged.
+	  - user space scripts that manually load autofs4.ko should be
+	    changed to load autofs.ko. But since the module directory name
+	    and the module name are the same as the file system name there
+	    is no need to manually load module.
+	  - any "alias autofs autofs4" will need to be removed.
+
+	  Please configure AUTOFS_FS instead of AUTOFS4_FS from now on.

