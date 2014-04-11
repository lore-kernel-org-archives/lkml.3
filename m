Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030258AbaDKQIW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 12:08:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56365 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759408AbaDKQHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 12:07:32 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David L Stevens <dlstevens@us.ibm.com>,
        Cong Wang <cwang@twopensource.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 19/41] vxlan: fix potential NULL dereference in arp_reduce()
Date: Fri, 11 Apr 2014 09:09:50 -0700
Message-Id: <20140411160934.196241884@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140411160932.865173041@linuxfoundation.org>
References: <20140411160932.865173041@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Stevens <dlstevens@us.ibm.com>

[ Upstream commit 7346135dcd3f9b57f30a5512094848c678d7143e ]

This patch fixes a NULL pointer dereference in the event of an
skb allocation failure in arp_reduce().

Signed-Off-By: David L Stevens <dlstevens@us.ibm.com>
Acked-by: Cong Wang <cwang@twopensource.com>

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/vxlan.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -845,6 +845,9 @@ static int arp_reduce(struct net_device
 
 		neigh_release(n);
 
+		if (reply == NULL)
+			goto out;
+
 		skb_reset_mac_header(reply);
 		__skb_pull(reply, skb_network_offset(reply));
 		reply->ip_summed = CHECKSUM_UNNECESSARY;


