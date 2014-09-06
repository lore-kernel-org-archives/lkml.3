Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478AbaIFAK4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 20:10:56 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:52523 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617AbaIFAGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 20:06:51 -0400
From: behanw@converseincode.com
To: a.ryabinin@samsung.com, anurag19aggarwal@gmail.com, charlebm@gmail.com,
        cl@linux-foundation.org, dave.long@linaro.org,
        k.khlebnikov@samsung.com, linux@arm.linux.org.uk,
        linyongting@gmail.com, Nikolay.Borisov@arm.com, tglx@linutronix.de,
        tj@kernel.org, u.kleine-koenig@pengutronix.de
Cc: behanw@converseincode.com, Dave.Martin@arm.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        rabin@rab.in, rostedt@goodmis.org, rric@kernel.org,
        will.deacon@arm.com
Subject: [PATCH v2 3/7] arm: LLVMLinux: Use current_stack_pointer for return_address
Date: Fri,  5 Sep 2014 17:06:13 -0700
Message-Id: <1409961977-11762-4-git-send-email-behanw@converseincode.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409961977-11762-1-git-send-email-behanw@converseincode.com>
References: <1409961977-11762-1-git-send-email-behanw@converseincode.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Behan Webster <behanw@converseincode.com>

Use the global current_stack_pointer to get the value of the stack pointer.
This change supports being able to compile the kernel with both gcc and Clang.

Signed-off-by: Behan Webster <behanw@converseincode.com>
Signed-off-by: Mark Charlebois <charlebm@gmail.com>
Reviewed-by: Jan-Simon Möller <dl9pf@gmx.de>
---
 arch/arm/kernel/return_address.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm/kernel/return_address.c b/arch/arm/kernel/return_address.c
index fafedd8..5bceaef 100644
--- a/arch/arm/kernel/return_address.c
+++ b/arch/arm/kernel/return_address.c
@@ -39,13 +39,12 @@ void *return_address(unsigned int level)
 {
 	struct return_address_data data;
 	struct stackframe frame;
-	register unsigned long current_sp asm ("sp");
 
 	data.level = level + 2;
 	data.addr = NULL;
 
 	frame.fp = (unsigned long)__builtin_frame_address(0);
-	frame.sp = current_sp;
+	frame.sp = current_stack_pointer;
 	frame.lr = (unsigned long)__builtin_return_address(0);
 	frame.pc = (unsigned long)return_address;
 
-- 
1.9.1

