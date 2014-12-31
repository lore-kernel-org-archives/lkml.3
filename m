Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751881AbaLaPWz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 10:22:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56799 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751856AbaLaPWw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 10:22:52 -0500
From: Pratyush Anand <panand@redhat.com>
To: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk
Cc: tixy@linaro.org, ananth@in.ibm.com, sandeepa.prabhu@linaro.org,
        catalin.marinas@arm.com, will.deacon@arm.com,
        linux-kernel@vger.kernel.org, anil.s.keshavamurthy@intel.com,
        masami.hiramatsu.pt@hitachi.com, wcohen@redhat.com, oleg@redhat.com,
        Pratyush Anand <panand@redhat.com>
Subject: [RFC 4/8] ARM64: Add instruction_pointer_set function
Date: Wed, 31 Dec 2014 20:51:20 +0530
Message-Id: <028aab951a24c56075b1060afa1c2b2d88c09083.1420038188.git.panand@redhat.com>
In-Reply-To: <cover.1420038188.git.panand@redhat.com>
References: <cover.1420038188.git.panand@redhat.com>
In-Reply-To: <cover.1420038188.git.panand@redhat.com>
References: <cover.1420038188.git.panand@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

instruction_pointer_set is needed for uprobe implementation. Hence
define it for ARM64.

Signed-off-by: Pratyush Anand <panand@redhat.com>
---
 arch/arm64/include/asm/ptrace.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/include/asm/ptrace.h b/arch/arm64/include/asm/ptrace.h
index 24cc048ac3e7..29d9bf5e3635 100644
--- a/arch/arm64/include/asm/ptrace.h
+++ b/arch/arm64/include/asm/ptrace.h
@@ -206,6 +206,12 @@ static inline int valid_user_regs(struct user_pt_regs *regs)
 #define instruction_pointer(regs)	((regs)->pc)
 #define stack_pointer(regs)		((regs)->sp)
 
+static inline void instruction_pointer_set(struct pt_regs *regs,
+					   unsigned long val)
+{
+	instruction_pointer(regs) = val;
+}
+
 #ifdef CONFIG_SMP
 extern unsigned long profile_pc(struct pt_regs *regs);
 #else
-- 
2.1.0

