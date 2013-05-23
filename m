Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757926Ab3EWJ2h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 05:28:37 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:38220 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757494Ab3EWJ2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 05:28:35 -0400
MIME-Version: 1.0
Date: Thu, 23 May 2013 17:28:34 +0800
Message-ID: <CAPgLHd_2hpq1ZNz-kEeSJ3Dbp+myB5hV9fEvFk-9sFNVim6voQ@mail.gmail.com>
Subject: [PATCH -next] staging: keucr: remove needless check before usb_free_coherent()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: acho@novell.com, gregkh@linuxfoundation.org, amarjargal16@gmail.com,
        shifty91@gmail.com, dan.carpenter@oracle.com,
        katrina.prosise@gmail.com
Cc: yongjun_wei@trendmicro.com.cn, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

usb_free_coherent() is safe with NULL addr and this check is
not required.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/staging/keucr/usb.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/keucr/usb.c b/drivers/staging/keucr/usb.c
index efadfcf..0608a5c 100644
--- a/drivers/staging/keucr/usb.c
+++ b/drivers/staging/keucr/usb.c
@@ -442,12 +442,9 @@ static void dissociate_dev(struct us_data *us)
 	kfree(us->sensebuf);
 
 	/* Free the device-related DMA-mapped buffers */
-	if (us->cr)
-		usb_free_coherent(us->pusb_dev, sizeof(*us->cr), us->cr,
-								us->cr_dma);
-	if (us->iobuf)
-		usb_free_coherent(us->pusb_dev, US_IOBUF_SIZE, us->iobuf,
-								us->iobuf_dma);
+	usb_free_coherent(us->pusb_dev, sizeof(*us->cr), us->cr, us->cr_dma);
+	usb_free_coherent(us->pusb_dev, US_IOBUF_SIZE, us->iobuf,
+			  us->iobuf_dma);
 
 	/* Remove our private data from the interface */
 	usb_set_intfdata(us->pusb_intf, NULL);

