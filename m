Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756415AbaGIOYs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 10:24:48 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:14385 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755890AbaGIOYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 10:24:47 -0400
From: Richard Weinberger <richard@nod.at>
To: kys@microsoft.com, haiyangz@microsoft.com
Cc: sergei.shtylyov@cogentembedded.com, romieu@fr.zoreil.com,
        devel@linuxdriverproject.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>
Subject: [PATCH v3] hyperv: Add netpoll support
Date: Wed,  9 Jul 2014 16:23:59 +0200
Message-Id: <1404915839-15940-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 2.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to have at least a netconsole to debug kernel issues on
Windows Azure this patch implements netpoll support.
Sending packets is easy, netvsc_start_xmit() does already everything
needed.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/net/hyperv/netvsc_drv.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 4fd71b7..fcf3be7 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -736,6 +736,14 @@ static int netvsc_set_mac_addr(struct net_device *ndev, void *p)
 	return err;
 }
 
+#ifdef CONFIG_NET_POLL_CONTROLLER
+static void netvsc_poll_controller(struct net_device *net)
+{
+	/* As netvsc_start_xmit() works synchronous we don't have to
+	 * trigger anything here.
+	 */
+}
+#endif
 
 static const struct ethtool_ops ethtool_ops = {
 	.get_drvinfo	= netvsc_get_drvinfo,
@@ -751,6 +759,9 @@ static const struct net_device_ops device_ops = {
 	.ndo_validate_addr =		eth_validate_addr,
 	.ndo_set_mac_address =		netvsc_set_mac_addr,
 	.ndo_select_queue =		netvsc_select_queue,
+#ifdef CONFIG_NET_POLL_CONTROLLER
+	.ndo_poll_controller =		netvsc_poll_controller,
+#endif
 };
 
 /*
-- 
2.0.1

