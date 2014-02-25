Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283AbaBYJYs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 04:24:48 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:37718 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855AbaBYJYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 04:24:42 -0500
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
To: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com,
        catalin.marinas@arm.com, will.deacon@arm.com, tim.bird@sonymobile.com
Cc: gkulkarni@caviumnetworks.com, dsaxena@linaro.org, arndb@arndb.de,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org,
        AKASHI Takahiro <takahiro.akashi@linaro.org>
Subject: [PATCH v4 6/7] arm64: Add 'notrace' attribute to unwind_frame() for ftrace
Date: Tue, 25 Feb 2014 18:23:15 +0900
Message-Id: <1393320196-2942-7-git-send-email-takahiro.akashi@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393320196-2942-1-git-send-email-takahiro.akashi@linaro.org>
References: <1391768336-5642-1-git-send-email-takahiro.akashi@linaro.org>
 <1393320196-2942-1-git-send-email-takahiro.akashi@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

walk_stackframe() calls unwind_frame(), and if walk_stackframe() is
"notrace", unwind_frame() should be also "notrace".

Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
---
 arch/arm64/kernel/stacktrace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index c3b6c63..54122c4 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -35,7 +35,7 @@
  *	ldp	x29, x30, [sp]
  *	add	sp, sp, #0x10
  */
-int unwind_frame(struct stackframe *frame)
+int notrace unwind_frame(struct stackframe *frame)
 {
 	unsigned long high, low;
 	unsigned long fp = frame->fp;
-- 
1.7.9.5

