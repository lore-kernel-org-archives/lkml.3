Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245Ab3BQWzj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 17:55:39 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45664 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755131Ab3BQWzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 17:55:21 -0500
Message-Id: <20130217225008.947357407@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 17 Feb 2013 22:51:04 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Sarveshwar Bandi <sarveshwar.bandi@emulex.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 63/66] bridge: Pull ip header into skb->data before looking  into ip header.
In-Reply-To: <20130217225001.621306883@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sarveshwar Bandi <sarveshwar.bandi@emulex.com>

[ Upstream commit 6caab7b0544e83e6c160b5e80f5a4a7dd69545c7 ]

If lower layer driver leaves the ip header in the skb fragment, it needs to
be first pulled into skb->data before inspecting ip header length or ip version
number.

Signed-off-by: Sarveshwar Bandi <sarveshwar.bandi@emulex.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/bridge/br_netfilter.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index 577ea5d..7c1745d 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -245,6 +245,9 @@ static int br_parse_ip_options(struct sk_buff *skb)
 	struct net_device *dev = skb->dev;
 	u32 len;
 
+	if (!pskb_may_pull(skb, sizeof(struct iphdr)))
+		goto inhdr_error;
+
 	iph = ip_hdr(skb);
 	opt = &(IPCB(skb)->opt);
 


