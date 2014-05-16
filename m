Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756742AbaEPJQ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 05:16:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35363 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756582AbaEPJQ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 05:16:57 -0400
Date: Fri, 16 May 2014 11:16:54 +0200
From: Jean Delvare <jdelvare@suse.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] misc: pch_phub: Fix Kconfig dependencies
Message-ID: <20140516111654.337383e1@endymion.delvare>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean Delvare <jdelvare@suse.de>
Subject: misc: pch_phub: Fix Kconfig dependencies

The pch_phub driver is for a companion chip to the Intel Atom E600
series processors. These are 32-bit x86 processors so the driver is
only needed on X86_32. Add COMPILE_TEST as an alternative, so that the
driver can still be build-tested elsewhere.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-3.15-rc5.orig/drivers/misc/Kconfig	2014-05-12 10:47:15.238037771 +0200
+++ linux-3.15-rc5/drivers/misc/Kconfig	2014-05-16 11:13:34.784779488 +0200
@@ -468,7 +468,7 @@ config BMP085_SPI
 config PCH_PHUB
 	tristate "Intel EG20T PCH/LAPIS Semicon IOH(ML7213/ML7223/ML7831) PHUB"
 	select GENERIC_NET_UTILS
-	depends on PCI
+	depends on PCI && (X86_32 || COMPILE_TEST)
 	help
 	  This driver is for PCH(Platform controller Hub) PHUB(Packet Hub) of
 	  Intel Topcliff which is an IOH(Input/Output Hub) for x86 embedded


-- 
Jean Delvare
SUSE L3 Support
