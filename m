Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294AbaGMKWT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 06:22:19 -0400
Received: from smtpfb1-g21.free.fr ([212.27.42.9]:55932 "EHLO
	smtpfb1-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941AbaGMKWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 06:22:07 -0400
From: Yann Droneaud <ydroneaud@opteya.com>
To: linux-kbuild@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Yann Droneaud <ydroneaud@opteya.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Michal Marek <mmarek@suse.cz>, David Woodhouse <dwmw2@infradead.org>,
        Rob Landley <rob@landley.net>, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCHv1 2/2] Documentation/kbuild/headers_install.txt: update documentation
Date: Sun, 13 Jul 2014 12:15:30 +0200
Message-Id: <3e0d73d0ca3ead75624b552105ce8adf3d63684e.1405246009.git.ydroneaud@opteya.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1405246007.git.ydroneaud@opteya.com>
References: <cover.1405246007.git.ydroneaud@opteya.com>
In-Reply-To: <cover.1405246007.git.ydroneaud@opteya.com>
References: <20140709204915.GB32335@ravnborg.org> <cover.1405246007.git.ydroneaud@opteya.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Documentation in kbuild/headers_install.txt is not
up to date regarding:
- way to list the various architectures;
- path where the headers are installed.

This patch try to fix these issues.

Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Michal Marek <mmarek@suse.cz>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Rob Landley <rob@landley.net>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
---
 Documentation/kbuild/headers_install.txt | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/Documentation/kbuild/headers_install.txt b/Documentation/kbuild/headers_install.txt
index 951eb9f1e040..8b6751f10dd3 100644
--- a/Documentation/kbuild/headers_install.txt
+++ b/Documentation/kbuild/headers_install.txt
@@ -24,23 +24,24 @@ The "make headers_install" command can be run in the top level directory of the
 kernel source code (or using a standard out-of-tree build).  It takes two
 optional arguments:
 
-  make headers_install ARCH=i386 INSTALL_HDR_PATH=/usr/include
+  make headers_install ARCH=i386 INSTALL_HDR_PATH=/usr
 
 ARCH indicates which architecture to produce headers for, and defaults to the
-current architecture.  The linux/asm directory of the exported kernel headers
-is platform-specific, to see a complete list of supported architectures use
+current architecture.  The asm/ directory of the exported kernel headers
+is platform-specific, to see a list of supported architectures use
 the command:
 
-  ls -d include/asm-* | sed 's/.*-//'
+  /bin/ls -1 arch/*/include/asm/Kbuild | sed -e 's,^arch/,,' \
+                                             -e 's,/include/asm/Kbuild$,,'
 
-INSTALL_HDR_PATH indicates where to install the headers.  It defaults to
-"./usr/include".
+INSTALL_HDR_PATH indicates where to create include/ directory to install the
+headers. It defaults to "./usr/".
 
 The command "make headers_install_all" exports headers for all architectures
 simultaneously.  (This is mostly of interest to distribution maintainers,
 who create an architecture-independent tarball from the resulting include
 directory.)  You also can use HDR_ARCH_LIST to specify list of architectures.
-Remember to provide the appropriate linux/asm directory via "mv" or "ln -s"
+Remember to provide the appropriate asm/ directory via "mv" or "ln -s"
 before building a C library with headers exported this way.
 
 The kernel header export infrastructure is maintained by David Woodhouse
-- 
1.9.3

