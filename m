Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933AbaDCJfH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 05:35:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59505 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751489AbaDCJfA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 05:35:00 -0400
Date: Thu, 3 Apr 2014 11:34:57 +0200
From: Jean Delvare <jdelvare@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH] mfd: timberdale: Depend on X86_32
Message-ID: <20140403113457.57f9df81@endymion.delvare>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As far as I know the Timberdale chip was only used as a companion for
Intel Atom E600 series processors. As such, its drivers are only
useful on X86_32.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-3.14.orig/drivers/mfd/Kconfig	2014-04-03 09:16:01.741554631 +0200
+++ linux-3.14/drivers/mfd/Kconfig	2014-04-03 09:57:44.438396779 +0200
@@ -1014,7 +1014,7 @@ config MFD_LM3533
 config MFD_TIMBERDALE
 	tristate "Timberdale FPGA"
 	select MFD_CORE
-	depends on PCI && GPIOLIB
+	depends on PCI && GPIOLIB && (X86_32 || COMPILE_TEST)
 	---help---
 	This is the core driver for the timberdale FPGA. This device is a
 	multifunction device which exposes numerous platform devices.


-- 
Jean Delvare
SUSE L3 Support
