Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932802AbaH0Eai (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 00:30:38 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:43483 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050AbaH0E3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 00:29:54 -0400
From: behanw@converseincode.com
To: ard.biesheuvel@linaro.org, catalin.marinas@arm.com,
        cl@linux-foundation.org, jays.lee@samsung.com,
        k.khlebnikov@samsung.com, larry.bassel@linaro.org, olof@lixom.net,
        peterz@infradead.org, takahiro.akashi@linaro.org, tglx@linutronix.de,
        tj@kernel.org, will.deacon@arm.com
Cc: christoffer.dall@linaro.org, kgene.kim@samsung.com, khilman@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        sungjinn.chung@samsung.com, Mark Charlebois <charlebm@gmail.com>,
        Behan Webster <behanw@converseincode.com>
Subject: [PATCH V2 5/6] arm64: LLVMLinux: Use global stack register variable for aarch64
Date: Tue, 26 Aug 2014 21:29:33 -0700
Message-Id: <1409113774-3172-6-git-send-email-behanw@converseincode.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409113774-3172-1-git-send-email-behanw@converseincode.com>
References: <20140826141608.GT23445@arm.com>
 <1409113774-3172-1-git-send-email-behanw@converseincode.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Charlebois <charlebm@gmail.com>

To support both Clang and GCC, use the global stack register variable vs
a local register variable.

Author: Mark Charlebois <charlebm@gmail.com>
Signed-off-by: Mark Charlebois <charlebm@gmail.com>
Signed-off-by: Behan Webster <behanw@converseincode.com>
---
 arch/arm64/include/asm/percpu.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/percpu.h b/arch/arm64/include/asm/percpu.h
index 453a179..5279e57 100644
--- a/arch/arm64/include/asm/percpu.h
+++ b/arch/arm64/include/asm/percpu.h
@@ -26,13 +26,13 @@ static inline void set_my_cpu_offset(unsigned long off)
 static inline unsigned long __my_cpu_offset(void)
 {
 	unsigned long off;
-	register unsigned long *sp asm ("sp");
 
 	/*
 	 * We want to allow caching the value, so avoid using volatile and
 	 * instead use a fake stack read to hazard against barrier().
 	 */
-	asm("mrs %0, tpidr_el1" : "=r" (off) : "Q" (*sp));
+	asm("mrs %0, tpidr_el1" : "=r" (off) :
+		"Q" (*(const unsigned long *)current_stack_pointer));
 
 	return off;
 }
-- 
1.9.1

