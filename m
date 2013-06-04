Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119Ab3FDWnp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 18:43:45 -0400
Received: from 1wt.eu ([62.212.114.60]:35747 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752388Ab3FDWnc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:43:32 -0400
Message-Id: <20130604172136.642120176@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:24:03 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: nitin padalia <padalia.nitin@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 153/184] net: prevent setting ttl=0 via IP_TTL
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Cong Wang <xiyou.wangcong@gmail.com>

[ Upstream commit c9be4a5c49cf51cc70a993f004c5bb30067a65ce ]

A regression is introduced by the following commit:

	commit 4d52cfbef6266092d535237ba5a4b981458ab171
	Author: Eric Dumazet <eric.dumazet@gmail.com>
	Date:   Tue Jun 2 00:42:16 2009 -0700

	    net: ipv4/ip_sockglue.c cleanups

	    Pure cleanups

but it is not a pure cleanup...

	-               if (val != -1 && (val < 1 || val>255))
	+               if (val != -1 && (val < 0 || val > 255))

Since there is no reason provided to allow ttl=0, change it back.

Reported-by: nitin padalia <padalia.nitin@gmail.com>
Cc: nitin padalia <padalia.nitin@gmail.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/ipv4/ip_sockglue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index e982b5c..184a7ad 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -563,7 +563,7 @@ static int do_ip_setsockopt(struct sock *sk, int level,
 	case IP_TTL:
 		if (optlen < 1)
 			goto e_inval;
-		if (val != -1 && (val < 0 || val > 255))
+		if (val != -1 && (val < 1 || val > 255))
 			goto e_inval;
 		inet->uc_ttl = val;
 		break;
-- 
1.7.12.2.21.g234cd45.dirty



