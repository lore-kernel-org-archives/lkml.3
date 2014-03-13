Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010AbaCMKO1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 06:14:27 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:37982 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753975AbaCMKOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 06:14:23 -0400
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
To: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com,
        catalin.marinas@arm.com, will.deacon@arm.com, tim.bird@sonymobile.com
Cc: gkulkarni@caviumnetworks.com, dsaxena@linaro.org, arndb@arndb.de,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org,
        AKASHI Takahiro <takahiro.akashi@linaro.org>
Subject: [PATCH v6 1/7] arm64: add __ASSEMBLY__ in asm/insn.h
Date: Thu, 13 Mar 2014 19:13:44 +0900
Message-Id: <1394705630-12384-2-git-send-email-takahiro.akashi@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1394705630-12384-1-git-send-email-takahiro.akashi@linaro.org>
References: <1393564724-3966-1-git-send-email-takahiro.akashi@linaro.org>
 <1394705630-12384-1-git-send-email-takahiro.akashi@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since insn.h is indirectly included in asm/entry-ftrace.S,
we need to exclude some declarations by __ASSEMBLY__.

Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
---
 arch/arm64/include/asm/insn.h |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/include/asm/insn.h b/arch/arm64/include/asm/insn.h
index c44ad39..dc1f73b 100644
--- a/arch/arm64/include/asm/insn.h
+++ b/arch/arm64/include/asm/insn.h
@@ -21,6 +21,7 @@
 /* A64 instructions are always 32 bits. */
 #define	AARCH64_INSN_SIZE		4
 
+#ifndef __ASSEMBLY__
 /*
  * ARM Architecture Reference Manual for ARMv8 Profile-A, Issue A.a
  * Section C3.1 "A64 instruction index by encoding":
@@ -104,5 +105,6 @@ bool aarch64_insn_hotpatch_safe(u32 old_insn, u32 new_insn);
 int aarch64_insn_patch_text_nosync(void *addr, u32 insn);
 int aarch64_insn_patch_text_sync(void *addrs[], u32 insns[], int cnt);
 int aarch64_insn_patch_text(void *addrs[], u32 insns[], int cnt);
+#endif /* __ASSEMBLY__ */
 
 #endif	/* __ASM_INSN_H */
-- 
1.7.9.5

