Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751644AbaDOEtm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 00:49:42 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:40587 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbaDOEtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 00:49:40 -0400
From: Daeseok Youn <daeseok.youn@gmail.com>
To: m.chehab@samsung.com
Cc: linux-dev@sensoray.com, hans.verkuil@cisco.com, sakari.ailus@iki.fi,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] s2255drv: fix memory leak s2255_probe()
Date: Tue, 15 Apr 2014 13:49:34 +0900
Message-ID: <1408657.25U3i1DfG3@daeseok-laptop.cloud.net>
User-Agent: KMail/4.8.5 (Linux/3.2.0-58-generic; KDE/4.8.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


smatch says:
 drivers/media/usb/s2255/s2255drv.c:2246 s2255_probe() warn:
possible memory leak of 'dev'

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/media/usb/s2255/s2255drv.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/usb/s2255/s2255drv.c b/drivers/media/usb/s2255/s2255drv.c
index 1d4ba2b..8aca3ef 100644
--- a/drivers/media/usb/s2255/s2255drv.c
+++ b/drivers/media/usb/s2255/s2255drv.c
@@ -2243,6 +2243,7 @@ static int s2255_probe(struct usb_interface *interface,
 	dev->cmdbuf = kzalloc(S2255_CMDBUF_SIZE, GFP_KERNEL);
 	if (dev->cmdbuf == NULL) {
 		s2255_dev_err(&interface->dev, "out of memory\n");
+		kfree(dev);
 		return -ENOMEM;
 	}
 
-- 
1.7.4.4


