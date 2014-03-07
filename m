Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751757AbaCGI0A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 03:26:00 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:32990 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbaCGIZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 03:25:59 -0500
From: Daeseok Youn <daeseok.youn@gmail.com>
To: gregkh@linuxfoundation.org
Cc: d@teklibre.com, paul.gortmaker@windriver.com, sara.bird.iar@gmail.com,
        dan.carpenter@oracle.com, standby24x7@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] staging: frontier: fix memory leak in usb_alphatrack_probe()
Date: Fri, 07 Mar 2014 17:25:55 +0900
Message-ID: <1569666.TNMhHTO1Tb@daeseok-laptop.cloud.net>
User-Agent: KMail/4.8.5 (Linux/3.2.0-58-generic; KDE/4.8.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


oldi_buffer and write_buffer need to free when usb_alphatrack_delete()
is called.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
v2: remove the unneeded comment.

 drivers/staging/frontier/alphatrack.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/frontier/alphatrack.c b/drivers/staging/frontier/alphatrack.c
index edd5cef..e59ee51 100644
--- a/drivers/staging/frontier/alphatrack.c
+++ b/drivers/staging/frontier/alphatrack.c
@@ -208,7 +208,9 @@ static void usb_alphatrack_delete(struct usb_alphatrack *dev)
 	kfree(dev->ring_buffer);
 	kfree(dev->interrupt_in_buffer);
 	kfree(dev->interrupt_out_buffer);
-	kfree(dev);		/* fixme oldi_buffer */
+	kfree(dev->oldi_buffer);
+	kfree(dev->write_buffer);
+	kfree(dev);
 }
 
 /** usb_alphatrack_interrupt_in_callback */
-- 
1.7.4.4


