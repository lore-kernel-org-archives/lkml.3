Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933035Ab3JKULF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 16:11:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46125 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932425Ab3JKTlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:41:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ansis Atteka <aatteka@nicira.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 032/135] ip: use ip_hdr() in __ip_make_skb() to retrieve IP header
Date: Fri, 11 Oct 2013 12:38:33 -0700
Message-Id: <20131011193948.721372851@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193945.181603934@linuxfoundation.org>
References: <20131011193945.181603934@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ansis Atteka <aatteka@nicira.com>

[ Upstream commit 749154aa56b57652a282cbde57a57abc278d1205 ]

skb->data already points to IP header, but for the sake of
consistency we can also use ip_hdr() to retrieve it.

Signed-off-by: Ansis Atteka <aatteka@nicira.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ip_output.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1316,7 +1316,7 @@ struct sk_buff *__ip_make_skb(struct soc
 	else
 		ttl = ip_select_ttl(inet, &rt->dst);
 
-	iph = (struct iphdr *)skb->data;
+	iph = ip_hdr(skb);
 	iph->version = 4;
 	iph->ihl = 5;
 	iph->tos = inet->tos;


