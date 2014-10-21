Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129AbaJUDvG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 23:51:06 -0400
Received: from smtprelay0205.hostedemail.com ([216.40.44.205]:36828 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751490AbaJUDvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 23:51:04 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3353:3865:3867:3871:3872:4321:5007:6261:9592:10004:10400:10848:11026:11232:11473:11658:11914:12043:12296:12438:12517:12519:12555:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: key94_432e9f4318f01
X-Filterd-Recvd-Size: 2797
Message-ID: <1413863460.5407.10.camel@perches.com>
Subject: [PATCH] usb: storage: Convert usb_stor_dbg to return void
From: Joe Perches <joe@perches.com>
To: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        usb-storage@lists.one-eyed-alien.net, linux-kernel@vger.kernel.org
Date: Mon, 20 Oct 2014 20:51:00 -0700
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No caller or macro uses the return value so make it void.

Signed-off-by: Joe Perches <joe@perches.com>
---
This change is associated to a desire to eventually
change printk to return void.

 drivers/usb/storage/debug.c |  7 ++-----
 drivers/usb/storage/debug.h | 10 ++++++----
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/usb/storage/debug.c b/drivers/usb/storage/debug.c
index e08f647..05bc379 100644
--- a/drivers/usb/storage/debug.c
+++ b/drivers/usb/storage/debug.c
@@ -179,17 +179,14 @@ void usb_stor_show_sense(const struct us_data *us,
 	US_DEBUGPX("\n");
 }
 
-int usb_stor_dbg(const struct us_data *us, const char *fmt, ...)
+void usb_stor_dbg(const struct us_data *us, const char *fmt, ...)
 {
 	va_list args;
-	int r;
 
 	va_start(args, fmt);
 
-	r = dev_vprintk_emit(7, &us->pusb_dev->dev, fmt, args);
+	dev_vprintk_emit(7, &us->pusb_dev->dev, fmt, args);
 
 	va_end(args);
-
-	return r;
 }
 EXPORT_SYMBOL_GPL(usb_stor_dbg);
diff --git a/drivers/usb/storage/debug.h b/drivers/usb/storage/debug.h
index b1273f0..f525203 100644
--- a/drivers/usb/storage/debug.h
+++ b/drivers/usb/storage/debug.h
@@ -50,15 +50,17 @@
 void usb_stor_show_command(const struct us_data *us, struct scsi_cmnd *srb);
 void usb_stor_show_sense(const struct us_data *us, unsigned char key,
 			 unsigned char asc, unsigned char ascq);
-__printf(2, 3) int usb_stor_dbg(const struct us_data *us,
-				const char *fmt, ...);
+__printf(2, 3) void usb_stor_dbg(const struct us_data *us,
+				 const char *fmt, ...);
 
 #define US_DEBUGPX(fmt, ...)	printk(fmt, ##__VA_ARGS__)
 #define US_DEBUG(x)		x
 #else
 __printf(2, 3)
-static inline int _usb_stor_dbg(const struct us_data *us,
-				const char *fmt, ...) {return 1;}
+static inline void _usb_stor_dbg(const struct us_data *us,
+				 const char *fmt, ...)
+{
+}
 #define usb_stor_dbg(us, fmt, ...)				\
 	do { if (0) _usb_stor_dbg(us, fmt, ##__VA_ARGS__); } while (0)
 #define US_DEBUGPX(fmt, ...)					\


