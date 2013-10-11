Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756527Ab3JKVCc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 17:02:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45251 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757781Ab3JKThB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:37:01 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Daniel Borkmann <dborkman@redhat.com>,
        Nikolay Aleksandrov <nikolay@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 06/48] net: flow_dissector: fix thoff for IPPROTO_AH
Date: Fri, 11 Oct 2013 12:36:13 -0700
Message-Id: <20131011193637.968301431@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193637.253208688@linuxfoundation.org>
References: <20131011193637.253208688@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit b86783587b3d1d552326d955acee37eac48800f1 ]

In commit 8ed781668dd49 ("flow_keys: include thoff into flow_keys for
later usage"), we missed that existing code was using nhoff as a
temporary variable that could not always contain transport header
offset.

This is not a problem for TCP/UDP because port offset (@poff)
is 0 for these protocols.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Daniel Borkmann <dborkman@redhat.com>
Cc: Nikolay Aleksandrov <nikolay@redhat.com>
Acked-by: Nikolay Aleksandrov <nikolay@redhat.com>
Acked-by: Daniel Borkmann <dborkman@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/flow_dissector.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -133,8 +133,8 @@ ipv6:
 	if (poff >= 0) {
 		__be32 *ports, _ports;
 
-		nhoff += poff;
-		ports = skb_header_pointer(skb, nhoff, sizeof(_ports), &_ports);
+		ports = skb_header_pointer(skb, nhoff + poff,
+					   sizeof(_ports), &_ports);
 		if (ports)
 			flow->ports = *ports;
 	}


