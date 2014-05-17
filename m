Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932558AbaEQQFx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 12:05:53 -0400
Received: from mx02.posteo.de ([89.146.194.165]:55019 "EHLO posteo.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932115AbaEQQFw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 12:05:52 -0400
From: Martin Kepplinger <martink@posteo.de>
To: gregkh@linuxfoundation.org, crope@iki.fi
Cc: m.chehab@samsung.com, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Martin Kepplinger <martink@posteo.de>
Subject: [PATCHv2] staging: media: as102: replace custom dprintk() with dev_dbg()
Date: Sat, 17 May 2014 18:05:38 +0200
Message-Id: <1400342738-32652-1-git-send-email-martink@posteo.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <53776B57.5050504@iki.fi>
References: <53776B57.5050504@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

don't reinvent dev_dbg(). remove dprintk() in as102_drv.c.
use the common kernel coding style.

Signed-off-by: Martin Kepplinger <martink@posteo.de>
---
this applies to next-20140516. any more suggestions?
more cleanup can be done when dprintk() is completely gone.

 drivers/staging/media/as102/as102_drv.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/media/as102/as102_drv.c b/drivers/staging/media/as102/as102_drv.c
index 09d64cd..e0ee618 100644
--- a/drivers/staging/media/as102/as102_drv.c
+++ b/drivers/staging/media/as102/as102_drv.c
@@ -31,10 +31,6 @@
 #include "as102_fw.h"
 #include "dvbdev.h"
 
-int as102_debug;
-module_param_named(debug, as102_debug, int, 0644);
-MODULE_PARM_DESC(debug, "Turn on/off debugging (default: off)");
-
 int dual_tuner;
 module_param_named(dual_tuner, dual_tuner, int, 0644);
 MODULE_PARM_DESC(dual_tuner, "Activate Dual-Tuner config (default: off)");
@@ -74,7 +70,8 @@ static void as102_stop_stream(struct as102_dev_t *dev)
 			return;
 
 		if (as10x_cmd_stop_streaming(bus_adap) < 0)
-			dprintk(debug, "as10x_cmd_stop_streaming failed\n");
+			dev_dbg(&dev->bus_adap.usb_dev->dev,
+				"as10x_cmd_stop_streaming failed\n");
 
 		mutex_unlock(&dev->bus_adap.lock);
 	}
@@ -112,14 +109,16 @@ static int as10x_pid_filter(struct as102_dev_t *dev,
 	int ret = -EFAULT;
 
 	if (mutex_lock_interruptible(&dev->bus_adap.lock)) {
-		dprintk(debug, "mutex_lock_interruptible(lock) failed !\n");
+		dev_dbg(&dev->bus_adap.usb_dev->dev,
+			"amutex_lock_interruptible(lock) failed !\n");
 		return -EBUSY;
 	}
 
 	switch (onoff) {
 	case 0:
 		ret = as10x_cmd_del_PID_filter(bus_adap, (uint16_t) pid);
-		dprintk(debug, "DEL_PID_FILTER([%02d] 0x%04x) ret = %d\n",
+		dev_dbg(&dev->bus_adap.usb_dev->dev,
+			"DEL_PID_FILTER([%02d] 0x%04x) ret = %d\n",
 			index, pid, ret);
 		break;
 	case 1:
@@ -131,7 +130,7 @@ static int as10x_pid_filter(struct as102_dev_t *dev,
 		filter.pid = pid;
 
 		ret = as10x_cmd_add_PID_filter(bus_adap, &filter);
-		dprintk(debug,
+		dev_dbg(&dev->bus_adap.usb_dev->dev,
 			"ADD_PID_FILTER([%02d -> %02d], 0x%04x) ret = %d\n",
 			index, filter.idx, filter.pid, ret);
 		break;
-- 
1.7.10.4

