Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798AbaBRNuh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 08:50:37 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:48414 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755675AbaBRNuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 08:50:09 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s1IDo77j029728, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next 14/14] r8152: support get_msglevel and set_msglevel
Date: Tue, 18 Feb 2014 21:49:11 +0800
Message-ID: <1392731351-25502-15-git-send-email-hayeswang@realtek.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1392731351-25502-1-git-send-email-hayeswang@realtek.com>
References: <1392731351-25502-1-git-send-email-hayeswang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.218]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support get_msglevel and set_msglevel.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index db98842..0654bd3 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -2852,6 +2852,20 @@ out_set_wol:
 	return ret;
 }
 
+static u32 rtl8152_get_msglevel(struct net_device *dev)
+{
+	struct r8152 *tp = netdev_priv(dev);
+
+	return tp->msg_enable;
+}
+
+static void rtl8152_set_msglevel(struct net_device *dev, u32 value)
+{
+	struct r8152 *tp = netdev_priv(dev);
+
+	tp->msg_enable = value;
+}
+
 static void rtl8152_get_drvinfo(struct net_device *netdev,
 				struct ethtool_drvinfo *info)
 {
@@ -2895,6 +2909,8 @@ static struct ethtool_ops ops = {
 	.get_settings = rtl8152_get_settings,
 	.set_settings = rtl8152_set_settings,
 	.get_link = ethtool_op_get_link,
+	.get_msglevel = rtl8152_get_msglevel,
+	.set_msglevel = rtl8152_set_msglevel,
 	.get_wol = rtl8152_get_wol,
 	.set_wol = rtl8152_set_wol,
 };
-- 
1.8.4.2

