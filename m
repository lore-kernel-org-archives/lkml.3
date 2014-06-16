Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358AbaFPL4G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 07:56:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56974 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282AbaFPL4E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 07:56:04 -0400
Date: Mon, 16 Jun 2014 13:56:01 +0200
From: Jean Delvare <jdelvare@suse.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH RESEND] mfd: timberdale: Depend on X86_32
Message-ID: <20140616135601.5f700de1@endymion.delvare>
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
Patch already sent on: 2014-04-03

 drivers/mfd/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-3.16-rc1.orig/drivers/mfd/Kconfig	2014-06-16 13:00:58.359698968 +0200
+++ linux-3.16-rc1/drivers/mfd/Kconfig	2014-06-16 13:02:12.995215489 +0200
@@ -1055,7 +1055,7 @@ config MFD_LM3533
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
