Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753618AbaFGBrS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 21:47:18 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35957 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752490AbaFGBXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 21:23:36 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "David S. Miller" <davem@davemloft.net>,
        "Jay Vosburgh" <j.vosburgh@gmail.com>,
        "Thomas Richter" <tmricht@linux.vnet.ibm.com>
Date: Sat, 07 Jun 2014 02:26:28 +0100
Message-ID: <lsq.1402104388.93237058@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 09/92] bonding: Remove debug_fs files when module init
 fails
In-Reply-To: <lsq.1402104388.385007124@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.60-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Richter <tmricht@linux.vnet.ibm.com>

[ Upstream commit db29868653394937037d71dc3545768302dda643 ]

Remove the bonding debug_fs entries when the
module initialization fails. The debug_fs
entries should be removed together with all other
already allocated resources.

Signed-off-by: Thomas Richter <tmricht@linux.vnet.ibm.com>
Signed-off-by: Jay Vosburgh <j.vosburgh@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/bonding/bond_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 1bf36ac..5af2a8f 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -4914,6 +4914,7 @@ static int __init bonding_init(void)
 out:
 	return res;
 err:
+	bond_destroy_debugfs();
 	rtnl_link_unregister(&bond_link_ops);
 err_link:
 	unregister_pernet_subsys(&bond_net_ops);

