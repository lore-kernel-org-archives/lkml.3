Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751431AbaK1F1l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 00:27:41 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:51527 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbaK1F1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 00:27:38 -0500
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
To: keescook@chromium.org, catalin.marinas@arm.com, will.deacon@arm.com
Cc: dsaxena@linaro.org, arndb@arndb.de, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        AKASHI Takahiro <takahiro.akashi@linaro.org>
Subject: [PATCH v10 4/6] arm64: add seccomp syscall for compat task
Date: Fri, 28 Nov 2014 14:26:37 +0900
Message-Id: <1417152399-32717-5-git-send-email-takahiro.akashi@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417152399-32717-1-git-send-email-takahiro.akashi@linaro.org>
References: <1417152399-32717-1-git-send-email-takahiro.akashi@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allows compat task to issue seccomp() system call.

Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
---
 arch/arm64/include/asm/unistd32.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/unistd32.h b/arch/arm64/include/asm/unistd32.h
index 9dfdac4..8893ceb 100644
--- a/arch/arm64/include/asm/unistd32.h
+++ b/arch/arm64/include/asm/unistd32.h
@@ -787,7 +787,8 @@ __SYSCALL(__NR_sched_setattr, sys_sched_setattr)
 __SYSCALL(__NR_sched_getattr, sys_sched_getattr)
 #define __NR_renameat2 382
 __SYSCALL(__NR_renameat2, sys_renameat2)
-			/* 383 for seccomp */
+#define __NR_seccomp 383
+__SYSCALL(__NR_seccomp, sys_seccomp)
 #define __NR_getrandom 384
 __SYSCALL(__NR_getrandom, sys_getrandom)
 #define __NR_memfd_create 385
-- 
1.7.9.5

