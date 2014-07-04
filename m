Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760069AbaGDVZq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 17:25:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60498 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753039AbaGDVZp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 17:25:45 -0400
From: Michal Marek <mmarek@suse.cz>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] kbuild: Fix packaging targets with relative $(srctree)
Date: Fri,  4 Jul 2014 23:24:54 +0200
Message-Id: <1404509094-22033-1-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All other users of Makefile.build set $(obj) to the name of the
subdirectory to build. Do the same for the packaging targets, otherwise
the build fails if $(srctree) is a relative directory:

    $ make O=build tar-pkg
    make[1]: Entering directory `/home/mmarek/linux-2.6/build'
      CHK     include/config/kernel.release
    ../scripts/Makefile.build:44: ../../scripts/package/Makefile: No such file or directory
    make[2]: *** No rule to make target `../../scripts/package/Makefile'.  Stop.

Fixes: 9da0763b ("kbuild: Use relative path when building in a subdir of the source tree")
Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 1a5f9f3..347d6c7 100644
--- a/Makefile
+++ b/Makefile
@@ -1176,7 +1176,7 @@ distclean: mrproper
 # Packaging of the kernel to various formats
 # ---------------------------------------------------------------------------
 # rpm target kept for backward compatibility
-package-dir	:= $(srctree)/scripts/package
+package-dir	:= scripts/package
 
 %src-pkg: FORCE
 	$(Q)$(MAKE) $(build)=$(package-dir) $@
-- 
1.8.4.5

