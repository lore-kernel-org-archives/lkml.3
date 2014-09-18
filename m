Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932716AbaIRScd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 14:32:33 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:57365 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932682AbaIRSca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 14:32:30 -0400
Message-ID: <1411065148.2017.74.camel@x220>
Subject: [PATCH 2/5] MN10300: Remove Kconfig symbols depending on GDBSTUB
From: Paul Bolle <pebolle@tiscali.nl>
To: David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Cc: Richard Weinberger <richard@nod.at>,
        Geert Uytterhoeven <geert@linux-m68k.org>, linux-am33-list@redhat.com,
        linux-kernel@vger.kernel.org
Date: Thu, 18 Sep 2014 20:32:28 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Sep 2014 18:32:28.0734 (UTC) FILETIME=[E6B245E0:01CFD36E]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kconfig symbol GDBSTUB was removed. Remove all symbols (indirectly)
depending on it. And remove it as an (optional) dependency for the
symbol KERNEL_DEBUGGER.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 arch/mn10300/Kconfig.debug | 105 +--------------------------------------------
 1 file changed, 1 insertion(+), 104 deletions(-)

diff --git a/arch/mn10300/Kconfig.debug b/arch/mn10300/Kconfig.debug
index 6a8c7e8d6156..a1acb29f6b2a 100644
--- a/arch/mn10300/Kconfig.debug
+++ b/arch/mn10300/Kconfig.debug
@@ -30,111 +30,8 @@ config KPROBES
 	  for kernel debugging, non-intrusive instrumentation and testing.
 	  If in doubt, say "N".
 
-config GDBSTUB_IMMEDIATE
-	bool "Break into GDB stub immediately"
-	depends on GDBSTUB
-	help
-	  If you say Y here, GDB stub will break into the program as soon as
-	  possible, leaving the program counter at the beginning of
-	  start_kernel() in init/main.c.
-
-config GDBSTUB_ALLOW_SINGLE_STEP
-	bool "Allow software single-stepping in GDB stub"
-	depends on GDBSTUB && !SMP && !PREEMPT
-	help
-	  Allow GDB stub to perform software single-stepping through the
-	  kernel.  This doesn't work very well on SMP or preemptible kernels as
-	  it uses temporary breakpoints to emulate single-stepping.
-
-config GDB_CONSOLE
-	bool "Console output to GDB"
-	depends on GDBSTUB
-	help
-	  If you are using GDB for remote debugging over a serial port and
-	  would like kernel messages to be formatted into GDB $O packets so
-	  that GDB prints them as program output, say 'Y'.
-
-config GDBSTUB_DEBUGGING
-	bool "Debug GDB stub by messages to serial port"
-	depends on GDBSTUB
-	help
-	  This causes debugging messages to be displayed at various points
-	  during execution of the GDB stub routines. Such messages will be
-	  displayed on ttyS0 if that isn't the GDB stub's port, or ttySM0
-	  otherwise.
-
-config GDBSTUB_DEBUG_ENTRY
-	bool "Debug GDB stub entry"
-	depends on GDBSTUB_DEBUGGING
-	help
-	  This option causes information to be displayed about entry to or exit
-	  from the main GDB stub routine.
-
-config GDBSTUB_DEBUG_PROTOCOL
-	bool "Debug GDB stub protocol"
-	depends on GDBSTUB_DEBUGGING
-	help
-	  This option causes information to be displayed about the GDB remote
-	  protocol messages generated exchanged with GDB.
-
-config GDBSTUB_DEBUG_IO
-	bool "Debug GDB stub I/O"
-	depends on GDBSTUB_DEBUGGING
-	help
-	  This option causes information to be displayed about GDB stub's
-	  low-level I/O.
-
-config GDBSTUB_DEBUG_BREAKPOINT
-	bool "Debug GDB stub breakpoint management"
-	depends on GDBSTUB_DEBUGGING
-	help
-	  This option causes information to be displayed about GDB stub's
-	  breakpoint management.
-
-choice
-	prompt "GDB stub port"
-	default GDBSTUB_ON_TTYSM0
-	depends on GDBSTUB
-	help
-	  Select the serial port used for GDB-stub.
-
-config GDBSTUB_ON_TTYSM0
-	bool "/dev/ttySM0 [SIF0]"
-	depends on MN10300_TTYSM0
-	select GDBSTUB_ON_TTYSMx
-
-config GDBSTUB_ON_TTYSM1
-	bool "/dev/ttySM1 [SIF1]"
-	depends on MN10300_TTYSM1
-	select GDBSTUB_ON_TTYSMx
-
-config GDBSTUB_ON_TTYSM2
-	bool "/dev/ttySM2 [SIF2]"
-	depends on MN10300_TTYSM2
-	select GDBSTUB_ON_TTYSMx
-
-config GDBSTUB_ON_TTYS0
-	bool "/dev/ttyS0"
-	select GDBSTUB_ON_TTYSx
-
-config GDBSTUB_ON_TTYS1
-	bool "/dev/ttyS1"
-	select GDBSTUB_ON_TTYSx
-
-endchoice
-
-config GDBSTUB_ON_TTYSMx
-	bool
-	depends on GDBSTUB_ON_TTYSM0 || GDBSTUB_ON_TTYSM1 || GDBSTUB_ON_TTYSM2
-	default y
-
-config GDBSTUB_ON_TTYSx
-	bool
-	depends on GDBSTUB_ON_TTYS0 || GDBSTUB_ON_TTYS1
-	default y
-
 endmenu
 
 config KERNEL_DEBUGGER
 	def_bool y
-	depends on GDBSTUB || KGDB
+	depends on KGDB
-- 
1.9.3

