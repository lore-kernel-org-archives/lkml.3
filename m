Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758844AbaGXJr3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 05:47:29 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54738 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932309AbaGXJrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:47:16 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Zhaowei Yuan <zhaowei.yuan@samsung.com>, Dave Airlie <airlied@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 030/128] drm: fix NULL pointer access by wrong ioctl
Date: Thu, 24 Jul 2014 10:44:39 +0100
Message-Id: <1406195177-8656-31-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
References: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhaowei Yuan <zhaowei.yuan@samsung.com>

commit 1539fb9bd405ee32282ea0a38404f9e008ac5b7a upstream.

If user uses wrong ioctl command with _IOC_NONE and argument size
greater than 0, it can cause NULL pointer access from memset of line
463. If _IOC_NONE, don't memset to 0 for kdata.

Signed-off-by: Zhaowei Yuan <zhaowei.yuan@samsung.com>
Reviewed-by: David Herrmann <dh.herrmann@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/drm_drv.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)
 mode change 100644 => 100755 drivers/gpu/drm/drm_drv.c

diff --git a/drivers/gpu/drm/drm_drv.c b/drivers/gpu/drm/drm_drv.c
old mode 100644
new mode 100755
index 6dd71735cab4..d71e1a46c4d4
--- a/drivers/gpu/drm/drm_drv.c
+++ b/drivers/gpu/drm/drm_drv.c
@@ -460,8 +460,9 @@ long drm_ioctl(struct file *filp,
 				retcode = -EFAULT;
 				goto err_i1;
 			}
-		} else
+		} else if (cmd & IOC_OUT) {
 			memset(kdata, 0, usize);
+		}
 
 		if (ioctl->flags & DRM_UNLOCKED)
 			retcode = func(dev, kdata, file_priv);
-- 
1.9.1

