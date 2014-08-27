Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932774AbaH0EaA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 00:30:00 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:62157 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932621AbaH0E35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 00:29:57 -0400
From: behanw@converseincode.com
To: ard.biesheuvel@linaro.org, catalin.marinas@arm.com,
        cl@linux-foundation.org, jays.lee@samsung.com,
        k.khlebnikov@samsung.com, larry.bassel@linaro.org, olof@lixom.net,
        peterz@infradead.org, takahiro.akashi@linaro.org, tglx@linutronix.de,
        tj@kernel.org, will.deacon@arm.com
Cc: christoffer.dall@linaro.org, kgene.kim@samsung.com, khilman@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        sungjinn.chung@samsung.com, Behan Webster <behanw@converseincode.com>,
        Mark Charlebois <charlebm@gmail.com>
Subject: [PATCH V2 6/6] arm64: LLVMLinux: Use global stack pointer in return_address()
Date: Tue, 26 Aug 2014 21:29:34 -0700
Message-Id: <1409113774-3172-7-git-send-email-behanw@converseincode.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409113774-3172-1-git-send-email-behanw@converseincode.com>
References: <20140826141608.GT23445@arm.com>
 <1409113774-3172-1-git-send-email-behanw@converseincode.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Behan Webster <behanw@converseincode.com>

The global register current_stack_pointer holds the current stack pointer.
This change supports being able to compile the kernel with both gcc and clang.

Author: Mark Charlebois <charlebm@gmail.com>
Signed-off-by: Mark Charlebois <charlebm@gmail.com>
Signed-off-by: Behan Webster <behanw@converseincode.com>
---
 arch/arm64/kernel/return_address.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/return_address.c b/arch/arm64/kernel/return_address.c
index 89102a6..6c4fd28 100644
--- a/arch/arm64/kernel/return_address.c
+++ b/arch/arm64/kernel/return_address.c
@@ -36,13 +36,12 @@ void *return_address(unsigned int level)
 {
 	struct return_address_data data;
 	struct stackframe frame;
-	register unsigned long current_sp asm ("sp");
 
 	data.level = level + 2;
 	data.addr = NULL;
 
 	frame.fp = (unsigned long)__builtin_frame_address(0);
-	frame.sp = current_sp;
+	frame.sp = current_stack_pointer;
 	frame.pc = (unsigned long)return_address; /* dummy */
 
 	walk_stackframe(&frame, save_return_addr, &data);
-- 
1.9.1

