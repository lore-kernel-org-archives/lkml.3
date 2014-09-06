Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751691AbaIFMzI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2014 08:55:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58099 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488AbaIFMy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2014 08:54:59 -0400
Date: Sat, 6 Sep 2014 05:54:45 -0700
From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Message-ID: <tip-196cf358422517b3ff3779c46a1f3e26fb084172@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        mark.d.rustad@intel.com, tglx@linutronix.de,
        jeffrey.t.kirsher@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mark.d.rustad@intel.com,
        jeffrey.t.kirsher@intel.com
In-Reply-To: <1409972149-26272-1-git-send-email-jeffrey.t.kirsher@intel.com>
References: <1409972149-26272-1-git-send-email-jeffrey.t.kirsher@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cleanups] x86/tty/serial/8250: Clean up the asm/
 serial.h include file a bit
Git-Commit-ID: 196cf358422517b3ff3779c46a1f3e26fb084172
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  196cf358422517b3ff3779c46a1f3e26fb084172
Gitweb:     http://git.kernel.org/tip/196cf358422517b3ff3779c46a1f3e26fb084172
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Sat, 6 Sep 2014 10:12:19 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 6 Sep 2014 10:20:55 +0200

x86/tty/serial/8250: Clean up the asm/serial.h include file a bit

 - correct spelling
 - align fields vertically to make things more readable
 - make the layout of magic defines more obvious

Cc: Mark Rustad <mark.d.rustad@intel.com>
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Link: http://lkml.kernel.org/r/1409972149-26272-1-git-send-email-jeffrey.t.kirsher@intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/serial.h | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/serial.h b/arch/x86/include/asm/serial.h
index 03ece8e..460b84f 100644
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
-	{ .uart = 0, BASE_BAUD, 0x3F8, 4, STD_COM_FLAGS }, /* ttyS0 */	\
-	{ .uart = 0, BASE_BAUD, 0x2F8, 3, STD_COM_FLAGS }, /* ttyS1 */	\
-	{ .uart = 0, BASE_BAUD, 0x3E8, 4, STD_COM_FLAGS }, /* ttyS2 */	\
-	{ .uart = 0, BASE_BAUD, 0x2E8, 3, STD_COM4_FLAGS }, /* ttyS3 */
+#define SERIAL_PORT_DFNS								\
+	/* UART		CLK		PORT	IRQ	FLAGS			    */	\
+	{ .uart = 0,	BASE_BAUD,	0x3F8,	4,	STD_COMX_FLAGS	}, /* ttyS0 */	\
+	{ .uart = 0,	BASE_BAUD,	0x2F8,	3,	STD_COMX_FLAGS	}, /* ttyS1 */	\
+	{ .uart = 0,	BASE_BAUD,	0x3E8,	4,	STD_COMX_FLAGS	}, /* ttyS2 */	\
+	{ .uart = 0,	BASE_BAUD,	0x2E8,	3,	STD_COM4_FLAGS	}, /* ttyS3 */
 
 #endif /* _ASM_X86_SERIAL_H */
