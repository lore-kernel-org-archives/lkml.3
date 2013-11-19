Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752333Ab3KSTZ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 14:25:58 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:21441 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821Ab3KSTZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 14:25:52 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: plagnioj@jcrosoft.com, tomi.valkeinen@ti.com
Cc: gregkh@linuxfoundation.org, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] video: kyro: fix incorrect sizes when copying to userspace
Date: Tue, 19 Nov 2013 14:25:36 -0500
Message-Id: <1384889136-15516-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.1.2
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kyro would copy u32s and specify sizeof(unsigned long) as the size to copy.

This would copy more data than intended and cause memory corruption and might
leak kernel memory.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 drivers/video/kyro/fbdev.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/video/kyro/fbdev.c b/drivers/video/kyro/fbdev.c
index 50c8574..65041e1 100644
--- a/drivers/video/kyro/fbdev.c
+++ b/drivers/video/kyro/fbdev.c
@@ -624,15 +624,15 @@ static int kyrofb_ioctl(struct fb_info *info,
 			return -EINVAL;
 		}
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
1.7.10.4

