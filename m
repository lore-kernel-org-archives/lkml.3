Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548AbaBNUaK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 15:30:10 -0500
Received: from qmta10.emeryville.ca.mail.comcast.net ([76.96.30.17]:48303 "EHLO
	qmta10.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753115AbaBNUTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 15:19:47 -0500
Message-Id: <20140214201905.801527788@linux.com>
Date: Fri, 14 Feb 2014 14:18:59 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 18/48] drivers/net/ethernet/tile: __get_cpu_var call introduced in 3.14
References: <20140214201841.826179349@linux.com>
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=tilegx
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another case was merged for 3.14-rc1

Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/drivers/net/ethernet/tile/tilegx.c
===================================================================
--- linux.orig/drivers/net/ethernet/tile/tilegx.c	2014-02-03 13:48:07.334069941 -0600
+++ linux/drivers/net/ethernet/tile/tilegx.c	2014-02-03 13:49:25.882425863 -0600
@@ -551,7 +551,7 @@
 static void tile_net_receive_skb(struct net_device *dev, struct sk_buff *skb,
 				 gxio_mpipe_idesc_t *idesc, unsigned long len)
 {
-	struct tile_net_info *info = &__get_cpu_var(per_cpu_info);
+	struct tile_net_info *info = this_cpu_ptr(&per_cpu_info);
 	struct tile_net_priv *priv = netdev_priv(dev);
 	int instance = priv->instance;
 

