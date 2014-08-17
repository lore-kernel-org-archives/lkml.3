Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752231AbaHQRgm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 13:36:42 -0400
Received: from qmta11.emeryville.ca.mail.comcast.net ([76.96.27.211]:48101
	"EHLO qmta11.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751906AbaHQRbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 13:31:12 -0400
Message-Id: <20140817173035.251400191@linux.com>
Date: Sun, 17 Aug 2014 12:30:38 -0500
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 15/35] [PATCH 15/36] drivers/net/ethernet/tile: __get_cpu_var call
 introduced in 3.14
References: <20140817173023.439660246@linux.com>
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0015-drivers-net-ethernet-tile-__get_cpu_var-call-introdu.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another case was merged for 3.14-rc1

Signed-off-by: Christoph Lameter <cl@linux.com>
---
 drivers/net/ethernet/tile/tilegx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux/drivers/net/ethernet/tile/tilegx.c
===================================================================
--- linux.orig/drivers/net/ethernet/tile/tilegx.c
+++ linux/drivers/net/ethernet/tile/tilegx.c
@@ -551,7 +551,7 @@ static inline bool filter_packet(struct
 static void tile_net_receive_skb(struct net_device *dev, struct sk_buff *skb,
 				 gxio_mpipe_idesc_t *idesc, unsigned long len)
 {
-	struct tile_net_info *info = &__get_cpu_var(per_cpu_info);
+	struct tile_net_info *info = this_cpu_ptr(&per_cpu_info);
 	struct tile_net_priv *priv = netdev_priv(dev);
 	int instance = priv->instance;
 
@@ -1927,7 +1927,7 @@ static void tso_egress(struct net_device
  */
 static int tile_net_tx_tso(struct sk_buff *skb, struct net_device *dev)
 {
-	struct tile_net_info *info = &__get_cpu_var(per_cpu_info);
+	struct tile_net_info *info = this_cpu_ptr(&per_cpu_info);
 	struct tile_net_priv *priv = netdev_priv(dev);
 	int channel = priv->echannel;
 	int instance = priv->instance;

