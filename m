Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256AbaLOObL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:31:11 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:39073 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753110AbaLOO31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:29:27 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Scott Feldman <sfeldma@cumulusnetworks.com>, Thomas Graf <tgraf@suug.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 157/168] bond: Check length of IFLA_BOND_ARP_IP_TARGET attributes
Date: Mon, 15 Dec 2014 14:26:51 +0000
Message-Id: <1418653622-21105-158-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Graf <tgraf@suug.ch>

commit f6c6fda4c9e17940b0a2ba206b0408babfdc930c upstream.

Fixes: 7f28fa10 ("bonding: add arp_ip_target netlink support")
Reported-by: John Fastabend <john.fastabend@gmail.com>
Cc: Scott Feldman <sfeldma@cumulusnetworks.com>
Signed-off-by: Thomas Graf <tgraf@suug.ch>
Acked-by: John Fastabend <john.r.fastabend@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/bonding/bond_netlink.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_netlink.c b/drivers/net/bonding/bond_netlink.c
index 5ab3c1847e67..8626bc0cb2af 100644
--- a/drivers/net/bonding/bond_netlink.c
+++ b/drivers/net/bonding/bond_netlink.c
@@ -197,7 +197,12 @@ static int bond_changelink(struct net_device *bond_dev,
 
 		bond_option_arp_ip_targets_clear(bond);
 		nla_for_each_nested(attr, data[IFLA_BOND_ARP_IP_TARGET], rem) {
-			__be32 target = nla_get_be32(attr);
+			__be32 target;
+
+			if (nla_len(attr) < sizeof(target))
+				return -EINVAL;
+
+			target = nla_get_be32(attr);
 
 			bond_opt_initval(&newval, (__force u64)target);
 			err = __bond_opt_set(bond, BOND_OPT_ARP_TARGETS,
-- 
2.1.3

