Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934963Ab3GSAxY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 20:53:24 -0400
Received: from p01c11o148.mxlogic.net ([208.65.144.71]:40222 "EHLO
	p01c11o148.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933632Ab3GSAxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 20:53:22 -0400
X-Greylist: delayed 450 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Jul 2013 20:53:22 EDT
X-MXL-Hash: 51e88e0232586da4-b00cdbaa93b05583faf43d82bd373b6ffa7d1808
X-MXL-Hash: 51e88c445501f058-337b0cb1edd8affe17924beb2014ced418e7d296
From: Amit Uttamchandani <auttamchandani@logicube.com>
To: Francois Romieu <romieu@fr.zoreil.com>, netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Amit Uttamchandani <auttamchandani@logicube.com>
Subject: [PATCH 1/1] net/velocity: add poll controller function for velocity nic
Date: Thu, 18 Jul 2013 17:45:22 -0700
Message-Id: <1374194722-6051-1-git-send-email-auttamchandani@logicube.com>
X-Mailer: git-send-email 1.8.0.rc0
X-OriginalArrivalTime: 19 Jul 2013 00:44:01.0546 (UTC) FILETIME=[0FDC2EA0:01CE8419]
X-AnalysisOut: [v=2.0 cv=HamjuF48 c=1 sm=1 a=0uUgrnGYR7mgTYOISY3a5A==:17 a]
X-AnalysisOut: [=Uue4Aaq5qpMA:10 a=odQdQWa4cxwA:10 a=BLceEmwcHowA:10 a=zin]
X-AnalysisOut: [YphYSAAAA:8 a=TZWQCrQRazAA:10 a=hUnu6iea5als1xh4zjEA:9 a=Z]
X-AnalysisOut: [aEPcxSHRvoA:10]
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010122901)]
X-MAIL-FROM: <auttamchandani@logicube.com>
X-SOURCE-IP: [209.239.228.35]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add poll controller function for velocity nic.

Signed-off-by: Amit Uttamchandani <auttamchandani@logicube.com>
---
 drivers/net/ethernet/via/via-velocity.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/net/ethernet/via/via-velocity.c b/drivers/net/ethernet/via/via-velocity.c
index 1d6dc41..ef77631 100644
--- a/drivers/net/ethernet/via/via-velocity.c
+++ b/drivers/net/ethernet/via/via-velocity.c
@@ -2376,6 +2376,23 @@ out_0:
 	return ret;
 }
 
+#ifdef CONFIG_NET_POLL_CONTROLLER
+/**
+ *  velocity_poll_controller		-	Velocity Poll controller function
+ *  @dev: network device
+ *
+ *
+ *  Used by NETCONSOLE and other diagnostic tools to allow network I/P
+ *  with interrupts disabled.
+ */
+static void velocity_poll_controller(struct net_device *dev)
+{
+	disable_irq(dev->irq);
+	velocity_intr(dev->irq, dev);
+	enable_irq(dev->irq);
+}
+#endif
+
 /**
  *	velocity_mii_ioctl		-	MII ioctl handler
  *	@dev: network device
@@ -2641,6 +2658,9 @@ static const struct net_device_ops velocity_netdev_ops = {
 	.ndo_do_ioctl		= velocity_ioctl,
 	.ndo_vlan_rx_add_vid	= velocity_vlan_rx_add_vid,
 	.ndo_vlan_rx_kill_vid	= velocity_vlan_rx_kill_vid,
+#ifdef CONFIG_NET_POLL_CONTROLLER
+	.ndo_poll_controller = velocity_poll_controller,
+#endif
 };
 
 /**
-- 
1.8.0.rc0

