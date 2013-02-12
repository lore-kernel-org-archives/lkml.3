Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486Ab3BLUgJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 15:36:09 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53594 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268Ab3BLUgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 15:36:07 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Julian Anastasov <ja@ssi.bg>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 44/61] ipv4: Dont update the pmtu on mtu locked routes
Date: Tue, 12 Feb 2013 12:35:04 -0800
Message-Id: <20130212203424.003632032@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130212203417.890993903@linuxfoundation.org>
References: <20130212203417.890993903@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Steffen Klassert <steffen.klassert@secunet.com>

[ Upstream commit fa1e492aa3cbafba9f8fc6d05e5b08a3091daf4a ]

Routes with locked mtu should not use learned pmtu informations,
so do not update the pmtu on these routes.

Reported-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/route.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -912,6 +912,9 @@ static void __ip_rt_update_pmtu(struct r
 	struct dst_entry *dst = &rt->dst;
 	struct fib_result res;
 
+	if (dst_metric_locked(dst, RTAX_MTU))
+		return;
+
 	if (dst->dev->mtu < mtu)
 		return;
 


