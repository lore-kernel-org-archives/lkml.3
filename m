Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651AbaGIHOY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 03:14:24 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:36279 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754142AbaGIHOW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 03:14:22 -0400
From: Mugunthan V N <mugunthanvnm@ti.com>
To: <netdev@vger.kernel.org>
CC: <davem@davemloft.net>, <linux-api@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Mugunthan V N <mugunthanvnm@ti.com>
Subject: [net-next PATCH v2 1/3] net: ethtool: Add Multicast and broadcast rate limit coalescing feature
Date: Wed, 9 Jul 2014 12:44:08 +0530
Message-ID: <1404890050-4020-2-git-send-email-mugunthanvnm@ti.com>
X-Mailer: git-send-email 2.0.0.390.gcb682f8
In-Reply-To: <1404890050-4020-1-git-send-email-mugunthanvnm@ti.com>
References: <1404890050-4020-1-git-send-email-mugunthanvnm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add ability to limit the broadcast or multicast packets to prevent
the loading of the CPU by a hacker with a broadcast or multicast
packet flood.

Signed-off-by: Mugunthan V N <mugunthanvnm@ti.com>
---
 include/uapi/linux/ethtool.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index e3c7a71..96ade34 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -350,6 +350,8 @@ struct ethtool_modinfo {
  *	a TX interrupt, when the packet rate is above @pkt_rate_high.
  * @rate_sample_interval: How often to do adaptive coalescing packet rate
  *	sampling, measured in seconds.  Must not be zero.
+ * @rx_max_mcast: Threshold for high multicast packet rate (packets per second)
+ * @rx_max_bcast: Threshold for high broadcast packet rate (packets per second)
  *
  * Each pair of (usecs, max_frames) fields specifies that interrupts
  * should be coalesced until
@@ -400,6 +402,8 @@ struct ethtool_coalesce {
 	__u32	tx_coalesce_usecs_high;
 	__u32	tx_max_coalesced_frames_high;
 	__u32	rate_sample_interval;
+	__u32	rx_max_mcast;
+	__u32	rx_max_bcast;
 };
 
 /**
-- 
2.0.0.390.gcb682f8

