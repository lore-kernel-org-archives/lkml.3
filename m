Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108Ab3LQSc2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 13:32:28 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:60968 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755739Ab3LQSO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 13:14:57 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sasha Levin <sasha.levin@oracle.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 053/103] video: kyro: fix incorrect sizes when copying to userspace
Date: Tue, 17 Dec 2013 18:12:42 +0000
Message-Id: <1387304012-23805-54-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387304012-23805-1-git-send-email-luis.henriques@canonical.com>
References: <1387304012-23805-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.28 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sasha Levin <sasha.levin@oracle.com>

commit 2ab68ec927310dc488f3403bb48f9e4ad00a9491 upstream.

kyro would copy u32s and specify sizeof(unsigned long) as the size to copy.

This would copy more data than intended and cause memory corruption and might
leak kernel memory.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/video/kyro/fbdev.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/video/kyro/fbdev.c b/drivers/video/kyro/fbdev.c
index acb9370..7aa8668 100644
--- a/drivers/video/kyro/fbdev.c
+++ b/drivers/video/kyro/fbdev.c
@@ -625,15 +625,15 @@ static int kyrofb_ioctl(struct fb_info *info,
 		}
 		break;
 	case KYRO_IOCTL_UVSTRIDE:
-		if (copy_to_user(argp, &deviceInfo.ulOverlayUVStride, sizeof(unsigned long)))
+		if (copy_to_user(argp, &deviceInfo.ulOverlayUVStride, sizeof(deviceInfo.ulOverlayUVStride)))
 			return -EFAULT;
 		break;
 	case KYRO_IOCTL_STRIDE:
-		if (copy_to_user(argp, &deviceInfo.ulOverlayStride, sizeof(unsigned long)))
+		if (copy_to_user(argp, &deviceInfo.ulOverlayStride, sizeof(deviceInfo.ulOverlayStride)))
 			return -EFAULT;
 		break;
 	case KYRO_IOCTL_OVERLAY_OFFSET:
-		if (copy_to_user(argp, &deviceInfo.ulOverlayOffset, sizeof(unsigned long)))
+		if (copy_to_user(argp, &deviceInfo.ulOverlayOffset, sizeof(deviceInfo.ulOverlayOffset)))
 			return -EFAULT;
 		break;
 	}
-- 
1.8.3.2

