Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203AbaJMHZU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 03:25:20 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:35516 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372AbaJMHZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 03:25:17 -0400
Date: Mon, 13 Oct 2014 09:25:12 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/cleanups tree changes for v3.18
Message-ID: <20141013072512.GA14178@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-cleanups-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-cleanups-for-linus

   # HEAD: 196cf358422517b3ff3779c46a1f3e26fb084172 x86/tty/serial/8250: Clean up the asm/serial.h include file a bit

Three small cleanups.

 Thanks,

	Ingo

------------------>
Ingo Molnar (1):
      x86/tty/serial/8250: Clean up the asm/serial.h include file a bit

Mark Rustad (1):
      x86/tty/serial/8250: Resolve missing-field-initializers warnings

Ross Zwisler (1):
      x86: Remove obsolete comment in uapi/e820.h


 arch/x86/include/asm/serial.h    | 24 ++++++++++++------------
 arch/x86/include/uapi/asm/e820.h |  5 -----
 2 files changed, 12 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/serial.h b/arch/x86/include/asm/serial.h
index 628c801535ea..460b84f64556 100644
--- a/arch/x86/include/asm/serial.h
+++ b/arch/x86/include/asm/serial.h
@@ -6,24 +6,24 @@
  *
  * It'd be nice if someone built a serial card with a 24.576 MHz
  * clock, since the 16550A is capable of handling a top speed of 1.5
- * megabits/second; but this requires the faster clock.
+ * megabits/second; but this requires a faster clock.
  */
-#define BASE_BAUD ( 1843200 / 16 )
+#define BASE_BAUD (1843200/16)
 
 /* Standard COM flags (except for COM4, because of the 8514 problem) */
 #ifdef CONFIG_SERIAL_DETECT_IRQ
-#define STD_COM_FLAGS (ASYNC_BOOT_AUTOCONF | ASYNC_SKIP_TEST | ASYNC_AUTO_IRQ)
-#define STD_COM4_FLAGS (ASYNC_BOOT_AUTOCONF | ASYNC_AUTO_IRQ)
+# define STD_COMX_FLAGS	(ASYNC_BOOT_AUTOCONF |	ASYNC_SKIP_TEST	| ASYNC_AUTO_IRQ)
+# define STD_COM4_FLAGS	(ASYNC_BOOT_AUTOCONF |	0		| ASYNC_AUTO_IRQ)
 #else
-#define STD_COM_FLAGS (ASYNC_BOOT_AUTOCONF | ASYNC_SKIP_TEST)
-#define STD_COM4_FLAGS ASYNC_BOOT_AUTOCONF
+# define STD_COMX_FLAGS	(ASYNC_BOOT_AUTOCONF |	ASYNC_SKIP_TEST	| 0		)
+# define STD_COM4_FLAGS	(ASYNC_BOOT_AUTOCONF |	0		| 0		)
 #endif
 
-#define SERIAL_PORT_DFNS			\
-	/* UART CLK   PORT IRQ     FLAGS        */			\
-	{ 0, BASE_BAUD, 0x3F8, 4, STD_COM_FLAGS },	/* ttyS0 */	\
-	{ 0, BASE_BAUD, 0x2F8, 3, STD_COM_FLAGS },	/* ttyS1 */	\
-	{ 0, BASE_BAUD, 0x3E8, 4, STD_COM_FLAGS },	/* ttyS2 */	\
-	{ 0, BASE_BAUD, 0x2E8, 3, STD_COM4_FLAGS },	/* ttyS3 */
+#define SERIAL_PORT_DFNS								\
+	/* UART		CLK		PORT	IRQ	FLAGS			    */	\
+	{ .uart = 0,	BASE_BAUD,	0x3F8,	4,	STD_COMX_FLAGS	}, /* ttyS0 */	\
+	{ .uart = 0,	BASE_BAUD,	0x2F8,	3,	STD_COMX_FLAGS	}, /* ttyS1 */	\
+	{ .uart = 0,	BASE_BAUD,	0x3E8,	4,	STD_COMX_FLAGS	}, /* ttyS2 */	\
+	{ .uart = 0,	BASE_BAUD,	0x2E8,	3,	STD_COM4_FLAGS	}, /* ttyS3 */
 
 #endif /* _ASM_X86_SERIAL_H */
diff --git a/arch/x86/include/uapi/asm/e820.h b/arch/x86/include/uapi/asm/e820.h
index bbae02470701..d993e33f5236 100644
--- a/arch/x86/include/uapi/asm/e820.h
+++ b/arch/x86/include/uapi/asm/e820.h
@@ -21,11 +21,6 @@
  * this size.
  */
 
-/*
- * Odd: 'make headers_check' complains about numa.h if I try
- * to collapse the next two #ifdef lines to a single line:
- *	#if defined(__KERNEL__) && defined(CONFIG_EFI)
- */
 #ifndef __KERNEL__
 #define E820_X_MAX E820MAX
 #endif
