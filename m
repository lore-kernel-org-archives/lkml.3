Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882AbaFAAJc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 20:09:32 -0400
Received: from mail-qg0-f54.google.com ([209.85.192.54]:53826 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755481AbaFAAJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 20:09:31 -0400
From: James A Shackleford <shack@linux.com>
To: forest@alittletooquiet.net, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: James A Shackleford <shack@linux.com>
Subject: [PATCH] staging: vt6655: fix sparse warning "cast removes address space of expression"
Date: Sat, 31 May 2014 20:09:05 -0400
Message-Id: <1401581345-13564-1-git-send-email-shack@linux.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing __user macro to second parameter of ethtool_ioctl().
This removes the need for the offending (void *) cast of the user space pointer
rq->ifr_data.

Signed-off-by: James A Shackleford <shack@linux.com>
---
 drivers/staging/vt6655/device_main.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 1d3908d..2327386 100644
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
+		return ethtool_ioctl(dev, rq->ifr_data);
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
1.7.9.5

