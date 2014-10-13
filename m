Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214AbaJMDB6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 23:01:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45557 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931AbaJMCZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 22:25:27 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Matthieu Ternisien dOuville <matthieu.tdo@6wind.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 10/16] ip6_gre: fix flowi6_proto value in xmit path
Date: Mon, 13 Oct 2014 04:24:07 +0200
Message-Id: <20141013022341.835931831@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141013022341.386913672@linuxfoundation.org>
References: <20141013022341.386913672@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

[ Upstream commit 3be07244b7337760a3269d56b2f4a63e72218648 ]

In xmit path, we build a flowi6 which will be used for the output route lookup.
We are sending a GRE packet, neither IPv4 nor IPv6 encapsulated packet, thus the
protocol should be IPPROTO_GRE.

Fixes: c12b395a4664 ("gre: Support GRE over IPv6")
Reported-by: Matthieu Ternisien d'Ouville <matthieu.tdo@6wind.com>
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_gre.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -787,7 +787,7 @@ static inline int ip6gre_xmit_ipv4(struc
 		encap_limit = t->parms.encap_limit;
 
 	memcpy(&fl6, &t->fl.u.ip6, sizeof(fl6));
-	fl6.flowi6_proto = IPPROTO_IPIP;
+	fl6.flowi6_proto = IPPROTO_GRE;
 
 	dsfield = ipv4_get_dsfield(iph);
 
@@ -837,7 +837,7 @@ static inline int ip6gre_xmit_ipv6(struc
 		encap_limit = t->parms.encap_limit;
 
 	memcpy(&fl6, &t->fl.u.ip6, sizeof(fl6));
-	fl6.flowi6_proto = IPPROTO_IPV6;
+	fl6.flowi6_proto = IPPROTO_GRE;
 
 	dsfield = ipv6_get_dsfield(ipv6h);
 	if (t->parms.flags & IP6_TNL_F_USE_ORIG_TCLASS)


