Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757246Ab3HaLo5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 07:44:57 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:54356 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757205Ab3HaLoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 07:44:54 -0400
X-Sasl-enc: fljw4G3D3WtwOwczpr0pTuPdNn6yiCxG70cF8ro+rnD8 1377949384
Subject: [PATCH 08/10] autofs - update fs/autofs4/Kconfig
To: linux-next@vger.kernel.org
From: Ian Kent <raven@themaw.net>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        autofs mailing list <autofs@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 31 Aug 2013 19:43:02 +0800
Message-ID: <20130831114302.11807.74463.stgit@perseus.themaw.net>
In-Reply-To: <20130831114133.11807.35953.stgit@perseus.themaw.net>
References: <20130831114133.11807.35953.stgit@perseus.themaw.net>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update Kconfig and add a depricated warning.

Signed-off-by: Ian Kent <raven@themaw.net>
---
 fs/autofs4/Kconfig |   30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/fs/autofs4/Kconfig b/fs/autofs4/Kconfig
index 1204d63..f74d317 100644
--- a/fs/autofs4/Kconfig
+++ b/fs/autofs4/Kconfig
@@ -1,5 +1,5 @@
 config AUTOFS4_FS
-	tristate "Kernel automounter version 4 support (also supports v3)"
+	tristate "Kernel automounter support (supports v3, v4 and v5)"
 	help
 	  The automounter is a tool to automatically mount remote file systems
 	  on demand. This implementation is partially kernel-based to reduce
@@ -7,14 +7,24 @@ config AUTOFS4_FS
 	  automounter (amd), which is a pure user space daemon.
 
 	  To use the automounter you need the user-space tools from
-	  <ftp://ftp.kernel.org/pub/linux/daemons/autofs/v4/>; you also
-	  want to answer Y to "NFS file system support", below.
+	  <ftp://ftp.kernel.org/pub/linux/daemons/autofs/>; you also want
+	  to answer Y to "NFS file system support", below.
 
-	  To compile this support as a module, choose M here: the module will be
-	  called autofs4.  You will need to add "alias autofs autofs4" to your
-	  modules configuration file.
+	  This module is in the process of being renamed from autofs4 to autofs
+	  since is now the only module that provides the autofs file system and
+	  the module is not version 4 specific.
 
-	  If you are not a part of a fairly large, distributed network or
-	  don't have a laptop which needs to dynamically reconfigure to the
-	  local network, you probably do not need an automounter, and can say
-	  N here.
+	  It is now built from the source located in fs/autofs and this directory
+	  and the configuration entry will be removed two kernel version from the
+	  inclusion of this change.
+
+	  Changes that will need to be made should be limited to:
+	  - source include statments should be changed from autofs_fs4.h to
+	    autofs_fs.h since these two header file have been merged.
+	  - user space scripts that manually load autofs4.ko should be changed
+	    to load autofs.ko. Since the module directory name and the module
+	    name itself are the same now there is no need to manually load
+	    module.
+	  - any "alias autofs autofs4" will need to be removed.
+
+	  Please configure AUTOFS_FS instead of AUTOFS4_FS from now on.

