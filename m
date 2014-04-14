Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840AbaDNLWs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 07:22:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44564 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820AbaDNLWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 07:22:46 -0400
Date: Mon, 14 Apr 2014 04:22:24 -0700
From: tip-bot for Masahiro Yamada <tipbot@zytor.com>
Message-ID: <tip-e6bcd1a8974fab74e9fd679fb64462b2a8deff41@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, pefoley2@pefoley.com, hpa@zytor.com,
        mingo@kernel.org, yamada.m@jp.panasonic.com, mmarek@suse.cz,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, pefoley2@pefoley.com,
        linux-kernel@vger.kernel.org, yamada.m@jp.panasonic.com,
        tglx@linutronix.de, mmarek@suse.cz
In-Reply-To: <1397093742-11144-1-git-send-email-yamada.m@jp.panasonic.com>
References: <1397093742-11144-1-git-send-email-yamada.m@jp.panasonic.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/build: Supress "Nothing to be done for ..."
  messages
Git-Commit-ID: e6bcd1a8974fab74e9fd679fb64462b2a8deff41
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e6bcd1a8974fab74e9fd679fb64462b2a8deff41
Gitweb:     http://git.kernel.org/tip/e6bcd1a8974fab74e9fd679fb64462b2a8deff41
Author:     Masahiro Yamada <yamada.m@jp.panasonic.com>
AuthorDate: Thu, 10 Apr 2014 10:35:42 +0900
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 14 Apr 2014 11:44:36 +0200

x86/build: Supress "Nothing to be done for ..." messages

When we build an already built kernel again, arch/x86/syscalls/Makefile
and arch/x86/tools/Makefile emits "Nothing to be done for ..."
messages.

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

Besides not emitting those, "all" and "relocs" should be added to PHONY as well.

Signed-off-by: Masahiro Yamada <yamada.m@jp.panasonic.com>
Acked-by: Peter Foley <pefoley2@pefoley.com>
Acked-by: Michal Marek <mmarek@suse.cz>
Link: http://lkml.kernel.org/r/1397093742-11144-1-git-send-email-yamada.m@jp.panasonic.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
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
