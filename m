Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966180AbaFQVs3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 17:48:29 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53987 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966159AbaFQVs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:48:26 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 114/212] [media] V4L2: ov7670: fix a wrong index, potentially Oopsing the kernel from user-space
Date: Tue, 17 Jun 2014 14:43:28 -0700
Message-Id: <1403041506-13646-115-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/media/i2c/ov7670.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
index e8a1ce2..cdd7c1b 100644
--- a/drivers/media/i2c/ov7670.c
+++ b/drivers/media/i2c/ov7670.c
@@ -1109,7 +1109,7 @@ static int ov7670_enum_framesizes(struct v4l2_subdev *sd,
 	 * windows that fall outside that.
 	 */
 	for (i = 0; i < n_win_sizes; i++) {
-		struct ov7670_win_size *win = &info->devtype->win_sizes[index];
+		struct ov7670_win_size *win = &info->devtype->win_sizes[i];
 		if (info->min_width && win->width < info->min_width)
 			continue;
 		if (info->min_height && win->height < info->min_height)
-- 
1.9.1

