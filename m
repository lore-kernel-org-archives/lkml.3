Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822AbaBGKM0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 05:12:26 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:59363 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011AbaBGKMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 05:12:24 -0500
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
To: wad@chromium.org, catalin.marinas@arm.com, will.deacon@arm.com
Cc: arndb@arndb.de, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        patches@linaro.org, AKASHI Takahiro <takahiro.akashi@linaro.org>
Subject: [PATCH 2/2] arm64: is_compat_task is defined both in asm/compat.h and linux/compat.h
Date: Fri,  7 Feb 2014 19:11:32 +0900
Message-Id: <1391767892-5395-3-git-send-email-takahiro.akashi@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391767892-5395-1-git-send-email-takahiro.akashi@linaro.org>
References: <1391767892-5395-1-git-send-email-takahiro.akashi@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel/seccomp.c includes linux/compat.h and, indicrectly, asm/compat.h
via asm/syscall.h. Due to the duplicated definition of is_compat_task,
compiling this file will fail in the case of !CONFIG_COMPAT.
This patch makes the definition in asm/compat.h valid only if necessary.

Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
---
 arch/arm64/include/asm/compat.h |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/include/asm/compat.h b/arch/arm64/include/asm/compat.h
index fda2704..72f3b18 100644
--- a/arch/arm64/include/asm/compat.h
+++ b/arch/arm64/include/asm/compat.h
@@ -305,10 +305,12 @@ static inline int is_compat_thread(struct thread_info *thread)
 
 #else /* !CONFIG_COMPAT */
 
+#ifndef is_compat_task /* it's there in linux/compat.h */
 static inline int is_compat_task(void)
 {
 	return 0;
 }
+#endif
 
 static inline int is_compat_thread(struct thread_info *thread)
 {
-- 
1.7.9.5

