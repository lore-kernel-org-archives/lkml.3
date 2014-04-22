Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949AbaDVFkv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 01:40:51 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:40424 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166AbaDVFks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 01:40:48 -0400
From: behanw@converseincode.com
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        dwmw2@infradead.org, pageexec@freemail.hu,
        Behan Webster <behanw@converseincode.com>
Subject: [PATCH] x86: LLVMLinux: Wrap -mno-80387 with cc-option
Date: Mon, 21 Apr 2014 22:40:27 -0700
Message-Id: <1398145227-25053-1-git-send-email-behanw@converseincode.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Behan Webster <behanw@converseincode.com>

Wrap -mno-80387 gcc options with cc-option so they don't break clang.

Signed-off-by: Behan Webster <behanw@converseincode.com>
---
 arch/x86/Makefile | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index d1b7c37..ce6ad7e 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -83,7 +83,9 @@ else
         KBUILD_CFLAGS += -m64
 
         # Don't autogenerate traditional x87, MMX or SSE instructions
-        KBUILD_CFLAGS += -mno-mmx -mno-sse -mno-80387 -mno-fp-ret-in-387
+        KBUILD_CFLAGS += -mno-mmx -mno-sse
+        KBUILD_CFLAGS += $(call cc-option,-mno-80387)
+        KBUILD_CFLAGS += $(call cc-option,-mno-fp-ret-in-387)
 
 	# Use -mpreferred-stack-boundary=3 if supported.
 	KBUILD_CFLAGS += $(call cc-option,-mpreferred-stack-boundary=3)
-- 
1.8.3.2

