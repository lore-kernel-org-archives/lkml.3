Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933088Ab3CUIYY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 04:24:24 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:48668 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757920Ab3CUIXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 04:23:15 -0400
Subject: [PATCH RFC 4/5] ptp: add stub function for ptp_clock_index()
To: Michal Marek <mmarek@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Tejun Heo <tj@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Richard Cochran <richardcochran@gmail.com>
Date: Thu, 21 Mar 2013 12:23:09 +0400
Message-ID: <20130321082309.21557.27838.stgit@zurg>
In-Reply-To: <20130321082256.21557.68351.stgit@zurg>
References: <20130321082256.21557.68351.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After this patch function ptp_clock_index(struct ptp_clock *ptp)
returns -1 if ptp is NULL or CONFIG_PTP_1588_CLOCK disabled.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Richard Cochran <richardcochran@gmail.com>
---
 drivers/net/ethernet/broadcom/tg3.c              |    5 +----
 drivers/net/ethernet/freescale/fec.c             |    5 +----
 drivers/net/ethernet/intel/e1000e/ethtool.c      |    3 +--
 drivers/net/ethernet/intel/igb/igb_ethtool.c     |    5 +----
 drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c |    5 +----
 drivers/ptp/ptp_clock.c                          |    2 +-
 include/linux/ptp_clock_kernel.h                 |   12 ++++++++++++
 7 files changed, 18 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 67d2663..9eafff7 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -5630,10 +5630,7 @@ static int tg3_get_ts_info(struct net_device *dev, struct ethtool_ts_info *info)
 				SOF_TIMESTAMPING_RX_HARDWARE |
 				SOF_TIMESTAMPING_RAW_HARDWARE;
 
-	if (tp->ptp_clock)
-		info->phc_index = ptp_clock_index(tp->ptp_clock);
-	else
-		info->phc_index = -1;
+	info->phc_index = ptp_clock_index(tp->ptp_clock);
 
 	info->tx_types = (1 << HWTSTAMP_TX_OFF) | (1 << HWTSTAMP_TX_ON);
 
diff --git a/drivers/net/ethernet/freescale/fec.c b/drivers/net/ethernet/freescale/fec.c
index e3f3937..4fde3c3 100644
--- a/drivers/net/ethernet/freescale/fec.c
+++ b/drivers/net/ethernet/freescale/fec.c
@@ -1240,10 +1240,7 @@ static int fec_enet_get_ts_info(struct net_device *ndev,
 					SOF_TIMESTAMPING_TX_HARDWARE |
 					SOF_TIMESTAMPING_RX_HARDWARE |
 					SOF_TIMESTAMPING_RAW_HARDWARE;
-		if (fep->ptp_clock)
-			info->phc_index = ptp_clock_index(fep->ptp_clock);
-		else
-			info->phc_index = -1;
+		info->phc_index = ptp_clock_index(fep->ptp_clock);
 
 		info->tx_types = (1 << HWTSTAMP_TX_OFF) |
 				 (1 << HWTSTAMP_TX_ON);
diff --git a/drivers/net/ethernet/intel/e1000e/ethtool.c b/drivers/net/ethernet/intel/e1000e/ethtool.c
index f91a8f3..b4f110c 100644
--- a/drivers/net/ethernet/intel/e1000e/ethtool.c
+++ b/drivers/net/ethernet/intel/e1000e/ethtool.c
@@ -2224,8 +2224,7 @@ static int e1000e_get_ts_info(struct net_device *netdev,
 			    (1 << HWTSTAMP_FILTER_PTP_V2_DELAY_REQ) |
 			    (1 << HWTSTAMP_FILTER_ALL));
 
-	if (adapter->ptp_clock)
-		info->phc_index = ptp_clock_index(adapter->ptp_clock);
+	info->phc_index = ptp_clock_index(adapter->ptp_clock);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/intel/igb/igb_ethtool.c b/drivers/net/ethernet/intel/igb/igb_ethtool.c
index a3830a8..924fd8d 100644
--- a/drivers/net/ethernet/intel/igb/igb_ethtool.c
+++ b/drivers/net/ethernet/intel/igb/igb_ethtool.c
@@ -2293,10 +2293,7 @@ static int igb_get_ts_info(struct net_device *dev,
 			SOF_TIMESTAMPING_RX_HARDWARE |
 			SOF_TIMESTAMPING_RAW_HARDWARE;
 
-		if (adapter->ptp_clock)
-			info->phc_index = ptp_clock_index(adapter->ptp_clock);
-		else
-			info->phc_index = -1;
+		info->phc_index = ptp_clock_index(adapter->ptp_clock);
 
 		info->tx_types =
 			(1 << HWTSTAMP_TX_OFF) |
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
index c3f1afd..71d4164 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
@@ -2723,10 +2723,7 @@ static int ixgbe_get_ts_info(struct net_device *dev,
 			SOF_TIMESTAMPING_RX_HARDWARE |
 			SOF_TIMESTAMPING_RAW_HARDWARE;
 
-		if (adapter->ptp_clock)
-			info->phc_index = ptp_clock_index(adapter->ptp_clock);
-		else
-			info->phc_index = -1;
+		info->phc_index = ptp_clock_index(adapter->ptp_clock);
 
 		info->tx_types =
 			(1 << HWTSTAMP_TX_OFF) |
diff --git a/drivers/ptp/ptp_clock.c b/drivers/ptp/ptp_clock.c
index 79f4bce..f97d144 100644
--- a/drivers/ptp/ptp_clock.c
+++ b/drivers/ptp/ptp_clock.c
@@ -314,7 +314,7 @@ EXPORT_SYMBOL(ptp_clock_event);
 
 int ptp_clock_index(struct ptp_clock *ptp)
 {
-	return ptp->index;
+	return ptp ? ptp->index : -1;
 }
 EXPORT_SYMBOL(ptp_clock_index);
 
diff --git a/include/linux/ptp_clock_kernel.h b/include/linux/ptp_clock_kernel.h
index 38a9935..4788943 100644
--- a/include/linux/ptp_clock_kernel.h
+++ b/include/linux/ptp_clock_kernel.h
@@ -148,12 +148,24 @@ struct ptp_clock_event {
 extern void ptp_clock_event(struct ptp_clock *ptp,
 			    struct ptp_clock_event *event);
 
+#if IS_ENABLED(CONFIG_PTP_1588_CLOCK)
+
 /**
  * ptp_clock_index() - obtain the device index of a PTP clock
+ *		       returns -1 if @ptp is NULL
  *
  * @ptp:    The clock obtained from ptp_clock_register().
  */
 
 extern int ptp_clock_index(struct ptp_clock *ptp);
 
+#else /* IS_ENABLED(CONFIG_PTP_1588_CLOCK) */
+
+static inline int ptp_clock_index(struct ptp_clock *ptp)
+{
+	return -1;
+}
+
+#endif /* IS_ENABLED(CONFIG_PTP_1588_CLOCK) */
+
 #endif

