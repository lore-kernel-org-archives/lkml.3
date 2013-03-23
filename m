Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750876Ab3CWLjJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 07:39:09 -0400
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:61191 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750708Ab3CWLjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 07:39:07 -0400
Message-ID: <1364038742.1390.228.camel@x61.thuisdomein>
Subject: [PATCH] um: remove "config STDIO_CONSOLE"
From: Paul Bolle <pebolle@tiscali.nl>
To: Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>
Cc: user-mode-linux-devel@lists.sourceforge.net,
        user-mode-linux-user@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Date: Sat, 23 Mar 2013 12:39:02 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Mar 2013 11:39:03.0253 (UTC) FILETIME=[04C24050:01CE27BB]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only user of Kconfig symbol STDIO_CONSOLE was removed in v2.5.65.
Its entry can safely be removed.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Untested.

1) A short history of STDIO_CONSOLE and CONFIG_STDIO_CONSOLE

CONFIG_STDIO_CONSOLE was added in v2.4.9 (August 2001). It wrapped a
call of stdio_console_init() in an #ifdef and #endif pair.

The Kconfig symbol STDIO_CONSOLE was added in v2.5.35 (September 2002).
That release also introduced a definition of stdio_console_init().

Both CONFIG_STDIO_CONSOLE and the call of stdio_console_init() that it
guarded were removed in v2.5.65 (March 2003). An instance of the
console_initcall() macro was then added for stdio_console_init.

 arch/um/Kconfig.char | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/um/Kconfig.char b/arch/um/Kconfig.char
index b9d7c42..f10738d 100644
--- a/arch/um/Kconfig.char
+++ b/arch/um/Kconfig.char
@@ -6,10 +6,6 @@ config STDERR_CONSOLE
 	help
 	  console driver which dumps all printk messages to stderr.
 
-config STDIO_CONSOLE
-	bool
-	default y
-
 config SSL
 	bool "Virtual serial line"
 	help
-- 
1.7.11.7

