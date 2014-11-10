Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677AbaKJUYr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 15:24:47 -0500
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:51094 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751685AbaKJUXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 15:23:07 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtsNAMAdYVRXQ4qy/2dsb2JhbABcgw6BLbgoBQF0miwCgScXAQEBAQF9hAMBBScvIxBROR4ZiEUBuH2EH49/AQEBByKGOopbBxaENQWeJZZgg3s8L4JLAQEB
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Joe Perches <joe@perches.com>, Jens Axboe <axboe@kernel.dk>,
        Fabian Frederick <fabf@skynet.be>
Subject: [PATCH v2 05/10 linux-next] cdrom: remove bool comparison/assignment to 0/1
Date: Mon, 10 Nov 2014 21:21:50 +0100
Message-Id: <1415650916-9975-6-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415650916-9975-1-git-send-email-fabf@skynet.be>
References: <1415650916-9975-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following coccinelle warnings:

drivers/cdrom/cdrom.c:615:5-14: WARNING: Comparison of bool to 0/1
drivers/cdrom/cdrom.c:617:5-14: WARNING: Comparison of bool to 0/1
drivers/cdrom/cdrom.c:619:5-13: WARNING: Comparison of bool to 0/1
drivers/cdrom/cdrom.c:621:5-21: WARNING: Comparison of bool to 0/1
drivers/cdrom/cdrom.c:317:28-33: WARNING: Comparison of bool to 0/1
drivers/cdrom/cdrom.c:323:33-38: WARNING: Comparison of bool to 0/1
drivers/cdrom/cdrom.c:289:12-21: WARNING: Assignment of bool to 0/1
drivers/cdrom/cdrom.c:291:12-20: WARNING: Assignment of bool to 0/1
drivers/cdrom/cdrom.c:295:12-30: WARNING: Assignment of bool to 0/1

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/cdrom/cdrom.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index ca47919..a4dd382 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -286,13 +286,13 @@
 /* used to tell the module to turn on full debugging messages */
 static bool debug;
 /* default compatibility mode */
-static bool autoclose = 1;
+static bool autoclose = true;
 static bool autoeject;
-static bool lockdoor = 1;
+static bool lockdoor = true;
 /* will we ever get to use this... sigh. */
 static bool check_media_type;
 /* automatically restart mrw format */
-static bool mrw_format_restart = 1;
+static bool mrw_format_restart = true;
 module_param(debug, bool, 0);
 module_param(autoclose, bool, 0);
 module_param(autoeject, bool, 0);
@@ -314,13 +314,13 @@ static const char * const mrw_address_space[] = { "DMA", "GAA" };
 #if (ERRLOGMASK != CD_NOTHING)
 #define cd_dbg(type, fmt, ...)				\
 do {							\
-	if ((ERRLOGMASK & type) || debug == 1)		\
+	if ((ERRLOGMASK & type) || debug)		\
 		pr_debug(fmt, ##__VA_ARGS__);		\
 } while (0)
 #else
 #define cd_dbg(type, fmt, ...)				\
 do {							\
-	if (0 && (ERRLOGMASK & type) || debug == 1)	\
+	if (0 && (ERRLOGMASK & type) || debug)		\
 		pr_debug(fmt, ##__VA_ARGS__);		\
 } while (0)
 #endif
@@ -612,13 +612,13 @@ int register_cdrom(struct cdrom_device_info *cdi)
 	cdo->n_minors = 0;
 	cdi->options = CDO_USE_FFLAGS;
 
-	if (autoclose == 1 && CDROM_CAN(CDC_CLOSE_TRAY))
+	if (autoclose && CDROM_CAN(CDC_CLOSE_TRAY))
 		cdi->options |= (int) CDO_AUTO_CLOSE;
-	if (autoeject == 1 && CDROM_CAN(CDC_OPEN_TRAY))
+	if (autoeject && CDROM_CAN(CDC_OPEN_TRAY))
 		cdi->options |= (int) CDO_AUTO_EJECT;
-	if (lockdoor == 1)
+	if (lockdoor)
 		cdi->options |= (int) CDO_LOCK;
-	if (check_media_type == 1)
+	if (check_media_type)
 		cdi->options |= (int) CDO_CHECK_TYPE;
 
 	if (CDROM_CAN(CDC_MRW_W))
-- 
1.9.1

