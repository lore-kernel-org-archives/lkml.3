Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932700AbaFQMdM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 08:33:12 -0400
Received: from mx02.posteo.de ([89.146.194.165]:33078 "EHLO posteo.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932209AbaFQMdL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 08:33:11 -0400
From: Martin Kepplinger <martink@posteo.de>
To: dan.carpenter@oracle.com
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        forest@alittletooquiet.net, linux-kernel@vger.kernel.org,
        Martin Kepplinger <martink@posteo.de>
Subject: [PATCH v2] staging: vt6655: preserve address space in ethtool_ioctl()
Date: Tue, 17 Jun 2014 14:32:35 +0200
Message-Id: <1403008355-4163-1-git-send-email-martink@posteo.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20140616075556.GZ5500@mwanda>
References: <20140616075556.GZ5500@mwanda>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the sparse error: cast removes address space of expression and
add __user annotation to the driver's ethtool_ioctl().

Signed-off-by: Martin Kepplinger <martink@posteo.de>
---
Beyond that, how would you include socket.c's ethtool_ioctl() here?

thanks for looking at these tiny changes.

 drivers/staging/vt6655/device_main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 1d3908d..740690e 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -3067,7 +3067,7 @@ static int  device_ioctl(struct net_device *dev, struct ifreq *rq, int cmd) {
 		break;
 
 	case SIOCETHTOOL:
-		return ethtool_ioctl(dev, (void *)rq->ifr_data);
+		return ethtool_ioctl(dev, &rq->ifr_data);
 		// All other calls are currently unsupported
 
 	default:
@@ -3103,7 +3103,7 @@ static int  device_ioctl(struct net_device *dev, struct ifreq *rq, int cmd) {
 	return rc;
 }
 
-static int ethtool_ioctl(struct net_device *dev, void *useraddr)
+static int ethtool_ioctl(struct net_device *dev, void __user *useraddr)
 {
 	u32 ethcmd;
 
-- 
1.7.10.4

