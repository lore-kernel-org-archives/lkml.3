Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756915AbaFXUxl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 16:53:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47578 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985AbaFXUag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 16:30:36 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 17/65] [media] V4L2: ov7670: fix a wrong index, potentially Oopsing the kernel from user-space
Date: Tue, 24 Jun 2014 13:29:37 -0700
Message-Id: <1403641825-12825-18-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403641825-12825-1-git-send-email-kamal@canonical.com>
References: <1403641825-12825-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.25 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

commit cfece5857ca51d1dcdb157017aba226f594e9dcf upstream.

Commit 75e2bdad8901a0b599e01a96229be922eef1e488 "ov7670: allow
configuration of image size, clock speed, and I/O method" uses a wrong
index to iterate an array. Apart from being wrong, it also uses an
unchecked value from user-space, which can cause access to unmapped
memory in the kernel, triggered by a normal desktop user with rights to
use V4L2 devices.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Acked-by: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
[ kamal: backport to 3.8-stable: context ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/media/i2c/ov7670.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
index e7c82b2..8b272e8 100644
--- a/drivers/media/i2c/ov7670.c
+++ b/drivers/media/i2c/ov7670.c
@@ -937,7 +937,7 @@ static int ov7670_enum_framesizes(struct v4l2_subdev *sd,
 	 * windows that fall outside that.
 	 */
 	for (i = 0; i < N_WIN_SIZES; i++) {
-		struct ov7670_win_size *win = &ov7670_win_sizes[index];
+		struct ov7670_win_size *win = &ov7670_win_sizes[i];
 		if (info->min_width && win->width < info->min_width)
 			continue;
 		if (info->min_height && win->height < info->min_height)
-- 
1.9.1

