Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757472AbaE2N5M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 09:57:12 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59486 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933522AbaE2Ntd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 09:49:33 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Thomas Richter <tmricht@linux.vnet.ibm.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 062/103] bonding: Remove debug_fs files when module init fails
Date: Thu, 29 May 2014 15:48:47 +0200
Message-Id: <2a0fe092c7eb575a56956ce9dc55a02fe69c3a31.1401371259.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
References: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
In-Reply-To: <cover.1401371258.git.jslaby@suse.cz>
References: <cover.1401371258.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Richter <tmricht@linux.vnet.ibm.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit db29868653394937037d71dc3545768302dda643 ]

Remove the bonding debug_fs entries when the
module initialization fails. The debug_fs
entries should be removed together with all other
already allocated resources.

Signed-off-by: Thomas Richter <tmricht@linux.vnet.ibm.com>
Signed-off-by: Jay Vosburgh <j.vosburgh@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/net/bonding/bond_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index dd8057d0bae7..f5a8b9c83ca6 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -4623,6 +4623,7 @@ static int __init bonding_init(void)
 out:
 	return res;
 err:
+	bond_destroy_debugfs();
 	rtnl_link_unregister(&bond_link_ops);
 err_link:
 	unregister_pernet_subsys(&bond_net_ops);
-- 
1.9.3

