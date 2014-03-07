Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751487AbaCGICb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 03:02:31 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:47899 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbaCGICa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 03:02:30 -0500
From: Daeseok Youn <daeseok.youn@gmail.com>
To: gregkh@linuxfoundation.org
Cc: d@teklibre.com, paul.gortmaker@windriver.com, sara.bird.iar@gmail.com,
        dan.carpenter@oracle.com, standby24x7@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: frontier: fix memory leak in usb_alphatrack_probe()
Date: Fri, 07 Mar 2014 17:02:25 +0900
Message-ID: <2118769.zIlmIgrC0S@daeseok-laptop.cloud.net>
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
 drivers/staging/frontier/alphatrack.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/frontier/alphatrack.c b/drivers/staging/frontier/alphatrack.c
index edd5cef..4d630da 100644
--- a/drivers/staging/frontier/alphatrack.c
+++ b/drivers/staging/frontier/alphatrack.c
@@ -208,6 +208,8 @@ static void usb_alphatrack_delete(struct usb_alphatrack *dev)
 	kfree(dev->ring_buffer);
 	kfree(dev->interrupt_in_buffer);
 	kfree(dev->interrupt_out_buffer);
+	kfree(dev->oldi_buffer);
+	kfree(dev->write_buffer);
 	kfree(dev);		/* fixme oldi_buffer */
 }
 
-- 
1.7.4.4


