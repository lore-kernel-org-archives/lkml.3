Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913Ab3BDSUP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 13:20:15 -0500
Received: from mail-da0-f48.google.com ([209.85.210.48]:61679 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908Ab3BDSUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 13:20:13 -0500
Date: Mon, 4 Feb 2013 10:20:10 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pekka Enberg <penberg@kernel.org>, Sasha Levin <levinsasha928@gmail.com>
cc: Randy Dunlap <rdunlap@infradead.org>,
        David Woodhouse <dwmw2@infradead.org>, Michal Marek <mmarek@suse.cz>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        tglx@linutronix.de, "H. Peter Anvin" <hpa@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: [patch] config: fix make kvmconfig 
In-Reply-To: <50DB9FA5.6070704@infradead.org>
Message-ID: <alpine.DEB.2.02.1302041002430.6063@chino.kir.corp.google.com>
References: <1356040315.3198.51.camel@shinybook.infradead.org>  <tip-ffee0de411fd4f74f3b788892eeb075abbf26c52@git.kernel.org>  <alpine.DEB.2.00.1212252222450.24528@chino.kir.corp.google.com> <1356564746.7010.56.camel@shinybook.infradead.org>
 <50DB9FA5.6070704@infradead.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

make kvmconfig selects CONFIG_SERIAL_8250 without selecting its 
dependencies causing some configs to fail:

drivers/tty/serial/8250/8250.c:57:32: error: 'CONFIG_SERIAL_8250_RUNTIME_UARTS' undeclared here (not in a function)
drivers/tty/serial/8250/8250.c:2712:47: error: 'CONFIG_SERIAL_8250_NR_UARTS' undeclared here (not in a function)
drivers/tty/serial/8250/8250.c: In function 'serial8250_console_write':
drivers/tty/serial/8250/8250.c:2843:10: error: 'struct uart_port' has no member named 'sysrq'
drivers/tty/serial/8250/8250.c: In function 'early_serial_setup':
drivers/tty/serial/8250/8250.c:2971:20: error: negative width in bit-field '<anonymous>'
drivers/tty/serial/8250/8250.c: At top level:
drivers/tty/serial/8250/8250.c:2712:30: warning: 'serial8250_ports' defined but not used [-Wunused-variable]

Fix this by selecting CONFIG_TTY as well, which CONFIG_SERIAL_8250 
requires.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 Ok, so this patch has been sitting in linux-next for well over a year and
 has had to be fixed several times with follow up commits similar to this.
 Linus hasn't pulled kvmtool, so I'm wondering why we need to keep this
 around in the first place?

 arch/x86/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 6979498..f9459b3 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -606,6 +606,7 @@ config KVMTOOL_TEST_ENABLE
 	select NETWORK_FILESYSTEMS
 	select INET
 	select EXPERIMENTAL
+	select TTY
 	select SERIAL_8250
 	select SERIAL_8250_CONSOLE
 	select IP_PNP
