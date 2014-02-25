Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752902AbaBYJTc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 04:19:32 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:60600 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752873AbaBYJT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 04:19:29 -0500
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
To: viro@zeniv.linux.org.uk, eparis@redhat.com, rgb@redhat.com,
        catalin.marinas@arm.com, will.deacon@arm.com
Cc: dsaxena@linaro.org, arndb@arndb.de, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-audit@redhat.com, AKASHI Takahiro <takahiro.akashi@linaro.org>
Subject: [PATCH v5 1/3] arm64: Add regs_return_value() in syscall.h
Date: Tue, 25 Feb 2014 18:18:52 +0900
Message-Id: <1393319934-2810-2-git-send-email-takahiro.akashi@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393319934-2810-1-git-send-email-takahiro.akashi@linaro.org>
References: <1391767803-5350-1-git-send-email-takahiro.akashi@linaro.org>
 <1393319934-2810-1-git-send-email-takahiro.akashi@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This macro, regs_return_value, is used mainly for audit to record system
call's results, but may also be used in test_kprobes.c.

Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
Acked-by Will Deacon <will.deacon@arm.com>
Acked-by: Richard Guy Briggs <rgb@redhat.com>
---
 arch/arm64/include/asm/ptrace.h |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/include/asm/ptrace.h b/arch/arm64/include/asm/ptrace.h
index 0e7fa49..5800ec1 100644
--- a/arch/arm64/include/asm/ptrace.h
+++ b/arch/arm64/include/asm/ptrace.h
@@ -134,6 +134,11 @@ struct pt_regs {
 #define user_stack_pointer(regs) \
 	((regs)->sp)
 
+static inline unsigned long regs_return_value(struct pt_regs *regs)
+{
+	return regs->regs[0];
+}
+
 /*
  * Are the current registers suitable for user mode? (used to maintain
  * security in signal handlers)
-- 
1.7.9.5

