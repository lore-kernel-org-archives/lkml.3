Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751964AbaAMPVr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 10:21:47 -0500
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:3675 "EHLO
	mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751354AbaAMPVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 10:21:43 -0500
X-IronPort-AV: E=Sophos;i="4.95,653,1384297200"; 
   d="scan'208";a="44621451"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] ksz884x: delete useless variable
Date: Mon, 13 Jan 2014 17:17:24 +0100
Message-Id: <1389629847-5330-2-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1389629847-5330-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1389629847-5330-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Delete a variable that is at most only assigned to a constant, but never
used otherwise.  In this code, it is the variable result that is used for
the return code, not rc.

A simplified version of the semantic patch that fixes this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
type T;
identifier i;
constant c;
@@

-T i;
<... when != i
-i = c;
...>
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/net/ethernet/micrel/ksz884x.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/micrel/ksz884x.c b/drivers/net/ethernet/micrel/ksz884x.c
index 8e9dad7..ce84dc2 100644
--- a/drivers/net/ethernet/micrel/ksz884x.c
+++ b/drivers/net/ethernet/micrel/ksz884x.c
@@ -5853,15 +5853,12 @@ static int netdev_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	struct dev_info *hw_priv = priv->adapter;
 	struct ksz_hw *hw = &hw_priv->hw;
 	struct ksz_port *port = &priv->port;
-	int rc;
 	int result = 0;
 	struct mii_ioctl_data *data = if_mii(ifr);
 
 	if (down_interruptible(&priv->proc_sem))
 		return -ERESTARTSYS;
 
-	/* assume success */
-	rc = 0;
 	switch (cmd) {
 	/* Get address of MII PHY in use. */
 	case SIOCGMIIPHY:

