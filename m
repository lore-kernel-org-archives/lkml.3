Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303Ab3KAVnz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 17:43:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54508 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754080Ab3KAVnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 17:43:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jiri Benc <jbenc@redhat.com>, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 08/32] ipv4: fix ineffective source address selection
Date: Fri,  1 Nov 2013 14:43:19 -0700
Message-Id: <20131101214315.724016071@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131101214313.735463599@linuxfoundation.org>
References: <20131101214313.735463599@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Benc <jbenc@redhat.com>

[ Upstream commit 0a7e22609067ff524fc7bbd45c6951dd08561667 ]

When sending out multicast messages, the source address in inet->mc_addr is
ignored and rewritten by an autoselected one. This is caused by a typo in
commit 813b3b5db831 ("ipv4: Use caller's on-stack flowi as-is in output
route lookups").

Signed-off-by: Jiri Benc <jbenc@redhat.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/route.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -2713,7 +2713,7 @@ static struct rtable *ip_route_output_sl
 							      RT_SCOPE_LINK);
 			goto make_route;
 		}
-		if (fl4->saddr) {
+		if (!fl4->saddr) {
 			if (ipv4_is_multicast(fl4->daddr))
 				fl4->saddr = inet_select_addr(dev_out, 0,
 							      fl4->flowi4_scope);


