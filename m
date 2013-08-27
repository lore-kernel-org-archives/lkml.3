Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481Ab3H0Nx6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 09:53:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42634 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753062Ab3H0Nx5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 09:53:57 -0400
From: Michal Marek <mmarek@suse.cz>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] kbuild: Do not overwrite include/config/kernel.release needlessly
Date: Tue, 27 Aug 2013 15:53:44 +0200
Message-Id: <1377611624-11570-1-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use filechk to detect if the content changed or not.

Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 Makefile | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 4e3575c..3aa232f 100644
--- a/Makefile
+++ b/Makefile
@@ -794,10 +794,13 @@ PHONY += $(vmlinux-dirs)
 $(vmlinux-dirs): prepare scripts
 	$(Q)$(MAKE) $(build)=$@
 
+define filechk_kernel.release
+	echo "$(KERNELVERSION)$$($(CONFIG_SHELL) $(srctree)/scripts/setlocalversion $(srctree))"
+endef
+
 # Store (new) KERNELRELEASE string in include/config/kernel.release
 include/config/kernel.release: include/config/auto.conf FORCE
-	$(Q)rm -f $@
-	$(Q)echo "$(KERNELVERSION)$$($(CONFIG_SHELL) $(srctree)/scripts/setlocalversion $(srctree))" > $@
+	$(call filechk,kernel.release)
 
 
 # Things we need to do before we recursively start building the kernel
-- 
1.8.1.4

