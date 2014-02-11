Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048AbaBKUHl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 15:07:41 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40063 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753605AbaBKTGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:06:52 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Ricardo Ribalda <ricardo.ribalda@gmail.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH 3.12 062/107] media: media: v4l2-dev: fix video device index assignment
Date: Tue, 11 Feb 2014 11:05:28 -0800
Message-Id: <20140211184749.965299805@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140211184748.191276235@linuxfoundation.org>
References: <20140211184748.191276235@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Szyprowski <m.szyprowski@samsung.com>

commit 6c3df5da67f1f53df78c7e20cd53a481dc28eade upstream.

The side effect of commit 1056e4388b045 ("v4l2-dev: Fix race condition on
__video_register_device") is the increased number of index value assigned
on video_device registration. Before that commit video_devices were
numbered from 0, after it, the indexes starts from 1, because get_index()
always count the device, which is being registered. Some device drivers
rely on video_device index number for internal purposes, i.e. s5p-mfc
driver stopped working after that patch. This patch restores the old method
of numbering the video_device indexes.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Ricardo Ribalda <ricardo.ribalda@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/v4l2-core/v4l2-dev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/v4l2-core/v4l2-dev.c
+++ b/drivers/media/v4l2-core/v4l2-dev.c
@@ -872,8 +872,8 @@ int __video_register_device(struct video
 
 	/* Should not happen since we thought this minor was free */
 	WARN_ON(video_device[vdev->minor] != NULL);
-	video_device[vdev->minor] = vdev;
 	vdev->index = get_index(vdev);
+	video_device[vdev->minor] = vdev;
 	mutex_unlock(&videodev_lock);
 
 	if (vdev->ioctl_ops)


