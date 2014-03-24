Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230AbaCXMyW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 08:54:22 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:57329 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419AbaCXMyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 08:54:19 -0400
Message-ID: <53302AF3.4000700@gmail.com>
Date: Mon, 24 Mar 2014 20:54:11 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: gxt@mprc.pku.edu.cn,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] arch/unicore32/include/asm/ptrace.h: add generic definition
 for profile_pc()
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add generic definition just like another architectures have done, or
can not pass compiling with allmodconfig, the related error:

    CC      kernel/profile.o
  kernel/profile.c: In function ‘profile_tick’:
  kernel/profile.c:419: error: implicit declaration of function ‘profile_pc’
  make[1]: *** [kernel/profile.o] Error 1
  make: *** [kernel] Error 2


Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 arch/unicore32/include/asm/ptrace.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/unicore32/include/asm/ptrace.h b/arch/unicore32/include/asm/ptrace.h
index 9df53d9..02bf5a4 100644
--- a/arch/unicore32/include/asm/ptrace.h
+++ b/arch/unicore32/include/asm/ptrace.h
@@ -55,6 +55,7 @@ static inline int valid_user_regs(struct pt_regs *regs)
 
 #define instruction_pointer(regs)	((regs)->UCreg_pc)
 #define user_stack_pointer(regs)	((regs)->UCreg_sp)
+#define profile_pc(regs)		instruction_pointer(regs)
 
 #endif /* __ASSEMBLY__ */
 #endif
-- 
1.7.9.5
