Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151AbaGKONv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 10:13:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56904 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752621AbaGKONt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 10:13:49 -0400
From: Michal Marek <mmarek@suse.cz>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Subject: [PATCH] kbuild: make -s should be used with kernelrelease/kernelversion/image_name
Date: Fri, 11 Jul 2014 16:13:31 +0200
Message-Id: <1405088011-23329-1-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <20140709132047.GT21766@n2100.arm.linux.org.uk>
References: <20140709132047.GT21766@n2100.arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If .config has been edited, there will be a silentoldconfig run:

  $ make defconfig
  ...
  $ make kernelrelease
  scripts/kconfig/conf --silentoldconfig Kconfig
  3.16.0-rc1+

Recently, kbuild started to print the name of the build directory when
using O=

  $ make O=build kernelrelease
  make[1]: Entering directory `/dev/shm/mmarek/linux-2.6/build'
  3.16.0-rc1+

Since these targets are often used in scripts, add a hint to use make -s
to the help text.

Suggested-by: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 Makefile | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Makefile b/Makefile
index 97b2861..284071c 100644
--- a/Makefile
+++ b/Makefile
@@ -1214,9 +1214,9 @@ help:
 	@echo  '  tags/TAGS	  - Generate tags file for editors'
 	@echo  '  cscope	  - Generate cscope index'
 	@echo  '  gtags           - Generate GNU GLOBAL index'
-	@echo  '  kernelrelease	  - Output the release version string'
-	@echo  '  kernelversion	  - Output the version stored in Makefile'
-	@echo  '  image_name	  - Output the image name'
+	@echo  '  kernelrelease	  - Output the release version string (use with make -s)'
+	@echo  '  kernelversion	  - Output the version stored in Makefile (use with make -s)'
+	@echo  '  image_name	  - Output the image name (use with make -s)'
 	@echo  '  headers_install - Install sanitised kernel headers to INSTALL_HDR_PATH'; \
 	 echo  '                    (default: $(INSTALL_HDR_PATH))'; \
 	 echo  ''
-- 
1.8.4.5

