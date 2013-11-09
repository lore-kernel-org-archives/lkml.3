Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216Ab3KIEOA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 23:14:00 -0500
Received: from top.free-electrons.com ([176.31.233.9]:58012 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751069Ab3KIEN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 23:13:59 -0500
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: harshavardhan.r.kharche@intel.com, ashutosh.dixit@intel.com,
        gregkh@linuxfoundation.org, nikhil.rao@intel.com,
        sudeep.dutt@intel.com
Cc: linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] misc: mic: dead code removal and minor cleanup
Date: Sat,  9 Nov 2013 05:13:42 +0100
Message-Id: <1383970422-16973-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes the below test in drivers/misc/mic/card/mic_virtio.c:

if (!retry) {
...
}

This is dead code because the "retry" variable was set to 100
earlier in the same function.

This also removes dev_dbg statements to print the value of this variable.
That's not interesting to print the value of a variable which value is
always the same.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 drivers/misc/mic/card/mic_virtio.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/misc/mic/card/mic_virtio.c b/drivers/misc/mic/card/mic_virtio.c
index 914cc9b2caad..0f387504b3fa 100644
--- a/drivers/misc/mic/card/mic_virtio.c
+++ b/drivers/misc/mic/card/mic_virtio.c
@@ -167,8 +167,6 @@ static void mic_reset_inform_host(struct virtio_device *vdev)
 		msleep(100);
 	};
 
-	dev_dbg(mic_dev(mvdev), "%s: retry: %d\n", __func__, retry);
-
 	/* Reset status to 0 in case we timed out */
 	iowrite8(0, &mvdev->desc->status);
 }
@@ -337,12 +335,6 @@ static int mic_find_vqs(struct virtio_device *vdev, unsigned nvqs,
 		msleep(100);
 	};
 
-	dev_dbg(mic_dev(mvdev), "%s: retry: %d\n", __func__, retry);
-	if (!retry) {
-		err = -ENODEV;
-		goto error;
-	}
-
 	return 0;
 error:
 	mic_del_vqs(vdev);
-- 
1.8.1.2

