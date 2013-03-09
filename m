Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993Ab3CIWQs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 17:16:48 -0500
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:50609 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751279Ab3CIWQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 17:16:47 -0500
Message-ID: <1362867404.3137.44.camel@x61.thuisdomein>
Subject: [PATCH] tty: serial: fix typo "ARCH_S5P6450"
From: Paul Bolle <pebolle@tiscali.nl>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Ben Dooks <ben-linux@fluff.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sat, 09 Mar 2013 23:16:44 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Mar 2013 22:16:45.0257 (UTC) FILETIME=[C8E83B90:01CE1D13]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This could have been either ARCH_S5P64X0 or CPU_S5P6450. Looking at
commit 2555e663b367b8d555e76023f4de3f6338c28d6c ("ARM: S5P64X0: Add UART
serial support for S5P6450") - which added this typo - makes clear this
should be CPU_S5P6450.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Bravely untested.

 drivers/tty/serial/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
index cf9210d..40ddbe4 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -218,7 +218,7 @@ config SERIAL_SAMSUNG_UARTS_4
 config SERIAL_SAMSUNG_UARTS
 	int
 	depends on PLAT_SAMSUNG
-	default 6 if ARCH_S5P6450
+	default 6 if CPU_S5P6450
 	default 4 if SERIAL_SAMSUNG_UARTS_4 || CPU_S3C2416
 	default 3
 	help
-- 
1.7.11.7

