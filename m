Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758323AbaDIHQH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 03:16:07 -0400
Received: from smtp.mei.co.jp ([133.183.100.20]:40386 "EHLO smtp.mei.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751279AbaDIHQF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 03:16:05 -0400
From: Masahiro Yamada <yamada.m@jp.panasonic.com>
To: linux-kernel@vger.kernel.org
Cc: linux-kbuild@vger.kernel.org, Masahiro Yamada <yamada.m@jp.panasonic.com>
Subject: [PATCH] x86: suppress "Nothing to be done for ..." messages
Date: Wed,  9 Apr 2014 16:15:53 +0900
Message-Id: <1397027753-15444-1-git-send-email-yamada.m@jp.panasonic.com>
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

Signed-off-by: Masahiro Yamada <yamada.m@jp.panasonic.com>
---
 arch/x86/syscalls/Makefile | 1 +
 arch/x86/tools/Makefile    | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/x86/syscalls/Makefile b/arch/x86/syscalls/Makefile
index f325af2..b6c923a 100644
--- a/arch/x86/syscalls/Makefile
+++ b/arch/x86/syscalls/Makefile
@@ -56,3 +56,4 @@ targets	+= $(uapisyshdr-y) $(syshdr-y)
 
 all: $(addprefix $(uapi)/,$(uapisyshdr-y))
 all: $(addprefix $(out)/,$(syshdr-y))
+	@:
diff --git a/arch/x86/tools/Makefile b/arch/x86/tools/Makefile
index e812034..95e3ed7 100644
--- a/arch/x86/tools/Makefile
+++ b/arch/x86/tools/Makefile
@@ -41,3 +41,4 @@ HOST_EXTRACFLAGS += -I$(srctree)/tools/include
 hostprogs-y	+= relocs
 relocs-objs     := relocs_32.o relocs_64.o relocs_common.o
 relocs: $(obj)/relocs
+	@:
-- 
1.8.3.2

