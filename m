Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161127Ab3LFVxG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 16:53:06 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60645 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759140Ab3LFVw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:52:59 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sasha Levin <sasha.levin@oracle.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: [PATCH 3.12 66/83] video: kyro: fix incorrect sizes when copying to userspace
Date: Fri,  6 Dec 2013 13:51:56 -0800
Message-Id: <20131206214646.187900466@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.67.gb00d244
In-Reply-To: <20131206214640.002320724@linuxfoundation.org>
References: <20131206214640.002320724@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sasha Levin <sasha.levin@oracle.com>

commit 2ab68ec927310dc488f3403bb48f9e4ad00a9491 upstream.

kyro would copy u32s and specify sizeof(unsigned long) as the size to copy.

This would copy more data than intended and cause memory corruption and might
leak kernel memory.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/video/kyro/fbdev.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/video/kyro/fbdev.c
+++ b/drivers/video/kyro/fbdev.c
@@ -625,15 +625,15 @@ static int kyrofb_ioctl(struct fb_info *
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


