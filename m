Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757024AbaHHPXY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 11:23:24 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:61023 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782AbaHHPXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 11:23:22 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Michal Marek <mmarek@suse.cz>, Randy Dunlap <rdunlap@infradead.org>
Cc: linux-kbuild@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 1/4] Documentation: kbuild: Remove obsolete include/asm symlink step
Date: Fri,  8 Aug 2014 17:23:07 +0200
Message-Id: <1407511390-5429-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As of commit f7f16b7799ed68654850ab340ef812895aebcf4c ("kbuild: drop
include/asm"), the include/asm symlink is no longer created.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 Documentation/kbuild/makefiles.txt | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/Documentation/kbuild/makefiles.txt b/Documentation/kbuild/makefiles.txt
index c600e2f44a62..3b416592cc44 100644
--- a/Documentation/kbuild/makefiles.txt
+++ b/Documentation/kbuild/makefiles.txt
@@ -841,17 +841,16 @@ a few targets.
 When kbuild executes, the following steps are followed (roughly):
 1) Configuration of the kernel => produce .config
 2) Store kernel version in include/linux/version.h
-3) Symlink include/asm to include/asm-$(ARCH)
-4) Updating all other prerequisites to the target prepare:
+3) Updating all other prerequisites to the target prepare:
    - Additional prerequisites are specified in arch/$(ARCH)/Makefile
-5) Recursively descend down in all directories listed in
+4) Recursively descend down in all directories listed in
    init-* core* drivers-* net-* libs-* and build all targets.
    - The values of the above variables are expanded in arch/$(ARCH)/Makefile.
-6) All object files are then linked and the resulting file vmlinux is
+5) All object files are then linked and the resulting file vmlinux is
    located at the root of the obj tree.
    The very first objects linked are listed in head-y, assigned by
    arch/$(ARCH)/Makefile.
-7) Finally, the architecture-specific part does any required post processing
+6) Finally, the architecture-specific part does any required post processing
    and builds the final bootimage.
    - This includes building boot records
    - Preparing initrd images and the like
-- 
1.9.1

