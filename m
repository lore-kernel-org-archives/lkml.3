Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760305AbaGYM2z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 08:28:55 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:35631 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751713AbaGYM2y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 08:28:54 -0400
From: Mugunthan V N <mugunthanvnm@ti.com>
To: <netdev@vger.kernel.org>
CC: <davem@davemloft.net>, <ben@decadent.org.uk>, <linux-api@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Mugunthan V N <mugunthanvnm@ti.com>
Subject: [RFC PATCH 1/1] ethtool: adding support for multiple slave port configuration
Date: Fri, 25 Jul 2014 17:58:25 +0530
Message-ID: <1406291305-22286-1-git-send-email-mugunthanvnm@ti.com>
X-Mailer: git-send-email 2.0.2.673.g9ab0882
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some Ethernet Swtich controllers like CPSW in AM335x, TI814x, DRA7x and
AM43xx SoCs, Network Coprocessor in AM5K2E0x, Realtek Switch controllers
etc has to capability of conneting multiple networks using L2 switching
and has multiple phys. With the existing code, ethtool can communicate
only to one phy.

To enable user to communicate multiple phy connected to single Ethernet
Switch controller, intoducing a optional new parameter in Ethtool interface
to pass which slave to set/get the phy configuration.

Signed-off-by: Mugunthan V N <mugunthanvnm@ti.com>
---
 include/uapi/linux/ethtool.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index 96ade34..3011427 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -60,6 +60,9 @@
  *	and other link features that the link partner advertised
  *	through autonegotiation; 0 if unknown or not applicable.
  *	Read-only.
+ * @slave_port: Specify which slave port to be used to set/get
+ *	parmeters, for example which slave port phy to be used for
+ *	set/get phy capabilities
  *
  * The link speed in Mbps is split between @speed and @speed_hi.  Use
  * the ethtool_cmd_speed() and ethtool_cmd_speed_set() functions to
@@ -107,7 +110,8 @@ struct ethtool_cmd {
 	__u8	eth_tp_mdix;
 	__u8	eth_tp_mdix_ctrl;
 	__u32	lp_advertising;
-	__u32	reserved[2];
+	__u32	slave_port;
+	__u32	reserved;
 };
 
 static inline void ethtool_cmd_speed_set(struct ethtool_cmd *ep,
-- 
2.0.2.673.g9ab0882

