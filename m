Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537AbaBGKUV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 05:20:21 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:43364 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356AbaBGKUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 05:20:16 -0500
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
To: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com,
        catalin.marinas@arm.com, will.deacon@arm.com,
        gkulkarni@caviumnetworks.com, tim.bird@sonymobile.com
Cc: arndb@arndb.de, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        patches@linaro.org, AKASHI Takahiro <takahiro.akashi@linaro.org>
Subject: [PATCH v3 6/6] arm64: Add 'notrace' attribute to unwind_frame() for ftrace
Date: Fri,  7 Feb 2014 19:18:56 +0900
Message-Id: <1391768336-5642-7-git-send-email-takahiro.akashi@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391768336-5642-1-git-send-email-takahiro.akashi@linaro.org>
References: <1382598488-13511-1-git-send-email-takahiro.akashi@linaro.org>
 <1391768336-5642-1-git-send-email-takahiro.akashi@linaro.org>
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

