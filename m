Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509Ab3J2SJc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 14:09:32 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59543 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671Ab3J2SJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 14:09:29 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ansis Atteka <aatteka@nicira.com>, "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 46/81] ip: use ip_hdr() in __ip_make_skb() to retrieve IP header
Date: Tue, 29 Oct 2013 11:04:07 -0700
Message-Id: <1383069882-11437-47-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383069882-11437-1-git-send-email-kamal@canonical.com>
References: <1383069882-11437-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ansis Atteka <aatteka@nicira.com>

[ Upstream commit 749154aa56b57652a282cbde57a57abc278d1205 ]

skb->data already points to IP header, but for the sake of
consistency we can also use ip_hdr() to retrieve it.

Signed-off-by: Ansis Atteka <aatteka@nicira.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/ipv4/ip_output.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 3e98ed2..c3209b5 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1324,7 +1324,7 @@ struct sk_buff *__ip_make_skb(struct sock *sk,
 	else
 		ttl = ip_select_ttl(inet, &rt->dst);
 
-	iph = (struct iphdr *)skb->data;
+	iph = ip_hdr(skb);
 	iph->version = 4;
 	iph->ihl = 5;
 	iph->tos = inet->tos;
-- 
1.8.1.2

