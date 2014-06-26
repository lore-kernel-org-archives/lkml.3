Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757903AbaFZMYK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 08:24:10 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:60762 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752780AbaFZMYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 08:24:08 -0400
Message-ID: <53AC10CB.3000007@gmail.com>
Date: Thu, 26 Jun 2014 20:23:39 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Lennox Wu <lennox.wu@gmail.com>, Guenter Roeck <linux@roeck-us.net>,
        David Rientjes <rientjes@google.com>,
        Liqin Chen <liqin.linux@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v3] arch/score/include/uapi/asm/ptrace.h: Remove the macros
 which not be used currently
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'COUNTER' and other same kind macros are too common to use, and easy to
get conflict with other modules.

At present, they are not used, so it is OK to simply remove them. And the
related warning (allmodconfig with score):

    CC [M]  drivers/md/raid1.o
  In file included from drivers/md/raid1.c:42:0:
  drivers/md/bitmap.h:93:0: warning: "COUNTER" redefined
   #define COUNTER(x) (((bitmap_counter_t) x) & COUNTER_MAX)
   ^
  In file included from ./arch/score/include/asm/ptrace.h:4:0,
                   from include/linux/sched.h:31,
                   from include/linux/blkdev.h:4,
                   from drivers/md/raid1.c:36:
  ./arch/score/include/uapi/asm/ptrace.h:13:0: note: this is the location of the previous definition
   #define COUNTER  38


Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 arch/score/include/uapi/asm/ptrace.h | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/arch/score/include/uapi/asm/ptrace.h b/arch/score/include/uapi/asm/ptrace.h
index f59771a..5c5e794 100644
--- a/arch/score/include/uapi/asm/ptrace.h
+++ b/arch/score/include/uapi/asm/ptrace.h
@@ -4,17 +4,6 @@
 #define PTRACE_GETREGS		12
 #define PTRACE_SETREGS		13
 
-#define PC		32
-#define CONDITION	33
-#define ECR		34
-#define EMA		35
-#define CEH		36
-#define CEL		37
-#define COUNTER		38
-#define LDCR		39
-#define STCR		40
-#define PSR		41
-
 #define SINGLESTEP16_INSN	0x7006
 #define SINGLESTEP32_INSN	0x840C8000
 #define BREAKPOINT16_INSN	0x7002		/* work on SPG300 */
-- 
1.9.2.459.g68773ac
