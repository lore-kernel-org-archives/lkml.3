Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757309Ab3A1Q2y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 11:28:54 -0500
Received: from casper.infradead.org ([85.118.1.10]:52419 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755879Ab3A1Q2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 11:28:50 -0500
Message-ID: <5106A77C.2050400@infradead.org>
Date: Mon, 28 Jan 2013 08:29:48 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130105 Thunderbird/17.0.2
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Dajun Chen <dchen@diasemi.com>, Wim Van Sebroeck <wim@iguana.be>,
        linux-watchdog@vger.kernel.org
Subject: [PATCH] watchdog: da9055_wdt needs to select WATCHDOG_CORE
References: <20130129000610.22f0ebd13431c59c5dc8cf3d@canb.auug.org.au>
In-Reply-To: <20130129000610.22f0ebd13431c59c5dc8cf3d@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

DA9055_WATCHDOG needs to select WATCHDOG_CORE so that it will
build cleanly.  Fixes these build errors:

da9055_wdt.c:(.text+0xe9bc7): undefined reference to `watchdog_unregister_device'
da9055_wdt.c:(.text+0xe9f4b): undefined reference to `watchdog_register_device'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: David Dajun Chen <dchen@diasemi.com>
Cc: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-watchdog@vger.kernel.org
---
 drivers/watchdog/Kconfig |    1 +
 1 file changed, 1 insertion(+)

Found in linux-next, but also applies to mainline.

--- linux-next-20130128.orig/drivers/watchdog/Kconfig
+++ linux-next-20130128/drivers/watchdog/Kconfig
@@ -79,6 +79,7 @@ config DA9052_WATCHDOG
 config DA9055_WATCHDOG
 	tristate "Dialog Semiconductor DA9055 Watchdog"
 	depends on MFD_DA9055
+	select WATCHDOG_CORE
 	help
 	  If you say yes here you get support for watchdog on the Dialog
 	  Semiconductor DA9055 PMIC.
