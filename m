Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754912Ab3KAWEk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 18:04:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54958 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754805Ab3KAWEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 18:04:37 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Patrick McHardy <kaber@trash.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 17/54] net: vlan: fix nlmsg size calculation in vlan_get_size()
Date: Fri,  1 Nov 2013 15:03:45 -0700
Message-Id: <20131101220213.264448547@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131101220211.311926234@linuxfoundation.org>
References: <20131101220211.311926234@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit c33a39c575068c2ea9bffb22fd6de2df19c74b89 ]

This patch fixes the calculation of the nlmsg size, by adding the missing
nla_total_size().

Cc: Patrick McHardy <kaber@trash.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/8021q/vlan_netlink.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/8021q/vlan_netlink.c
+++ b/net/8021q/vlan_netlink.c
@@ -171,7 +171,7 @@ static size_t vlan_get_size(const struct
 
 	return nla_total_size(2) +	/* IFLA_VLAN_PROTOCOL */
 	       nla_total_size(2) +	/* IFLA_VLAN_ID */
-	       sizeof(struct ifla_vlan_flags) + /* IFLA_VLAN_FLAGS */
+	       nla_total_size(sizeof(struct ifla_vlan_flags)) + /* IFLA_VLAN_FLAGS */
 	       vlan_qos_map_size(vlan->nr_ingress_mappings) +
 	       vlan_qos_map_size(vlan->nr_egress_mappings);
 }


