Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504AbaAPKqA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 05:46:00 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:47012 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbaAPKp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 05:45:57 -0500
From: Jean Pihet <jean.pihet@linaro.org>
To: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org,
        Will Deacon <will.deacon@arm.com>, Arnaldo <acme@ghostprotocols.net>
Cc: patches@linaro.org, Jiri Olsa <jolsa@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>
Subject: [PATCH] ARM64: perf: support dwarf unwinding in compat mode
Date: Thu, 16 Jan 2014 11:45:23 +0100
Message-Id: <1389869123-5884-1-git-send-email-jean.pihet@linaro.org>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for unwinding using the dwarf information in compat
mode. Using the correct user stack pointer allows perf to record
the frames correctly in the native and compat modes.

Note that although the dwarf frame unwinding works ok using
libunwind in native mode (on ARMv7 & ARMv8), some changes are
required to the libunwind code for the compat mode. Those changes
are posted separately on the libunwind mailing list.

Tested on ARMv8 platform with v8 and compat v7 binaries, the latter
are statically built.

Signed-off-by: Jean Pihet <jean.pihet@linaro.org>
---
 arch/arm64/include/asm/ptrace.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/ptrace.h b/arch/arm64/include/asm/ptrace.h
index fbb0020..86d5b54 100644
--- a/arch/arm64/include/asm/ptrace.h
+++ b/arch/arm64/include/asm/ptrace.h
@@ -133,7 +133,7 @@ struct pt_regs {
 	(!((regs)->pstate & PSR_F_BIT))
 
 #define user_stack_pointer(regs) \
-	((regs)->sp)
+	(!compat_user_mode(regs)) ? ((regs)->sp) : ((regs)->compat_sp)
 
 /*
  * Are the current registers suitable for user mode? (used to maintain
-- 
1.7.11.7

