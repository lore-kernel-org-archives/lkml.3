Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932092AbaDVJqr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 05:46:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47815 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754752AbaDVJqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 05:46:16 -0400
Date: Tue, 22 Apr 2014 02:45:36 -0700
From: tip-bot for Behan Webster <tipbot@zytor.com>
Message-ID: <tip-8f2dd677bec68fb55904799a82674c9e64b23be3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        behanw@converseincode.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        behanw@converseincode.com, tglx@linutronix.de
In-Reply-To: <1398145227-25053-1-git-send-email-behanw@converseincode.com>
References: <1398145227-25053-1-git-send-email-behanw@converseincode.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: LLVMLinux: Wrap -mno-80387 with cc-option
Git-Commit-ID: 8f2dd677bec68fb55904799a82674c9e64b23be3
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

Commit-ID:  8f2dd677bec68fb55904799a82674c9e64b23be3
Gitweb:     http://git.kernel.org/tip/8f2dd677bec68fb55904799a82674c9e64b23be3
Author:     Behan Webster <behanw@converseincode.com>
AuthorDate: Mon, 21 Apr 2014 22:40:27 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 22 Apr 2014 11:41:16 +0200

x86: LLVMLinux: Wrap -mno-80387 with cc-option

Wrap -mno-80387 gcc options with cc-option so they don't break
clang.

Signed-off-by: Behan Webster <behanw@converseincode.com>
Cc: torvalds@linux-foundation.org
Cc: dwmw2@infradead.org
Cc: pageexec@freemail.hu
Link: http://lkml.kernel.org/r/1398145227-25053-1-git-send-email-behanw@converseincode.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
