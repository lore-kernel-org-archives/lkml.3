Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235Ab3I3KUV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 06:20:21 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43738 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755713Ab3I3KNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 06:13:16 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sachin Kamat <sachin.kamat@linaro.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Kamil Debski <k.debski@samsung.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 077/104] s5p-g2d: Fix registration failure
Date: Mon, 30 Sep 2013 11:10:54 +0100
Message-Id: <1380535881-9239-78-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
References: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.22 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sachin Kamat <sachin.kamat@linaro.org>

commit 8a09a4cc9bd9389dc6a3b5b2dd3a7d64d2fab7e1 upstream.

Commit 1c1d86a1ea ("[media] v4l2: always require v4l2_dev,
rename parent to dev_parent") expects v4l2_dev to be always set.
It converted most of the drivers using the parent field of video_device
to v4l2_dev field. G2D driver did not set the parent field. Hence it got
left out. Without this patch we get the following boot warning and G2D
driver fails to register the video device.
WARNING: CPU: 0 PID: 1 at drivers/media/v4l2-core/v4l2-dev.c:775 __video_register_device+0xfc0/0x1028()
Modules linked in:
CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.11.0-rc1-00001-g1c3e372-dirty #9
[<c0014b7c>] (unwind_backtrace+0x0/0xf4) from [<c0011524>] (show_stack+0x10/0x14)
[<c0011524>] (show_stack+0x10/0x14) from [<c041d7a8>] (dump_stack+0x7c/0xb0)
[<c041d7a8>] (dump_stack+0x7c/0xb0) from [<c001dc94>] (warn_slowpath_common+0x6c/0x88)
[<c001dc94>] (warn_slowpath_common+0x6c/0x88) from [<c001dd4c>] (warn_slowpath_null+0x1c/0x24)
[<c001dd4c>] (warn_slowpath_null+0x1c/0x24) from [<c02cf8d4>] (__video_register_device+0xfc0/0x1028)
[<c02cf8d4>] (__video_register_device+0xfc0/0x1028) from [<c0311a94>] (g2d_probe+0x1f8/0x398)
[<c0311a94>] (g2d_probe+0x1f8/0x398) from [<c0247d54>] (platform_drv_probe+0x14/0x18)
[<c0247d54>] (platform_drv_probe+0x14/0x18) from [<c0246b10>] (driver_probe_device+0x108/0x220)
[<c0246b10>] (driver_probe_device+0x108/0x220) from [<c0246cf8>] (__driver_attach+0x8c/0x90)
[<c0246cf8>] (__driver_attach+0x8c/0x90) from [<c0245050>] (bus_for_each_dev+0x60/0x94)
[<c0245050>] (bus_for_each_dev+0x60/0x94) from [<c02462c8>] (bus_add_driver+0x1c0/0x24c)
[<c02462c8>] (bus_add_driver+0x1c0/0x24c) from [<c02472d0>] (driver_register+0x78/0x140)
[<c02472d0>] (driver_register+0x78/0x140) from [<c00087c8>] (do_one_initcall+0xf8/0x144)
[<c00087c8>] (do_one_initcall+0xf8/0x144) from [<c05b29e8>] (kernel_init_freeable+0x13c/0x1d8)
[<c05b29e8>] (kernel_init_freeable+0x13c/0x1d8) from [<c041a108>] (kernel_init+0xc/0x160)
[<c041a108>] (kernel_init+0xc/0x160) from [<c000e2f8>] (ret_from_fork+0x14/0x3c)
---[ end trace 4e0ec028b0028e02 ]---
s5p-g2d 12800000.g2d: Failed to register video device
s5p-g2d: probe of 12800000.g2d failed with error -22

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Kamil Debski <k.debski@samsung.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/media/video/s5p-g2d/g2d.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/video/s5p-g2d/g2d.c b/drivers/media/video/s5p-g2d/g2d.c
index 7c98ee7..a96d7a2 100644
--- a/drivers/media/video/s5p-g2d/g2d.c
+++ b/drivers/media/video/s5p-g2d/g2d.c
@@ -753,6 +753,7 @@ static int g2d_probe(struct platform_device *pdev)
 	   This driver needs auditing so that this flag can be removed. */
 	set_bit(V4L2_FL_LOCK_ALL_FOPS, &vfd->flags);
 	vfd->lock = &dev->mutex;
+	vfd->v4l2_dev = &dev->v4l2_dev;
 	ret = video_register_device(vfd, VFL_TYPE_GRABBER, 0);
 	if (ret) {
 		v4l2_err(&dev->v4l2_dev, "Failed to register video device\n");
-- 
1.8.3.2

