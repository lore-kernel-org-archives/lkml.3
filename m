Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759367Ab3HNHSh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 03:18:37 -0400
Received: from co9ehsobe003.messaging.microsoft.com ([207.46.163.26]:33467
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759226Ab3HNHSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 03:18:34 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 22
X-BigFish: VS22(z3335s1039mz853kzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6h1082kzz1de098h8275bh1de097hz2dh2a8h668h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1de2h1dfeh1dffh1e23h1fe8h1ff5h1155h)
From: Arpit Goel <B44344@freescale.com>
To: <linux@arm.linux.org.uk>, <takata@linux-m32r.org>, <philb@gnu.org>,
        <geert@linux-m68k.org>
CC: <schwidefsky@de.ibm.com>, <heiko.carstens@de.ibm.com>,
        <linux390@de.ibm.com>, <davem@davemloft.net>,
        <rob.herring@calxeda.com>, <arnd@arndb.de>, <swarren@nvidia.com>,
        <john.stultz@linaro.org>, <jesper.nilsson@axis.com>,
        <gregkh@linuxfoundation.org>, <sam@ravnborg.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-m32r@ml.linux-m32r.org>, <linux-m32r-ja@ml.linux-m32r.org>,
        <linux-m68k@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        <sparclinux@vger.kernel.org>, <mattw@codeaurora.org>, <timur@tabi.org>,
        <sboyd@codeaurora.org>, <akpm@linux-foundation.org>,
        Arpit Goel <B44344@freescale.com>
Subject: [PATCH v2 1/2] Make USECS_PER_JIFFY available for generic use
Date: Wed, 14 Aug 2013 12:33:54 +0530
Message-ID: <1376463835-13040-2-git-send-email-B44344@freescale.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1376463835-13040-1-git-send-email-B44344@freescale.com>
References: <1376463835-13040-1-git-send-email-B44344@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

USECS_PER_JIFFY is used in several ARCHITECTURE C files.Now USECS_PER_JIFFY
has been moved from architecture specific C files to architecture specific
timex.h. This enables users to include timex.h and make use of USECS_PER_JIFFY.

Signed-off-by: Arpit Goel <B44344@freescale.com>
---
 arch/arm/include/asm/timex.h      | 2 ++
 arch/arm/kernel/time.c            | 3 ---
 arch/m32r/include/asm/timex.h     | 2 ++
 arch/m32r/kernel/time.c           | 3 ---
 arch/m68k/hp300/time.c            | 4 +---
 arch/m68k/include/asm/timex.h     | 2 ++
 arch/s390/include/asm/timex.h     | 2 ++
 arch/s390/kernel/time.c           | 2 --
 arch/sparc/include/asm/timex_32.h | 2 ++
 arch/sparc/include/asm/timex_64.h | 2 ++
 arch/sparc/kernel/pcic.c          | 1 -
 include/linux/timex.h             | 5 +++++
 12 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/arch/arm/include/asm/timex.h b/arch/arm/include/asm/timex.h
index 83f2aa8..55a4f34 100644
--- a/arch/arm/include/asm/timex.h
+++ b/arch/arm/include/asm/timex.h
@@ -18,6 +18,8 @@
 #include <mach/timex.h>
 #endif
 
+/* change this if you have some constant time drift */
+#define USECS_PER_JIFFY	(1000000/HZ)
 typedef unsigned long cycles_t;
 #define get_cycles()	({ cycles_t c; read_current_timer(&c) ? 0 : c; })
 
diff --git a/arch/arm/kernel/time.c b/arch/arm/kernel/time.c
index 98aee32..7aaead4 100644
--- a/arch/arm/kernel/time.c
+++ b/arch/arm/kernel/time.c
@@ -38,9 +38,6 @@ DEFINE_SPINLOCK(rtc_lock);
 EXPORT_SYMBOL(rtc_lock);
 #endif	/* pc-style 'CMOS' RTC support */
 
-/* change this if you have some constant time drift */
-#define USECS_PER_JIFFY	(1000000/HZ)
-
 #ifdef CONFIG_SMP
 unsigned long profile_pc(struct pt_regs *regs)
 {
diff --git a/arch/m32r/include/asm/timex.h b/arch/m32r/include/asm/timex.h
index bb9fe4f..ff8e6b1 100644
--- a/arch/m32r/include/asm/timex.h
+++ b/arch/m32r/include/asm/timex.h
@@ -9,6 +9,8 @@
 
 #define CLOCK_TICK_RATE	(CONFIG_BUS_CLOCK / CONFIG_TIMER_DIVIDE)
 #define CLOCK_TICK_FACTOR	20	/* Factor of both 1000000 and CLOCK_TICK_RATE */
+/* change this if you have some constant time drift */
+#define USECS_PER_JIFFY	(1000000/HZ)
 
 #ifdef __KERNEL__
 /*
diff --git a/arch/m32r/kernel/time.c b/arch/m32r/kernel/time.c
index 1a15f81..0608e02 100644
--- a/arch/m32r/kernel/time.c
+++ b/arch/m32r/kernel/time.c
@@ -52,9 +52,6 @@ extern void smp_local_timer_interrupt(void);
  * Change this if you have some constant time drift
  */
 
-/* This is for machines which generate the exact clock. */
-#define USECS_PER_JIFFY (1000000/HZ)
-
 static unsigned long latch;
 
 static u32 m32r_gettimeoffset(void)
diff --git a/arch/m68k/hp300/time.c b/arch/m68k/hp300/time.c
index 749543b..9d751d3 100644
--- a/arch/m68k/hp300/time.c
+++ b/arch/m68k/hp300/time.c
@@ -12,6 +12,7 @@
 #include <linux/sched.h>
 #include <linux/kernel_stat.h>
 #include <linux/interrupt.h>
+#include <linux/time.h>
 #include <asm/machdep.h>
 #include <asm/irq.h>
 #include <asm/io.h>
@@ -30,9 +31,6 @@
 #define	CLKMSB2		0x9
 #define	CLKMSB3		0xD
 
-/* This is for machines which generate the exact clock. */
-#define USECS_PER_JIFFY (1000000/HZ)
-
 #define INTVAL ((10000 / 4) - 1)
 
 static irqreturn_t hp300_tick(int irq, void *dev_id)
diff --git a/arch/m68k/include/asm/timex.h b/arch/m68k/include/asm/timex.h
index 6759dad..44f2603 100644
--- a/arch/m68k/include/asm/timex.h
+++ b/arch/m68k/include/asm/timex.h
@@ -21,6 +21,8 @@
 #define CLOCK_TICK_RATE	1193180 /* Underlying HZ */
 #endif
 
+/* change this if you have some constant time drift */
+#define USECS_PER_JIFFY	(1000000/HZ)
 typedef unsigned long cycles_t;
 
 static inline cycles_t get_cycles(void)
diff --git a/arch/s390/include/asm/timex.h b/arch/s390/include/asm/timex.h
index 8ad8af9..91175c9 100644
--- a/arch/s390/include/asm/timex.h
+++ b/arch/s390/include/asm/timex.h
@@ -13,6 +13,8 @@
 
 /* The value of the TOD clock for 1.1.1970. */
 #define TOD_UNIX_EPOCH 0x7d91048bca000000ULL
+/* change this if you have some constant time drift */
+#define USECS_PER_JIFFY	(1000000/HZ)
 
 /* Inline functions for clock register access. */
 static inline int set_tod_clock(__u64 time)
diff --git a/arch/s390/kernel/time.c b/arch/s390/kernel/time.c
index 876546b..eb659b6 100644
--- a/arch/s390/kernel/time.c
+++ b/arch/s390/kernel/time.c
@@ -49,8 +49,6 @@
 #include <asm/cio.h>
 #include "entry.h"
 
-/* change this if you have some constant time drift */
-#define USECS_PER_JIFFY     ((unsigned long) 1000000/HZ)
 #define CLK_TICKS_PER_JIFFY ((unsigned long) USECS_PER_JIFFY << 12)
 
 u64 sched_clock_base_cc = -1;	/* Force to data section. */
diff --git a/arch/sparc/include/asm/timex_32.h b/arch/sparc/include/asm/timex_32.h
index b6ccdb0..cb7f412 100644
--- a/arch/sparc/include/asm/timex_32.h
+++ b/arch/sparc/include/asm/timex_32.h
@@ -7,6 +7,8 @@
 #define _ASMsparc_TIMEX_H
 
 #define CLOCK_TICK_RATE	1193180 /* Underlying HZ */
+/* change this if you have some constant time drift */
+#define USECS_PER_JIFFY	(1000000/HZ)
 
 /* XXX Maybe do something better at some point... -DaveM */
 typedef unsigned long cycles_t;
diff --git a/arch/sparc/include/asm/timex_64.h b/arch/sparc/include/asm/timex_64.h
index 18b30bc..1a5738a 100644
--- a/arch/sparc/include/asm/timex_64.h
+++ b/arch/sparc/include/asm/timex_64.h
@@ -9,6 +9,8 @@
 #include <asm/timer.h>
 
 #define CLOCK_TICK_RATE	1193180 /* Underlying HZ */
+/* change this if you have some constant time drift */
+#define USECS_PER_JIFFY	(1000000/HZ)
 
 /* Getting on the cycle counter on sparc64. */
 typedef unsigned long cycles_t;
diff --git a/arch/sparc/kernel/pcic.c b/arch/sparc/kernel/pcic.c
index 09f4fdd..2a62932 100644
--- a/arch/sparc/kernel/pcic.c
+++ b/arch/sparc/kernel/pcic.c
@@ -703,7 +703,6 @@ static void pcic_clear_clock_irq(void)
 }
 
 /* CPU frequency is 100 MHz, timer increments every 4 CPU clocks */
-#define USECS_PER_JIFFY  (1000000 / HZ)
 #define TICK_TIMER_LIMIT ((100 * 1000000 / 4) / HZ)
 
 static unsigned int pcic_cycles_offset(void)
diff --git a/include/linux/timex.h b/include/linux/timex.h
index b3726e6..851dec4 100644
--- a/include/linux/timex.h
+++ b/include/linux/timex.h
@@ -145,4 +145,9 @@ int read_current_timer(unsigned long *timer_val);
 /* The clock frequency of the i8253/i8254 PIT */
 #define PIT_TICK_RATE 1193182ul
 
+#ifndef USECS_PER_JIFFY
+/* change this if you have some constant time drift */
+#define USECS_PER_JIFFY        (1000000/HZ)
+#endif
+
 #endif /* LINUX_TIMEX_H */
-- 
1.8.1.4


