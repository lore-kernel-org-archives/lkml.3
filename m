Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868Ab3K0DqA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 22:46:00 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:58590 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810Ab3K0Dp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 22:45:57 -0500
Message-ID: <52956B78.6050107@gmail.com>
Date: Wed, 27 Nov 2013 11:48:08 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: hans.verkuil@cisco.com, m.chehab@samsung.com, rkuo <rkuo@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, linux-media@vger.kernel.org,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Subject: [PATCH v2] drivers: staging: media: go7007: go7007-usb.c use pr_*()
 instead of dev_*() before 'go' initialized in go7007_usb_probe()
References: <528AEFB7.4060301@gmail.com>  <20131125011938.GB18921@codeaurora.org> <5292B845.3010404@gmail.com>  <5292B8A0.7020409@gmail.com> <5294255E.7040105@gmail.com>  <52956442.50001@gmail.com> <1385522475.18487.34.camel@joe-AO722> <529569A5.1020008@gmail.com>
In-Reply-To: <529569A5.1020008@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dev_*() assumes 'go' is already initialized, so need use pr_*() instead
of before 'go' initialized. Related warning (with allmodconfig under
hexagon):

    CC [M]  drivers/staging/media/go7007/go7007-usb.o
  drivers/staging/media/go7007/go7007-usb.c: In function 'go7007_usb_probe':
  drivers/staging/media/go7007/go7007-usb.c:1060:2: warning: 'go' may be used uninitialized in this function [-Wuninitialized]

Also remove useless code after 'return' statement.


Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 drivers/staging/media/go7007/go7007-usb.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/media/go7007/go7007-usb.c b/drivers/staging/media/go7007/go7007-usb.c
index 58684da..2423643 100644
--- a/drivers/staging/media/go7007/go7007-usb.c
+++ b/drivers/staging/media/go7007/go7007-usb.c
@@ -1057,7 +1057,7 @@ static int go7007_usb_probe(struct usb_interface *intf,
 	char *name;
 	int video_pipe, i, v_urb_len;
 
-	dev_dbg(go->dev, "probing new GO7007 USB board\n");
+	pr_debug("probing new GO7007 USB board\n");
 
 	switch (id->driver_info) {
 	case GO7007_BOARDID_MATRIX_II:
@@ -1097,13 +1097,10 @@ static int go7007_usb_probe(struct usb_interface *intf,
 		board = &board_px_tv402u;
 		break;
 	case GO7007_BOARDID_LIFEVIEW_LR192:
-		dev_err(go->dev, "The Lifeview TV Walker Ultra is not supported. Sorry!\n");
+		pr_err("The Lifeview TV Walker Ultra is not supported. Sorry!\n");
 		return -ENODEV;
-		name = "Lifeview TV Walker Ultra";
-		board = &board_lifeview_lr192;
-		break;
 	case GO7007_BOARDID_SENSORAY_2250:
-		dev_info(go->dev, "Sensoray 2250 found\n");
+		pr_info("Sensoray 2250 found\n");
 		name = "Sensoray 2250/2251";
 		board = &board_sensoray_2250;
 		break;
@@ -1112,7 +1109,7 @@ static int go7007_usb_probe(struct usb_interface *intf,
 		board = &board_ads_usbav_709;
 		break;
 	default:
-		dev_err(go->dev, "unknown board ID %d!\n",
+		pr_err("unknown board ID %d!\n",
 				(unsigned int)id->driver_info);
 		return -ENODEV;
 	}
-- 
1.7.7.6
