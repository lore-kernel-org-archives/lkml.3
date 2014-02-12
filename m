Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739AbaBLPq5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 10:46:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46849 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751942AbaBLPqz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 10:46:55 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 4/4] ARM: Delete asm/system.h
From: David Howells <dhowells@redhat.com>
To: akpm@linux-foundation.org
Cc: linux-arch@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        arnd@arndb.de, linux-kernel@vger.kernel.org, dhowells@redhat.com,
        linux-arm-kernel@lists.infradead.org
Date: Wed, 12 Feb 2014 15:46:15 +0000
Message-ID: <20140212154615.2405.88996.stgit@warthog.procyon.org.uk>
In-Reply-To: <20140212154544.2405.2992.stgit@warthog.procyon.org.uk>
References: <20140212154544.2405.2992.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Delete ARM's asm/system.h.  It's the last holdout and should be got rid of.

This builds for defconfig, lpc32xx_defconfig, exynos_defconfig + XEN, the
previous changed to a Gemini system and an omap3 config with TI_DAVINCI_EMAC.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Russell King <linux@arm.linux.org.uk>
cc: linux-arm-kernel@lists.infradead.org
---

 arch/arm/include/asm/jump_label.h  |    1 -
 arch/arm/include/asm/sync_bitops.h |    1 -
 arch/arm/include/asm/system.h      |    7 -------
 arch/arm/mach-gemini/idle.c        |    2 +-
 arch/arm/mach-omap2/am35xx-emac.c  |    1 -
 drivers/usb/gadget/lpc32xx_udc.c   |    1 -
 6 files changed, 1 insertion(+), 12 deletions(-)
 delete mode 100644 arch/arm/include/asm/system.h

diff --git a/arch/arm/include/asm/jump_label.h b/arch/arm/include/asm/jump_label.h
index 863c892..70f9b9b 100644
--- a/arch/arm/include/asm/jump_label.h
+++ b/arch/arm/include/asm/jump_label.h
@@ -4,7 +4,6 @@
 #ifdef __KERNEL__
 
 #include <linux/types.h>
-#include <asm/system.h>
 
 #define JUMP_LABEL_NOP_SIZE 4
 
diff --git a/arch/arm/include/asm/sync_bitops.h b/arch/arm/include/asm/sync_bitops.h
index 63479ee..9732b8e 100644
--- a/arch/arm/include/asm/sync_bitops.h
+++ b/arch/arm/include/asm/sync_bitops.h
@@ -2,7 +2,6 @@
 #define __ASM_SYNC_BITOPS_H__
 
 #include <asm/bitops.h>
-#include <asm/system.h>
 
 /* sync_bitops functions are equivalent to the SMP implementation of the
  * original functions, independently from CONFIG_SMP being defined.
diff --git a/arch/arm/include/asm/system.h b/arch/arm/include/asm/system.h
deleted file mode 100644
index 368165e..0000000
--- a/arch/arm/include/asm/system.h
+++ /dev/null
@@ -1,7 +0,0 @@
-/* FILE TO BE DELETED. DO NOT ADD STUFF HERE! */
-#include <asm/barrier.h>
-#include <asm/compiler.h>
-#include <asm/cmpxchg.h>
-#include <asm/switch_to.h>
-#include <asm/system_info.h>
-#include <asm/system_misc.h>
diff --git a/arch/arm/mach-gemini/idle.c b/arch/arm/mach-gemini/idle.c
index 87dff4f..ddf8ec9 100644
--- a/arch/arm/mach-gemini/idle.c
+++ b/arch/arm/mach-gemini/idle.c
@@ -3,7 +3,7 @@
  */
 
 #include <linux/init.h>
-#include <asm/system.h>
+#include <asm/system_misc.h>
 #include <asm/proc-fns.h>
 
 static void gemini_idle(void)
diff --git a/arch/arm/mach-omap2/am35xx-emac.c b/arch/arm/mach-omap2/am35xx-emac.c
index 25b79a2..6a6935c 100644
--- a/arch/arm/mach-omap2/am35xx-emac.c
+++ b/arch/arm/mach-omap2/am35xx-emac.c
@@ -17,7 +17,6 @@
 
 #include <linux/err.h>
 #include <linux/davinci_emac.h>
-#include <asm/system.h>
 #include "omap_device.h"
 #include "am35xx.h"
 #include "control.h"
diff --git a/drivers/usb/gadget/lpc32xx_udc.c b/drivers/usb/gadget/lpc32xx_udc.c
index 049ebab..a94bb10 100644
--- a/drivers/usb/gadget/lpc32xx_udc.c
+++ b/drivers/usb/gadget/lpc32xx_udc.c
@@ -55,7 +55,6 @@
 #include <mach/hardware.h>
 #include <linux/io.h>
 #include <asm/irq.h>
-#include <asm/system.h>
 
 #include <mach/platform.h>
 #include <mach/irqs.h>

