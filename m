Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751481AbaBHIu7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 03:50:59 -0500
Received: from ns1.pc-advies.be ([83.149.101.17]:56536 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751386AbaBHIu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 03:50:56 -0500
Date: Sat, 8 Feb 2014 09:50:53 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Richard Weinberger <richard@nod.at>
Subject: [GIT PULL REQUEST] watchdog - Fixes for v3.14-rc2
Message-ID: <20140208085053.GA1484@spo001.leaseweb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'master' branch of
	git://www.linux-watchdog.org/linux-watchdog.git

It will fix the HAS_IOMEM dependency for dw_wdt.

This will update the following files:

 Kconfig |    1 +
 1 files changed, 1 insertion(+)

with these Changes:

commit 1ccfe6f982674e4b7bd832b904bafcb3db890252
Author: Richard Weinberger <richard@nod.at>
Date:   Fri Jan 31 13:47:34 2014 +0100

    watchdog: dw_wdt: Add dependency on HAS_IOMEM
    
    On archs like S390 or um this driver cannot build nor work.
    Make it depend on HAS_IOMEM to bypass build failures.
    
    drivers/built-in.o: In function `dw_wdt_drv_probe':
    drivers/watchdog/dw_wdt.c:302: undefined reference to `devm_ioremap_resource'
    
    Signed-off-by: Richard Weinberger <richard@nod.at>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 4c4c566..79d2589 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -223,6 +223,7 @@ config SA1100_WATCHDOG
 
 config DW_WATCHDOG
 	tristate "Synopsys DesignWare watchdog"
+	depends on HAS_IOMEM
 	help
 	  Say Y here if to include support for the Synopsys DesignWare
 	  watchdog timer found in many chips.
