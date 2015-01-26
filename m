Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579AbbAZNVS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 08:21:18 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:63740 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbbAZNVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 08:21:14 -0500
Date: Mon, 26 Jan 2015 15:21:09 +0200
From: Heba Aamer <heba93aamer@gmail.com>
To: devel@driverdev.osuosl.org
Cc: jarod@wilsonet.com, mchehab@osg.samsung.com, gregkh@linuxfoundation.org,
        tapaswenipathak@gmail.com, tuomas.tynkkynen@iki.fi,
        dan.carpenter@oracle.com, gulsah.1004@gmail.com, himangi774@gmail.com,
        pebolle@tiscali.nl, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: media: lirc: adjust boolean assignments
Message-ID: <20150126132109.GA16448@mohammed-Inspiron-3537>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adjusts boolean assignments from 0/1 to false/true.
And accordingly, it also adjusts the if conditions. 

Signed-off-by: Heba Aamer <heba93aamer@gmail.com>
---
 drivers/staging/media/lirc/lirc_serial.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/media/lirc/lirc_serial.c b/drivers/staging/media/lirc/lirc_serial.c
index eb4ccb8..19628d0 100644
--- a/drivers/staging/media/lirc/lirc_serial.c
+++ b/drivers/staging/media/lirc/lirc_serial.c
@@ -107,7 +107,7 @@ static int io;
 static int irq;
 static bool iommap;
 static int ioshift;
-static bool softcarrier = 1;
+static bool softcarrier = true;
 static bool share_irq;
 static bool debug;
 static int sense = -1;	/* -1 = auto, 0 = active high, 1 = active low */
@@ -266,7 +266,7 @@ static unsigned long space_width;
 /* fetch serial input packet (1 byte) from register offset */
 static u8 sinp(int offset)
 {
-	if (iommap != 0)
+	if (iommap)
 		/* the register is memory-mapped */
 		offset <<= ioshift;
 
@@ -276,7 +276,7 @@ static u8 sinp(int offset)
 /* write serial output packet (1 byte) of value to register offset */
 static void soutp(int offset, u8 value)
 {
-	if (iommap != 0)
+	if (iommap)
 		/* the register is memory-mapped */
 		offset <<= ioshift;
 
@@ -799,10 +799,10 @@ static int lirc_serial_probe(struct platform_device *dev)
 	 * For memory mapped I/O you *might* need to use ioremap() first,
 	 * for the NSLU2 it's done in boot code.
 	 */
-	if (((iommap != 0)
+	if (((iommap)
 	     && (devm_request_mem_region(&dev->dev, iommap, 8 << ioshift,
 					 LIRC_DRIVER_NAME) == NULL))
-	   || ((iommap == 0)
+	   || ((!iommap)
 	       && (devm_request_region(&dev->dev, io, 8,
 				       LIRC_DRIVER_NAME) == NULL))) {
 		dev_err(&dev->dev, "port %04x already in use\n", io);
-- 
1.7.9.5

