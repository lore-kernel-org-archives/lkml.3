Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759323Ab3BLVCg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 16:02:36 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53542 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754477Ab3BLUf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 15:35:59 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jiri Pirko <jiri@resnulli.us>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 34/61] ipv6: do not create neighbor entries for local delivery
Date: Tue, 12 Feb 2013 12:34:54 -0800
Message-Id: <20130212203422.814059001@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130212203417.890993903@linuxfoundation.org>
References: <20130212203417.890993903@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Marcelo Ricardo Leitner <mleitner@redhat.com>

[ Upstream commit bd30e947207e2ea0ff2c08f5b4a03025ddce48d3 ]

They will be created at output, if ever needed. This avoids creating
empty neighbor entries when TPROXYing/Forwarding packets for addresses
that are not even directly reachable.

Note that IPv4 already handles it this way. No neighbor entries are
created for local input.

Tested by myself and customer.

Signed-off-by: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: Marcelo Ricardo Leitner <mleitner@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/route.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -872,7 +872,7 @@ restart:
 	dst_hold(&rt->dst);
 	read_unlock_bh(&table->tb6_lock);
 
-	if (!rt->n && !(rt->rt6i_flags & RTF_NONEXTHOP))
+	if (!rt->n && !(rt->rt6i_flags & (RTF_NONEXTHOP | RTF_LOCAL)))
 		nrt = rt6_alloc_cow(rt, &fl6->daddr, &fl6->saddr);
 	else if (!(rt->dst.flags & DST_HOST))
 		nrt = rt6_alloc_clone(rt, &fl6->daddr);


