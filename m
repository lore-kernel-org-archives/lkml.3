Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932400Ab3CLJKk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 05:10:40 -0400
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:56758 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932122Ab3CLJKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 05:10:38 -0400
Message-ID: <1363079432.3137.139.camel@x61.thuisdomein>
Subject: [PATCH] tty: serial: fix typo "SERIAL_S3C2412"
From: Paul Bolle <pebolle@tiscali.nl>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: Ben Dooks <ben-linux@fluff.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 12 Mar 2013 10:10:32 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Mar 2013 09:10:32.0451 (UTC) FILETIME=[72F68530:01CE1F01]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kconfig symbol SERIAL_S3C2412 got removed in commit
da121506eb03ee5daea55404709110b798bd61d9 ("serial: samsung: merge
probe() function from all SoC specific extensions"). But it also added a
last reference to that symbol. The commit and the tree make clear that
CPU_S3C2412 should have been used instead.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) The net effect of this is that the number of uarts of the S3C2412 CPU
drops from 4 to 3. So this needs testing (by people with access to that
hardware).

1) Related note: a few lines down there's the line
    default 4 if SERIAL_SAMSUNG_UARTS_4 || CPU_S3C2416

The "|| CPU_S3C2416" part looks superfluous.

 drivers/tty/serial/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
index 40ddbe4..7e7006f 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -211,7 +211,7 @@ config SERIAL_SAMSUNG
 config SERIAL_SAMSUNG_UARTS_4
 	bool
 	depends on PLAT_SAMSUNG
-	default y if !(CPU_S3C2410 || SERIAL_S3C2412 || CPU_S3C2440 || CPU_S3C2442)
+	default y if !(CPU_S3C2410 || CPU_S3C2412 || CPU_S3C2440 || CPU_S3C2442)
 	help
 	  Internal node for the common case of 4 Samsung compatible UARTs
 
-- 
1.7.11.7

