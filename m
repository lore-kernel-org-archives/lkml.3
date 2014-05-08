Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755971AbaEHW5x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 18:57:53 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:41294 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755733AbaEHW5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 18:57:52 -0400
Date: Fri, 9 May 2014 07:57:18 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: m.chehab@samsung.com
Cc: sakari.ailus@iki.fi, linux-dev@sensoray.com, hans.verkuil@cisco.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] s2255drv: fix memory leak s2255_probe()
Message-ID: <20140508225718.GA24276@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

smatch says:
 drivers/media/usb/s2255/s2255drv.c:2246 s2255_probe() warn:
possible memory leak of 'dev'

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
V2: use the same pattern for error handling.

 drivers/media/usb/s2255/s2255drv.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/usb/s2255/s2255drv.c b/drivers/media/usb/s2255/s2255drv.c
index 1d4ba2b..3193474 100644
--- a/drivers/media/usb/s2255/s2255drv.c
+++ b/drivers/media/usb/s2255/s2255drv.c
@@ -2243,7 +2243,7 @@ static int s2255_probe(struct usb_interface *interface,
 	dev->cmdbuf = kzalloc(S2255_CMDBUF_SIZE, GFP_KERNEL);
 	if (dev->cmdbuf == NULL) {
 		s2255_dev_err(&interface->dev, "out of memory\n");
-		return -ENOMEM;
+		goto errorFWDATA1;
 	}
 
 	atomic_set(&dev->num_channels, 0);
-- 
1.7.1

