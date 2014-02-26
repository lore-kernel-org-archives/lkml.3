Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752248AbaBZBKY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 20:10:24 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:47842 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038AbaBZBJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 20:09:41 -0500
From: behanw@converseincode.com
To: mmarek@suse.cz, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, sparse@chrisli.org
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sparse@vger.kernel.org, torvalds@linux-foundation.org,
        dwmw2@infradead.org, pageexec@freemail.hu,
        =?UTF-8?q?Jan-Simon=20M=C3=B6ller?= <dl9pf@gmx.de>,
        Behan Webster <behanw@converseincode.com>,
        Mark Charlebois <charlebm@gmail.com>
Subject: [PATCH 5/5] x86 kbuild: LLVMLinux: More cc-options added for clang
Date: Tue, 25 Feb 2014 17:08:43 -0800
Message-Id: <1393376923-21892-6-git-send-email-behanw@converseincode.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393376923-21892-1-git-send-email-behanw@converseincode.com>
References: <1393376923-21892-1-git-send-email-behanw@converseincode.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan-Simon Möller <dl9pf@gmx.de>

Protect more options for x86 with cc-option so that we don't get errors when
using clang instead of gcc.  Add more or different options when using clang as
well. Also need to enforce that SSE is off for clang and the stack is 8-byte
aligned.

Signed-off-by: Jan-Simon Möller <dl9pf@gmx.de>
Signed-off-by: Behan Webster <behanw@converseincode.com>
Signed-off-by: Mark Charlebois <charlebm@gmail.com>
---
 arch/x86/Makefile | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index eeda43a..852d8f0 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -108,7 +108,7 @@ else
 
         # this works around some issues with generating unwind tables in older gccs
         # newer gccs do it by default
-        KBUILD_CFLAGS += -maccumulate-outgoing-args
+        KBUILD_CFLAGS += $(call cc-option,-maccumulate-outgoing-args)
 endif
 
 # Make sure compiler does not have buggy stack-protector support.
@@ -144,6 +144,12 @@ endif
 sp-$(CONFIG_X86_32) := esp
 sp-$(CONFIG_X86_64) := rsp
 
+# enforce no-sse for clang
+ifneq ($(COMPILER),clang)
+        KBUILD_CFLAGS += $(call cc-option,-mno-sse)
+        KBUILD_CFLAGS += $(call cc-option,-mpreferred-stack-boundary=3)
+endif
+
 # do binutils support CFI?
 cfi := $(call as-instr,.cfi_startproc\n.cfi_rel_offset $(sp-y)$(comma)0\n.cfi_endproc,-DCONFIG_AS_CFI=1)
 # is .cfi_signal_frame supported too?
-- 
1.8.3.2

