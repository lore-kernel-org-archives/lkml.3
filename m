Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758039AbaJCWOb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 18:14:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47078 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757997AbaJCWON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:14:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chris J Arges <chris.j.arges@canonical.com>,
        Julian Anastasov <ja@ssi.bg>, Simon Horman <horms@verge.net.au>
Subject: [PATCH 3.14 226/238] ipvs: fix ipv6 hook registration for local replies
Date: Fri,  3 Oct 2014 14:32:21 -0700
Message-Id: <20141003212920.890993632@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212913.680985295@linuxfoundation.org>
References: <20141003212913.680985295@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julian Anastasov <ja@ssi.bg>

commit eb90b0c734ad793d5f5bf230a9e9a4dcc48df8aa upstream.

commit fc604767613b6d2036cdc35b660bc39451040a47
("ipvs: changes for local real server") from 2.6.37
introduced DNAT support to local real server but the
IPv6 LOCAL_OUT handler ip_vs_local_reply6() is
registered incorrectly as IPv4 hook causing any outgoing
IPv4 traffic to be dropped depending on the IP header values.

Chris tracked down the problem to CONFIG_IP_VS_IPV6=y
Bug report: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1349768

Reported-by: Chris J Arges <chris.j.arges@canonical.com>
Tested-by: Chris J Arges <chris.j.arges@canonical.com>
Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/ipvs/ip_vs_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -1906,7 +1906,7 @@ static struct nf_hook_ops ip_vs_ops[] __
 	{
 		.hook		= ip_vs_local_reply6,
 		.owner		= THIS_MODULE,
-		.pf		= NFPROTO_IPV4,
+		.pf		= NFPROTO_IPV6,
 		.hooknum	= NF_INET_LOCAL_OUT,
 		.priority	= NF_IP6_PRI_NAT_DST + 1,
 	},


