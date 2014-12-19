Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708AbaLSXvR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 18:51:17 -0500
Received: from resqmta-po-12v.sys.comcast.net ([96.114.154.171]:57209 "EHLO
	resqmta-po-12v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751462AbaLSXvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 18:51:15 -0500
From: Shuah Khan <shuah.kh@samsung.com>
To: m.chehab@samsung.com, hans.verkuil@cisco.com, prabhakar.csengg@gmail.com,
        laurent.pinchart@ideasonboard.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] media: fix au0828_analog_register() to not free au0828_dev
Date: Fri, 19 Dec 2014 16:42:59 -0700
Message-Id: <1419032579-7720-1-git-send-email-shuah.kh@samsung.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shuah Khan <shuahkh@osg.samsung.com>

au0828_analog_register() frees au0828_dev when it fails to
locate isoc endpoint. au0828_usb_probe() continues with dvb
and rc probe and registration assuming dev is still valid.
When au0828_analog_register() fails to locate isoc endpoint,
it should return without free'ing au0828_dev. Otherwise, the
probe will fail as dev is null when au0828_dvb_register() is
called.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/usb/au0828/au0828-video.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index 3bdf132..94b65b8 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -1713,7 +1713,6 @@ int au0828_analog_register(struct au0828_dev *dev,
 	}
 	if (!(dev->isoc_in_endpointaddr)) {
 		pr_info("Could not locate isoc endpoint\n");
-		kfree(dev);
 		return -ENODEV;
 	}
 
-- 
2.1.0

