Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757333AbaEQNQp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 09:16:45 -0400
Received: from mx02.posteo.de ([89.146.194.165]:35647 "EHLO posteo.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755991AbaEQNQn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 09:16:43 -0400
From: Martin Kepplinger <martink@posteo.de>
To: gregkh@linuxfoundation.org
Cc: m.chehab@samsung.com, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Martin Kepplinger <martink@posteo.de>
Subject: [PATCH] staging: media: as102: replace custom dprintk() with dev_dbg()
Date: Sat, 17 May 2014 15:16:31 +0200
Message-Id: <1400332591-27528-1-git-send-email-martink@posteo.de>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

don't reinvent dev_dbg(). use the common kernel coding style.

Signed-off-by: Martin Kepplinger <martink@posteo.de>
---
this applies to next-20140516.

 drivers/staging/media/as102/as102_drv.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/as102/as102_drv.c b/drivers/staging/media/as102/as102_drv.c
index 09d64cd..99c3ed93 100644
--- a/drivers/staging/media/as102/as102_drv.c
+++ b/drivers/staging/media/as102/as102_drv.c
@@ -74,7 +74,8 @@ static void as102_stop_stream(struct as102_dev_t *dev)
 			return;
 
 		if (as10x_cmd_stop_streaming(bus_adap) < 0)
-			dprintk(debug, "as10x_cmd_stop_streaming failed\n");
+			dev_dbg(&dev->bus_adap.usb_dev->dev,
+				"as10x_cmd_stop_streaming failed\n");
 
 		mutex_unlock(&dev->bus_adap.lock);
 	}
@@ -112,14 +113,16 @@ static int as10x_pid_filter(struct as102_dev_t *dev,
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
@@ -131,7 +134,7 @@ static int as10x_pid_filter(struct as102_dev_t *dev,
 		filter.pid = pid;
 
 		ret = as10x_cmd_add_PID_filter(bus_adap, &filter);
-		dprintk(debug,
+		dev_dbg(&dev->bus_adap.usb_dev->dev,
 			"ADD_PID_FILTER([%02d -> %02d], 0x%04x) ret = %d\n",
 			index, filter.idx, filter.pid, ret);
 		break;
-- 
1.7.10.4

