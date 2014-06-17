Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932889AbaFQMlI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 08:41:08 -0400
Received: from mx02.posteo.de ([89.146.194.165]:45037 "EHLO posteo.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932555AbaFQMlH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 08:41:07 -0400
From: Martin Kepplinger <martink@posteo.de>
To: dan.carpenter@oracle.com
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        forest@alittletooquiet.net, linux-kernel@vger.kernel.org,
        Martin Kepplinger <martink@posteo.de>
Subject: [PATCH v3] staging: vt6655: preserve address space in ethtool_ioctl()
Date: Tue, 17 Jun 2014 14:40:27 +0200
Message-Id: <1403008827-6098-1-git-send-email-martink@posteo.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403008355-4163-1-git-send-email-martink@posteo.de>
References: <1403008355-4163-1-git-send-email-martink@posteo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the sparse error: cast removes address space of expression and
add __user annotation to the driver's ethtool_ioctl().

Signed-off-by: Martin Kepplinger <martink@posteo.de>
---
I think I forgot to change the declaration on top.

 drivers/staging/vt6655/device_main.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 1d3908d..81c9932 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -302,7 +302,7 @@ static int  device_dma0_tx_80211(struct sk_buff *skb, struct net_device *dev);
 //2008-0714<Add>by Mike Liu
 static bool device_release_WPADEV(PSDevice pDevice);
 
-static int  ethtool_ioctl(struct net_device *dev, void *useraddr);
+static int  ethtool_ioctl(struct net_device *dev, void __user *useraddr);
 static int  device_rx_srv(PSDevice pDevice, unsigned int uIdx);
 static int  device_tx_srv(PSDevice pDevice, unsigned int uIdx);
 static bool device_alloc_rx_buf(PSDevice pDevice, PSRxDesc pDesc);
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

