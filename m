Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292AbaFIJ0T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 05:26:19 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59137 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754214AbaFIJ0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 05:26:16 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 141/146] media: V4L2: ov7670: fix a wrong index, potentially Oopsing the kernel from user-space
Date: Mon,  9 Jun 2014 10:51:16 +0200
Message-Id: <34aa3f6facb425326c5e197d0945518e2ab9e405.1402303821.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/media/i2c/ov7670.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
index e8a1ce204036..cdd7c1b7259b 100644
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
1.9.3

