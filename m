Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934378AbaKLDLO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 22:11:14 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59906 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932529AbaKLBh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:37:58 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tom Herbert <therbert@google.com>,
        Alexander Duyck <alexander.h.duyck@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.14 009/203] gre: Use inner mac length when computing tunnel length
Date: Wed, 12 Nov 2014 10:14:39 +0900
Message-Id: <20141112011543.130047064@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112011542.686743533@linuxfoundation.org>
References: <20141112011542.686743533@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tom Herbert <therbert@google.com>

[ Upstream commit 14051f0452a2c26a3f4791e6ad6a435e8f1945ff ]

Currently, skb_inner_network_header is used but this does not account
for Ethernet header for ETH_P_TEB. Use skb_inner_mac_header which
handles TEB and also should work with IP encapsulation in which case
inner mac and inner network headers are the same.

Tested: Ran TCP_STREAM over GRE, worked as expected.

Signed-off-by: Tom Herbert <therbert@google.com>
Acked-by: Alexander Duyck <alexander.h.duyck@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/gre_offload.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/gre_offload.c
+++ b/net/ipv4/gre_offload.c
@@ -50,7 +50,7 @@ static struct sk_buff *gre_gso_segment(s
 
 	greh = (struct gre_base_hdr *)skb_transport_header(skb);
 
-	ghl = skb_inner_network_header(skb) - skb_transport_header(skb);
+	ghl = skb_inner_mac_header(skb) - skb_transport_header(skb);
 	if (unlikely(ghl < sizeof(*greh)))
 		goto out;
 


