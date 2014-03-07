Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522AbaCGVAz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 16:00:55 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54928 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197AbaCGVAy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 16:00:54 -0500
Date: Fri, 7 Mar 2014 22:00:51 +0100
From: Jean Delvare <jdelvare@suse.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH] mfd: Fix cs5535 dependencies
Message-ID: <20140307220051.0b004abf@endymion.delvare>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As far as I know, the CS5535 and CS5536 chipsets are companions of the
Geode series of processors, which are 32-bit only. So the CS5535
drivers are not needed on x86-64, except for build testing purpose.

This aligns the dependencies to what FB_GEODE already uses.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-3.14-rc5.orig/drivers/mfd/Kconfig	2014-03-07 21:43:13.739818995 +0100
+++ linux-3.14-rc5/drivers/mfd/Kconfig	2014-03-07 21:43:59.262786389 +0100
@@ -13,7 +13,7 @@ config MFD_CORE
 config MFD_CS5535
 	tristate "AMD CS5535 and CS5536 southbridge core functions"
 	select MFD_CORE
-	depends on PCI && X86
+	depends on PCI && (X86_32 || (X86 && COMPILE_TEST))
 	---help---
 	  This is the core driver for CS5535/CS5536 MFD functions.  This is
           necessary for using the board's GPIO and MFGPT functionality.


-- 
Jean Delvare
SUSE L3 Support
