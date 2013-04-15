Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757251Ab3DOUfy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 16:35:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37510 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756850Ab3DOUfb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 16:35:31 -0400
From: Michal Marek <mmarek@suse.cz>
To: linux-kbuild@vger.kernel.org
Cc: jkosina@suse.cz, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] rpm-pkg: Remove pointless set -e statements
Date: Mon, 15 Apr 2013 22:35:08 +0200
Message-Id: <1366058108-3500-4-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1366058108-3500-1-git-send-email-mmarek@suse.cz>
References: <1366058108-3500-1-git-send-email-mmarek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 scripts/package/Makefile |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/scripts/package/Makefile b/scripts/package/Makefile
index 08e4e2f..84a4060 100644
--- a/scripts/package/Makefile
+++ b/scripts/package/Makefile
@@ -49,9 +49,7 @@ rpm-pkg rpm: FORCE
 	tar -cz $(RCS_TAR_IGNORE) -f $(KERNELPATH).tar.gz $(TAR_CONTENT)
 	rm $(KERNELPATH)
 	rm -f $(objtree)/.scmversion
-	set -e; \
 	$(CONFIG_SHELL) $(srctree)/scripts/mkversion > $(objtree)/.tmp_version
-	set -e; \
 	mv -f $(objtree)/.tmp_version $(objtree)/.version
 	$(RPM) $(RPMOPTS) --target $(UTS_MACHINE) -ta $(KERNELPATH).tar.gz
 	rm $(KERNELPATH).tar.gz kernel.spec
@@ -61,9 +59,7 @@ rpm-pkg rpm: FORCE
 binrpm-pkg: FORCE
 	$(MAKE) KBUILD_SRC=
 	$(CONFIG_SHELL) $(MKSPEC) prebuilt > $(objtree)/binkernel.spec
-	set -e; \
 	$(CONFIG_SHELL) $(srctree)/scripts/mkversion > $(objtree)/.tmp_version
-	set -e; \
 	mv -f $(objtree)/.tmp_version $(objtree)/.version
 
 	$(RPM) $(RPMOPTS) --define "_builddir $(objtree)" --target \
-- 
1.7.3.1

