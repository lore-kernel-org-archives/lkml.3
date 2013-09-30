Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563Ab3I3BbO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 21:31:14 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37532 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753213Ab3I3BbM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 21:31:12 -0400
Message-ID: <1380504668.14493.22.camel@deadeye.wl.decadent.org.uk>
Subject: [PATCH] sysrq: Allow access to sensitive keys to be restricted by
 default
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: Bastian Blank <waldi@debian.org>, LKML <linux-kernel@vger.kernel.org>
Date: Mon, 30 Sep 2013 02:31:08 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.8.5-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bastian Blank <waldi@debian.org>

Add a Kconfig variable to set the initial value of the Magic SysRq mask
(sysctl: kernel.sysrq).

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
This has been in Debian for a while, but should probably be signed-off
by Bastian as well.

Debian sets this to 0x01b6, which excludes.

          8 - enable debugging dumps of processes etc.
         64 - enable signalling of processes (term, kill, oom-kill)

Ben.

--- a/include/linux/sysrq.h
+++ b/include/linux/sysrq.h
@@ -18,7 +18,7 @@
 #include <linux/types.h>
 
 /* Enable/disable SYSRQ support by default (0==no, 1==yes). */
-#define SYSRQ_DEFAULT_ENABLE	1
+#define SYSRQ_DEFAULT_ENABLE	CONFIG_MAGIC_SYSRQ_DEFAULT_MASK
 
 /* Possible values of bitmask for enabling sysrq functions */
 /* 0x0001 is reserved for enable everything */
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -312,6 +312,14 @@ config MAGIC_SYSRQ
 	  keys are documented in <file:Documentation/sysrq.txt>. Don't say Y
 	  unless you really know what this hack does.
 
+config MAGIC_SYSRQ_DEFAULT_MASK
+	hex "Default mask for Magic SysRq keys on the console"
+	depends on MAGIC_SYSRQ
+	default 1
+	help
+	  Specifies the default mask for the allowed SysRq keys.  This can be
+	  used to disable several sensitive keys by default.
+
 config DEBUG_KERNEL
 	bool "Kernel debugging"
 	help

-- 
Ben Hutchings
Life is like a sewer:
what you get out of it depends on what you put into it.
