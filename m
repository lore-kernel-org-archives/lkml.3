Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408AbaJDAVR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 20:21:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45289 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756034AbaJCVnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:43:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sudeep Holla <sudeep.holla@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH 3.16 201/357] arm64: Add brackets around user_stack_pointer()
Date: Fri,  3 Oct 2014 14:29:47 -0700
Message-Id: <20141003212939.515937313@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Catalin Marinas <catalin.marinas@arm.com>

commit 2520d039728b2a3c5ae7f79fe2a0e9d182855b12 upstream.

Commit 5f888a1d33 (ARM64: perf: support dwarf unwinding in compat mode)
changes user_stack_pointer() to return the compat SP for 32-bit tasks
but without brackets around the whole definition, with possible issues
on the call sites (noticed with a subsequent fix for KSTK_ESP).

Fixes: 5f888a1d33c4 (ARM64: perf: support dwarf unwinding in compat mode)
Reported-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/include/asm/ptrace.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/include/asm/ptrace.h
+++ b/arch/arm64/include/asm/ptrace.h
@@ -137,7 +137,7 @@ struct pt_regs {
 	(!((regs)->pstate & PSR_F_BIT))
 
 #define user_stack_pointer(regs) \
-	(!compat_user_mode(regs)) ? ((regs)->sp) : ((regs)->compat_sp)
+	(!compat_user_mode(regs) ? (regs)->sp : (regs)->compat_sp)
 
 static inline unsigned long regs_return_value(struct pt_regs *regs)
 {


