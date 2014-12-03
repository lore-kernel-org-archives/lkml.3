Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734AbaLCL1z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 06:27:55 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54700 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752583AbaLCL1l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:27:41 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 073/101] [media] usbvision-video: two use after frees
Date: Wed,  3 Dec 2014 12:26:35 +0100
Message-Id: <214c97a12f1f14260b90eea07444de6aa3b90d27.1417605922.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
References: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
In-Reply-To: <cover.1417605922.git.jslaby@suse.cz>
References: <cover.1417605922.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 470a9147899500eb4898f77816520c4b4aa1a698 upstream.

The lock has been freed in usbvision_release() so there is no need to
call mutex_unlock() here.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/media/usb/usbvision/usbvision-video.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/usb/usbvision/usbvision-video.c b/drivers/media/usb/usbvision/usbvision-video.c
index 5c9e3123ad2e..661f7f2a9e8b 100644
--- a/drivers/media/usb/usbvision/usbvision-video.c
+++ b/drivers/media/usb/usbvision/usbvision-video.c
@@ -446,6 +446,7 @@ static int usbvision_v4l2_close(struct file *file)
 	if (usbvision->remove_pending) {
 		printk(KERN_INFO "%s: Final disconnect\n", __func__);
 		usbvision_release(usbvision);
+		return 0;
 	}
 	mutex_unlock(&usbvision->v4l2_lock);
 
@@ -1221,6 +1222,7 @@ static int usbvision_radio_close(struct file *file)
 	if (usbvision->remove_pending) {
 		printk(KERN_INFO "%s: Final disconnect\n", __func__);
 		usbvision_release(usbvision);
+		return err_code;
 	}
 
 	mutex_unlock(&usbvision->v4l2_lock);
-- 
2.1.3

