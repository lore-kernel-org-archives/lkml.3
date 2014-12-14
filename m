Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761AbaLNU3E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 15:29:04 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53244 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289AbaLNUZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 15:25:17 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        John Fastabend <john.fastabend@gmail.com>,
        Scott Feldman <sfeldma@cumulusnetworks.com>,
        Thomas Graf <tgraf@suug.ch>,
        John Fastabend <john.r.fastabend@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.17 34/47] bond: Check length of IFLA_BOND_ARP_IP_TARGET attributes
Date: Sun, 14 Dec 2014 12:21:09 -0800
Message-Id: <20141214201819.859954161@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141214201818.552715149@linuxfoundation.org>
References: <20141214201818.552715149@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Graf <tgraf@suug.ch>

[ Upstream commit f6c6fda4c9e17940b0a2ba206b0408babfdc930c ]

Fixes: 7f28fa10 ("bonding: add arp_ip_target netlink support")
Reported-by: John Fastabend <john.fastabend@gmail.com>
Cc: Scott Feldman <sfeldma@cumulusnetworks.com>
Signed-off-by: Thomas Graf <tgraf@suug.ch>
Acked-by: John Fastabend <john.r.fastabend@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/bonding/bond_netlink.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/net/bonding/bond_netlink.c
+++ b/drivers/net/bonding/bond_netlink.c
@@ -194,7 +194,12 @@ static int bond_changelink(struct net_de
 
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


