Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292Ab3AZNfo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 08:35:44 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:59951 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754127Ab3AZNfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 08:35:41 -0500
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Holler <holler@ahsoftware.de>
Subject: [PATCH 2/3] Show option to not include kernel configuration only for embedded systems
Date: Sat, 26 Jan 2013 14:34:27 +0100
Message-Id: <1359207268-9340-3-git-send-email-holler@ahsoftware.de>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1359207268-9340-1-git-send-email-holler@ahsoftware.de>
References: <1359207268-9340-1-git-send-email-holler@ahsoftware.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The included kernel configuration only consumes a few kb. In order to
prevent premature optimization, show the the option for not including
the kernel configuration only for embedded systems.

Signed-off-by: Alexander Holler <holler@ahsoftware.de>
---
 init/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index ccf43c6..0b01c41 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -679,7 +679,7 @@ config RCU_NOCB_CPU
 endmenu # "RCU Subsystem"
 
 config IKCONFIG
-	tristate "Kernel .config support"
+	tristate "Kernel .config support" if EMBEDDED
 	default y
 	---help---
 	  This option enables the complete Linux kernel ".config" file
@@ -692,7 +692,7 @@ config IKCONFIG
 	  /proc/config.gz if enabled (below).
 
 config IKCONFIG_PROC
-	bool "Enable access to .config through /proc/config.gz"
+	bool "Enable access to .config through /proc/config.gz" if EMBEDDED
 	default y
 	depends on IKCONFIG && PROC_FS
 	---help---
-- 
1.7.11.7

