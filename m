Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757725Ab3HMGqY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 02:46:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60658 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757028Ab3HMGdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 02:33:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Tony Lindgren <tony@atomide.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Afzal Mohammed <afzal@ti.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [ 59/60] mtd: omap2: allow bulding as a module
Date: Mon, 12 Aug 2013 23:34:26 -0700
Message-Id: <20130813063339.101984865@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
In-Reply-To: <20130813063331.950321483@linuxfoundation.org>
References: <20130813063331.950321483@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

commit 930d800bded771b26d9944c47810829130ff7c8c upstream.

The omap2 nand device driver calls into the the elm code, which can
be a loadable module, and in that case it cannot be built-in itself.
I can see no reason why the omap2 driver cannot also be a module,
so let's make the option "tristate" in Kconfig to fix this allmodconfig
build error:

ERROR: "elm_config" [drivers/mtd/nand/omap2.ko] undefined!
ERROR: "elm_decode_bch_error_page" [drivers/mtd/nand/omap2.ko] undefined!

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Tony Lindgren <tony@atomide.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: Afzal Mohammed <afzal@ti.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/nand/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mtd/nand/Kconfig
+++ b/drivers/mtd/nand/Kconfig
@@ -95,7 +95,7 @@ config MTD_NAND_OMAP2
 
 config MTD_NAND_OMAP_BCH
 	depends on MTD_NAND && MTD_NAND_OMAP2 && ARCH_OMAP3
-	bool "Enable support for hardware BCH error correction"
+	tristate "Enable support for hardware BCH error correction"
 	default n
 	select BCH
 	select BCH_CONST_PARAMS


