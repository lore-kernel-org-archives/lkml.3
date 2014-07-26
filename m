Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170AbaGZAHx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 20:07:53 -0400
Received: from casper.infradead.org ([85.118.1.10]:49709 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbaGZAHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 20:07:52 -0400
Message-ID: <53D2F153.1080305@infradead.org>
Date: Fri, 25 Jul 2014 17:07:47 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Salter <msalter@redhat.com>, Ingo Molnar <mingo@redhat.com>
Subject: [PATCH] parport: fix menu breakage
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Fixes: d90c3eb31535 "Kconfig cleanup (PARPORT_PC dependencies)"

Do not split the PARPORT-related symbols with the new kconfig
symbol ARCH_MIGHT_HAVE_PC_PARPORT. The split was causing incorrect
display of these symbols -- they were not being displayed together
as they should be.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Mark Salter <msalter@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: stable@vger.kernel.org # for 3.13, 3.14, 3.15
---
 drivers/parport/Kconfig |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

Index: lnx-316-rc6/drivers/parport/Kconfig
===================================================================
--- lnx-316-rc6.orig/drivers/parport/Kconfig
+++ lnx-316-rc6/drivers/parport/Kconfig
@@ -5,6 +5,12 @@
 # Parport configuration.
 #
 
+config ARCH_MIGHT_HAVE_PC_PARPORT
+	bool
+	help
+	  Select this config option from the architecture Kconfig if
+	  the architecture might have PC parallel port hardware.
+
 menuconfig PARPORT
 	tristate "Parallel port support"
 	depends on HAS_IOMEM
@@ -31,12 +37,6 @@ menuconfig PARPORT
 
 	  If unsure, say Y.
 
-config ARCH_MIGHT_HAVE_PC_PARPORT
-	bool
-	help
-	  Select this config option from the architecture Kconfig if
-	  the architecture might have PC parallel port hardware.
-
 if PARPORT
 
 config PARPORT_PC
