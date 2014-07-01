Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757734AbaGAOMm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 10:12:42 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:50338 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757340AbaGAOMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 10:12:41 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] scripts/tags.sh: Include compat_sys_* symbols in the generated tags
Date: Tue,  1 Jul 2014 15:12:29 +0100
Message-Id: <1404223949-24525-1-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the kernel now has a COMPAT_SYSCALL infrastructure (commit
468366138850f), add the corresponding regex for generating compat_sys_*
symbols in the tags files (similar to sys_*).

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 scripts/tags.sh | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/scripts/tags.sh b/scripts/tags.sh
index e6b011fe1d0d..cbfd269a6011 100755
--- a/scripts/tags.sh
+++ b/scripts/tags.sh
@@ -168,6 +168,7 @@ exuberant()
 	--extra=+f --c-kinds=+px                                \
 	--regex-asm='/^(ENTRY|_GLOBAL)\(([^)]*)\).*/\2/'        \
 	--regex-c='/^SYSCALL_DEFINE[[:digit:]]?\(([^,)]*).*/sys_\1/' \
+	--regex-c='/^COMPAT_SYSCALL_DEFINE[[:digit:]]?\(([^,)]*).*/compat_sys_\1/' \
 	--regex-c++='/^TRACE_EVENT\(([^,)]*).*/trace_\1/'		\
 	--regex-c++='/^DEFINE_EVENT\([^,)]*, *([^,)]*).*/trace_\1/'	\
 	--regex-c++='/PAGEFLAG\(([^,)]*).*/Page\1/'			\
@@ -231,6 +232,7 @@ emacs()
 	all_target_sources | xargs $1 -a                        \
 	--regex='/^\(ENTRY\|_GLOBAL\)(\([^)]*\)).*/\2/'         \
 	--regex='/^SYSCALL_DEFINE[0-9]?(\([^,)]*\).*/sys_\1/'   \
+	--regex='/^COMPAT_SYSCALL_DEFINE[0-9]?(\([^,)]*\).*/compat_sys_\1/' \
 	--regex='/^TRACE_EVENT(\([^,)]*\).*/trace_\1/'		\
 	--regex='/^DEFINE_EVENT([^,)]*, *\([^,)]*\).*/trace_\1/' \
 	--regex='/PAGEFLAG(\([^,)]*\).*/Page\1/'			\
