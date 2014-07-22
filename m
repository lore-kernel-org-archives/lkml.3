Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751709AbaGVApm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 20:45:42 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:48601 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889AbaGVApk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 20:45:40 -0400
Date: Mon, 21 Jul 2014 17:45:38 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>, Lennox Wu <lennox.wu@gmail.com>
cc: Guenter Roeck <linux@roeck-us.net>, Liqin Chen <liqin.linux@gmail.com>,
        Chen Gang <gang.chen.5i5j@gmail.com>, linux-kernel@vger.kernel.org
Subject: [patch] score, ptrace: Remove the macros which not be used
 currently
In-Reply-To: <alpine.DEB.2.02.1407171437270.5185@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.02.1407211744190.7042@chino.kir.corp.google.com>
References: <53AC10CB.3000007@gmail.com> <alpine.DEB.2.02.1406261456150.12443@chino.kir.corp.google.com> <alpine.DEB.2.02.1407161849090.19429@chino.kir.corp.google.com> <CAF0htA5eVTPQC0c1XfzU=RHnNWLtRgtYbN+se5HPLYkJ9_E=5w@mail.gmail.com> <53C73534.1090502@roeck-us.net>
 <CAF0htA6awFMsfPRRr9=s4Hcxcu586WHWRwyg=C0zc2Yr7CyvKQ@mail.gmail.com> <alpine.DEB.2.02.1407171437270.5185@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chen Gang <gang.chen.5i5j@gmail.com>

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
Signed-off-by: David Rientjes <rientjes@google.com>
---
 Andrew, since the maintainers of score are non-responsive, could you 
 please pick this up?

 arch/score/include/uapi/asm/ptrace.h | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/arch/score/include/uapi/asm/ptrace.h b/arch/score/include/uapi/asm/ptrace.h
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
