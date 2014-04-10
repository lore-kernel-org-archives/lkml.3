Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934606AbaDJBiF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 21:38:05 -0400
Received: from smtp.mei.co.jp ([133.183.100.20]:37926 "EHLO smtp.mei.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933287AbaDJBiD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 21:38:03 -0400
From: Masahiro Yamada <yamada.m@jp.panasonic.com>
To: linux-kernel@vger.kernel.org
Cc: linux-kbuild@vger.kernel.org, Masahiro Yamada <yamada.m@jp.panasonic.com>,
        x86 <x86@kernel.org>
Subject: [PATCH v2] x86: suppress "Nothing to be done for ..." messages
Date: Thu, 10 Apr 2014 10:35:42 +0900
Message-Id: <1397093742-11144-1-git-send-email-yamada.m@jp.panasonic.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we compiled again, arch/x86/syscalls/Makefile and
arch/x86/tools/Makefile emitted "Nothing to be done for ..." messages.

Here is the command log:

  $ make defconfig
     [ snip ]
  $ make
     [ snip ]
  $ make
  make[1]: Nothing to be done for `all'.            <-----
  make[1]: Nothing to be done for `relocs'.         <-----
    CHK     include/config/kernel.release
    CHK     include/generated/uapi/linux/version.h

Besides those fixes, "all" and "relocs" should be added to PHONY.

Signed-off-by: Masahiro Yamada <yamada.m@jp.panasonic.com>
Acked-by: Peter Foley <pefoley2@pefoley.com>
Acked-by: Michal Marek <mmarek@suse.cz>
Cc: x86 <x86@kernel.org>
---

Changes in v2:
  - Add "all" and "relocs" to PHONY.

 arch/x86/syscalls/Makefile | 2 ++
 arch/x86/tools/Makefile    | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/arch/x86/syscalls/Makefile b/arch/x86/syscalls/Makefile
index f325af2..3323c27 100644
--- a/arch/x86/syscalls/Makefile
+++ b/arch/x86/syscalls/Makefile
@@ -54,5 +54,7 @@ syshdr-$(CONFIG_X86_64)		+= syscalls_64.h
 
 targets	+= $(uapisyshdr-y) $(syshdr-y)
 
+PHONY += all
 all: $(addprefix $(uapi)/,$(uapisyshdr-y))
 all: $(addprefix $(out)/,$(syshdr-y))
+	@:
diff --git a/arch/x86/tools/Makefile b/arch/x86/tools/Makefile
index e812034..604a37e 100644
--- a/arch/x86/tools/Makefile
+++ b/arch/x86/tools/Makefile
@@ -40,4 +40,6 @@ $(obj)/insn_sanity.o: $(srctree)/arch/x86/lib/insn.c $(srctree)/arch/x86/lib/ina
 HOST_EXTRACFLAGS += -I$(srctree)/tools/include
 hostprogs-y	+= relocs
 relocs-objs     := relocs_32.o relocs_64.o relocs_common.o
+PHONY += relocs
 relocs: $(obj)/relocs
+	@:
-- 
1.8.3.2

