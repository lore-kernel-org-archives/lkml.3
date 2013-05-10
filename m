Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141Ab3EJMNz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 08:13:55 -0400
Received: from mga01.intel.com ([192.55.52.88]:10405 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753012Ab3EJMNx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 08:13:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,647,1363158000"; 
   d="scan'208";a="335479176"
From: Imre Deak <imre.deak@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jay Vosburgh <fubar@us.ibm.com>, Andy Gospodarek <andy@greyhouse.net>,
        netdev@vger.kernel.org
Subject: [PATCH 06/11] net/bonding: take msecs_to_jiffies_min into use
Date: Fri, 10 May 2013 15:13:24 +0300
Message-Id: <1368188011-23661-6-git-send-email-imre.deak@intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1368188011-23661-1-git-send-email-imre.deak@intel.com>
References: <1368188011-23661-1-git-send-email-imre.deak@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use msecs_to_jiffies_min instead of open-coding the same.

Signed-off-by: Imre Deak <imre.deak@intel.com>
---
 drivers/net/bonding/bond_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 07401a3..0c2de73 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1751,7 +1751,7 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev)
 	read_lock(&bond->lock);
 
 	new_slave->last_arp_rx = jiffies -
-		(msecs_to_jiffies(bond->params.arp_interval) + 1);
+		(msecs_to_jiffies_min(bond->params.arp_interval));
 
 	if (bond->params.miimon && !bond->params.use_carrier) {
 		link_reporting = bond_check_dev_link(bond, slave_dev, 1);
-- 
1.7.10.4

