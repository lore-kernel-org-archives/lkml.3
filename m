Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751594AbaAERva (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 12:51:30 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:47200 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbaAERv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 12:51:27 -0500
From: Guenter Roeck <linux@roeck-us.net>
To: Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Cc: linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH] net: can: Disable broken flexcan driver build for big endian CPU on ARM
Date: Sun,  5 Jan 2014 09:51:23 -0800
Message-Id: <1388944283-29990-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Building arm:allmodconfig fails with

flexcan.c: In function 'flexcan_read':
flexcan.c:243:2: error: implicit declaration of function 'in_be32'
flexcan.c: In function 'flexcan_write':
flexcan.c:248:2: error: implicit declaration of function 'out_be32'

in_be32 and out_be32 do not (or no longer) exist for ARM targets.
Mark the build for arm on big endian CPUs as broken.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
If there is a better solution, please let me know and I'll be happy
to provide a patch.

 drivers/net/can/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/Kconfig b/drivers/net/can/Kconfig
index 3c06947..8d202f4 100644
--- a/drivers/net/can/Kconfig
+++ b/drivers/net/can/Kconfig
@@ -104,7 +104,7 @@ config CAN_JANZ_ICAN3
 
 config CAN_FLEXCAN
 	tristate "Support for Freescale FLEXCAN based chips"
-	depends on ARM || PPC
+	depends on (ARM || PPC) && (BROKEN || !ARM || CPU_LITTLE_ENDIAN)
 	---help---
 	  Say Y here if you want to support for Freescale FlexCAN.
 
-- 
1.7.9.7

