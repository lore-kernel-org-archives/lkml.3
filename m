Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162089Ab3LFWga (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 17:36:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60540 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932106Ab3LFVwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:52:42 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.12 34/83] ipv6: fix leaking uninitialized port number of offender sockaddr
Date: Fri,  6 Dec 2013 13:51:24 -0800
Message-Id: <20131206214643.226504978@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.67.gb00d244
In-Reply-To: <20131206214640.002320724@linuxfoundation.org>
References: <20131206214640.002320724@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hannes Frederic Sowa <hannes@stressinduktion.org>

[ Upstream commit 1fa4c710b6fe7b0aac9907240291b6fe6aafc3b8 ]

Offenders don't have port numbers, so set it to 0.

Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/datagram.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/ipv6/datagram.c
+++ b/net/ipv6/datagram.c
@@ -378,6 +378,7 @@ int ipv6_recv_error(struct sock *sk, str
 	if (serr->ee.ee_origin != SO_EE_ORIGIN_LOCAL) {
 		sin->sin6_family = AF_INET6;
 		sin->sin6_flowinfo = 0;
+		sin->sin6_port = 0;
 		if (skb->protocol == htons(ETH_P_IPV6)) {
 			sin->sin6_addr = ipv6_hdr(skb)->saddr;
 			if (np->rxopt.all)


