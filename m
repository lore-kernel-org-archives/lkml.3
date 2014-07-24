Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934642AbaGXUSy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 16:18:54 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:35329 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934176AbaGXUSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 16:18:52 -0400
Date: Fri, 25 Jul 2014 01:48:44 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH] igmp: remove exceptional & on function name
Message-ID: <20140724201844.GA16240@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In this file, function names are otherwise used as pointers without &.

A simplified version of the Coccinelle semantic patch that makes this
change is as follows: 

// <smpl>
@r@
identifier f;
@@

f(...) { ... }

@@
identifier r.f;
@@

- &f
+ f
// </smpl>

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
 net/ipv4/igmp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index db710b0..f10eab4 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -1321,7 +1321,7 @@ void ip_mc_inc_group(struct in_device *in_dev, __be32 addr)
 	atomic_set(&im->refcnt, 1);
 	spin_lock_init(&im->lock);
 #ifdef CONFIG_IP_MULTICAST
-	setup_timer(&im->timer, &igmp_timer_expire, (unsigned long)im);
+	setup_timer(&im->timer, igmp_timer_expire, (unsigned long)im);
 	im->unsolicit_count = IGMP_Unsolicited_Report_Count;
 #endif
 
-- 
1.9.1

