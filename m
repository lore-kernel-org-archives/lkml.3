Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750984AbaFVEsL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 00:48:11 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:46204 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752AbaFVEsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 00:48:10 -0400
Message-ID: <53A66000.4010208@gmail.com>
Date: Sun, 22 Jun 2014 12:48:00 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Liqin Chen <liqin.linux@gmail.com>, Lennox Wu <lennox.wu@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] arch/score/include/uapi/asm/ptrace.h: Add prefix 'SCORE_'
 for related macros
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'COUNTER' and other same kind macros are too common to use, and easy to
get conflict with other modules. So add prefix for them.

The related warning (allmodconfig with score):

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
 arch/score/include/uapi/asm/ptrace.h | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/score/include/uapi/asm/ptrace.h b/arch/score/include/uapi/asm/ptrace.h
index f59771a..7a0ead9 100644
--- a/arch/score/include/uapi/asm/ptrace.h
+++ b/arch/score/include/uapi/asm/ptrace.h
@@ -4,16 +4,16 @@
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
+#define SCORE_PC		32
+#define SCORE_CONDITION		33
+#define SCORE_ECR		34
+#define SCORE_EMA		35
+#define SCORE_CEH		36
+#define SOCRE_CEL		37
+#define SCORE_COUNTER		38
+#define SCORE_LDCR		39
+#define SCORE_STCR		40
+#define SCORE_PSR		41
 
 #define SINGLESTEP16_INSN	0x7006
 #define SINGLESTEP32_INSN	0x840C8000
-- 
1.9.2.459.g68773ac
