Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934219AbaFQQ15 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 12:27:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51096 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965425AbaFQQ1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 12:27:17 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Richter <tmricht@linux.vnet.ibm.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 052/121] bonding: Remove debug_fs files when module init fails
Date: Tue, 17 Jun 2014 09:17:10 -0700
Message-Id: <1403021899-16708-25-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403021899-16708-2-git-send-email-kamal@canonical.com>
References: <1403021899-16708-2-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.24 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/bonding/bond_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 490f5f5..ce3e007 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -4990,6 +4990,7 @@ static int __init bonding_init(void)
 out:
 	return res;
 err:
+	bond_destroy_debugfs();
 	rtnl_link_unregister(&bond_link_ops);
 err_link:
 	unregister_pernet_subsys(&bond_net_ops);
-- 
1.9.1

