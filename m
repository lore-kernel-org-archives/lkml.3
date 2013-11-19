Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751979Ab3KSDIr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 22:08:47 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:60871 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469Ab3KSDIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 22:08:43 -0500
Message-ID: <528AD6B3.1060507@gmail.com>
Date: Tue, 19 Nov 2013 11:10:43 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Richard Kuo <rkuo@codeaurora.org>
CC: linux-hexagon@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] arch: hexagon: kernel: add export symbol function __delay()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Need add __delay() implementation, or can not pass allmodconfig in
next-20131118 tree.

The related error:

    CC      kernel/locking/spinlock_debug.o
  kernel/locking/spinlock_debug.c: In function '__spin_lock_debug':
  kernel/locking/spinlock_debug.c:114:3: error: implicit declaration of function '__delay' [-Werror=implicit-function-declaration]


Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 arch/hexagon/include/asm/delay.h |    1 +
 arch/hexagon/kernel/time.c       |    9 +++++++++
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/hexagon/include/asm/delay.h b/arch/hexagon/include/asm/delay.h
index 5307971..8933b9b1 100644
--- a/arch/hexagon/include/asm/delay.h
+++ b/arch/hexagon/include/asm/delay.h
@@ -21,6 +21,7 @@
 
 #include <asm/param.h>
 
+extern void __delay(unsigned long cycles);
 extern void __udelay(unsigned long usecs);
 
 #define udelay(usecs) __udelay((usecs))
diff --git a/arch/hexagon/kernel/time.c b/arch/hexagon/kernel/time.c
index d0c4f5a..17fbf45 100644
--- a/arch/hexagon/kernel/time.c
+++ b/arch/hexagon/kernel/time.c
@@ -229,6 +229,15 @@ void __init time_init(void)
 	late_time_init = time_init_deferred;
 }
 
+void __delay(unsigned long cycles)
+{
+	unsigned long long start = __vmgettime();
+
+	while ((__vmgettime() - start) < cycles)
+		cpu_relax();
+}
+EXPORT_SYMBOL(__delay);
+
 /*
  * This could become parametric or perhaps even computed at run-time,
  * but for now we take the observed simulator jitter.
-- 
1.7.7.6
