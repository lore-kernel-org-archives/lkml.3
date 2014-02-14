Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157AbaBNUTw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 15:19:52 -0500
Received: from qmta11.emeryville.ca.mail.comcast.net ([76.96.27.211]:51938
	"EHLO qmta11.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753138AbaBNUTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 15:19:49 -0500
Message-Id: <20140214201905.918047057@linux.com>
Date: Fri, 14 Feb 2014 14:19:00 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 19/48] tilegx: Another case of get_cpu_var
References: <20140214201841.826179349@linux.com>
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=tilegx_new
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seems to have been introduced in 3.14-rc1.

Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/drivers/net/ethernet/tile/tilegx.c
===================================================================
--- linux.orig/drivers/net/ethernet/tile/tilegx.c	2014-02-03 14:00:01.159103055 -0600
+++ linux/drivers/net/ethernet/tile/tilegx.c	2014-02-03 14:01:06.237738404 -0600
@@ -1923,7 +1923,7 @@
  */
 static int tile_net_tx_tso(struct sk_buff *skb, struct net_device *dev)
 {
-	struct tile_net_info *info = &__get_cpu_var(per_cpu_info);
+	struct tile_net_info *info = this_cpu_ptr(&per_cpu_info);
 	struct tile_net_priv *priv = netdev_priv(dev);
 	int channel = priv->echannel;
 	int instance = priv->instance;

