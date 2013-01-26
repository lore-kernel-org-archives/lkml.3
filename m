Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202Ab3AZNfa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 08:35:30 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:59927 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038Ab3AZNf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 08:35:27 -0500
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Holler <holler@ahsoftware.de>
Subject: [PATCH 1/3] Include kernel config by default
Date: Sat, 26 Jan 2013 14:34:26 +0100
Message-Id: <1359207268-9340-2-git-send-email-holler@ahsoftware.de>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1359207268-9340-1-git-send-email-holler@ahsoftware.de>
References: <1359207268-9340-1-git-send-email-holler@ahsoftware.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The configuration used to build a kernel (.config) is an import part of
the kernel because it defines many aspects how the kernel handles all kind
of stuff.
Without knowing the used configuration, it is almost impossible
to diagnose problems or to determine how many functionalities are handled
by the kernel.

Therefor include the used configuration by default (e.g. to
extract it using scripts/extract-ikconfig) and make it available through
/proc/config.gz.

Signed-off-by: Alexander Holler <holler@ahsoftware.de>
---
 init/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/init/Kconfig b/init/Kconfig
index be8b7f5..ccf43c6 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -680,6 +680,7 @@ endmenu # "RCU Subsystem"
 
 config IKCONFIG
 	tristate "Kernel .config support"
+	default y
 	---help---
 	  This option enables the complete Linux kernel ".config" file
 	  contents to be saved in the kernel. It provides documentation
@@ -692,6 +693,7 @@ config IKCONFIG
 
 config IKCONFIG_PROC
 	bool "Enable access to .config through /proc/config.gz"
+	default y
 	depends on IKCONFIG && PROC_FS
 	---help---
 	  This option enables access to the kernel configuration file
-- 
1.7.11.7

