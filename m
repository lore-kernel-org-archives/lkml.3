Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751335AbaK1Mwf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 07:52:35 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56709 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919AbaK1Mwe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 07:52:34 -0500
From: Michal Marek <mmarek@suse.cz>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH] kbuild: Fix make help-<board series> on powerpc
Date: Fri, 28 Nov 2014 13:52:25 +0100
Message-Id: <1417179145-30789-1-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

make ARCH=powerpc help-<board series> should not require a cofigured
source tree. Also, sort the boards in the output.

Signed-off-by: Michal Marek <mmarek@suse.cz>
---
Sorry for the double post to the ppc mailing list. The first version got
rejected by the vger spam filter.
---
 Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 88b7fa5..0cd4e14 100644
--- a/Makefile
+++ b/Makefile
@@ -482,7 +482,7 @@ asm-generic:
 version_h := include/generated/uapi/linux/version.h
 
 no-dot-config-targets := clean mrproper distclean \
-			 cscope gtags TAGS tags help %docs check% coccicheck \
+			 cscope gtags TAGS tags help% %docs check% coccicheck \
 			 $(version_h) headers_% archheaders archscripts \
 			 kernelversion %src-pkg
 
@@ -1323,7 +1323,7 @@ help-board-dirs := $(addprefix help-,$(board-dirs))
 
 help-boards: $(help-board-dirs)
 
-boards-per-dir = $(notdir $(wildcard $(srctree)/arch/$(SRCARCH)/configs/$*/*_defconfig))
+boards-per-dir = $(sort $(notdir $(wildcard $(srctree)/arch/$(SRCARCH)/configs/$*/*_defconfig)))
 
 $(help-board-dirs): help-%:
 	@echo  'Architecture specific targets ($(SRCARCH) $*):'
-- 
2.1.2

