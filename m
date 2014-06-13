Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608AbaFMKMf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 06:12:35 -0400
Received: from mx02.posteo.de ([89.146.194.165]:40565 "EHLO posteo.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751300AbaFMKMe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 06:12:34 -0400
From: Martin Kepplinger <martink@posteo.de>
To: gregkh@linuxfoundation.org
Cc: forest@alittletooquiet.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Martin Kepplinger <martink@posteo.de>
Subject: [PATCH] staging: vt6655: preserve address space by not casting
Date: Fri, 13 Jun 2014 12:11:51 +0200
Message-Id: <1402654311-22053-1-git-send-email-martink@posteo.de>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the sparse error: cast removes address space of expression.
---
Is that even correct? I haven't signed-off on it yet.
ethtool_ioctl() takes a (void *) as user data, dereferenced and assigend to u32.
applies to next-20140611

 drivers/staging/vt6655/device_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 1d3908d..15b2ee5 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -3067,7 +3067,7 @@ static int  device_ioctl(struct net_device *dev, struct ifreq *rq, int cmd) {
 		break;
 
 	case SIOCETHTOOL:
-		return ethtool_ioctl(dev, (void *)rq->ifr_data);
+		return ethtool_ioctl(dev, &rq->ifr_data);
 		// All other calls are currently unsupported
 
 	default:
-- 
1.7.10.4

