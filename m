Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758825Ab3IDNj0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 09:39:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45381 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757643Ab3IDNjZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 09:39:25 -0400
Date: Wed, 4 Sep 2013 09:38:50 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Tony Lindgren <tony@atomide.com>, Olof Johansson <olof@lixom.net>
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: ARM: OMAP2: Make MACH_OMAP3EVM select NOP_USB_XCEIV
Message-ID: <20130904133850.GC12834@hansolo.jdub.homelinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The board-omap3evm.c file unconditionally calls usb_nop_xceiv_register but
doesn't ensure this is built-in.  This can lead to build failures like:

arch/arm/mach-omap2/built-in.o: In function `omap3_evm_init':
linux-3.12.0-0.rc0.git2.1.fc21.armv7hl/arch/arm/mach-omap2/board-omap3evm.c:686: undefined reference to `usb_nop_xceiv_register'
make: *** [vmlinux] Error 1

Make MACH_OMAP3EVM select NOP_USB_XCEIV to avoid this.

Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org>
---
 arch/arm/mach-omap2/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
index 3eed000..3350389 100644
--- a/arch/arm/mach-omap2/Kconfig
+++ b/arch/arm/mach-omap2/Kconfig
@@ -258,6 +258,7 @@ config MACH_OMAP3EVM
 	depends on ARCH_OMAP3
 	default y
 	select OMAP_PACKAGE_CBB
+	select NOP_USB_XCEIV
 
 config MACH_OMAP3517EVM
 	bool "OMAP3517/ AM3517 EVM board"
-- 
1.8.3.1

