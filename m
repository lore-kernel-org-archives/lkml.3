Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142AbaHTI7p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 04:59:45 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:34238 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208AbaHTI7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 04:59:23 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s7K8xJE5002813, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next 2/4] r8152: replace strncpy with strlcpy
Date: Wed, 20 Aug 2014 16:58:37 +0800
Message-ID: <1394712342-15778-18-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <1394712342-15778-16-Taiwan-albertk@realtek.com>
References: <1394712342-15778-16-Taiwan-albertk@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.44]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the strncpy with strlcpy, and use sizeof to determine the
length.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 2470d9c..33dcc97 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -3151,8 +3151,8 @@ static void rtl8152_get_drvinfo(struct net_device *netdev,
 {
 	struct r8152 *tp = netdev_priv(netdev);
 
-	strncpy(info->driver, MODULENAME, ETHTOOL_BUSINFO_LEN);
-	strncpy(info->version, DRIVER_VERSION, ETHTOOL_BUSINFO_LEN);
+	strlcpy(info->driver, MODULENAME, sizeof(info->driver));
+	strlcpy(info->version, DRIVER_VERSION, sizeof(info->version));
 	usb_make_path(tp->udev, info->bus_info, sizeof(info->bus_info));
 }
 
-- 
1.9.3

