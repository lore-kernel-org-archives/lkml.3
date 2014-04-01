Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159AbaDAOQ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 10:16:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24694 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751886AbaDAOPh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 10:15:37 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Cc: Richard Guy Briggs <rgb@redhat.com>, eparis@redhat.com, sgrubb@redhat.com,
        hadi@mojatatu.com, davem@davemloft.net
Subject: [PATCH 1/3] netlink: simplify nfnetlink_bind
Date: Tue,  1 Apr 2014 10:14:56 -0400
Message-Id: <b182ddbee24a1bb1d339b966de4cbc5a2b9c96b0.1396317747.git.rgb@redhat.com>
In-Reply-To: <20140324183406.GE28666@madcap2.tricolour.ca>
References: <20140324183406.GE28666@madcap2.tricolour.ca>
In-Reply-To: <cover.1396317747.git.rgb@redhat.com>
References: <cover.1396317747.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove duplicity and simplify code flow by moving the rcu_read_unlock() above
the condition and let the flow control exit naturally at the end of the
function.

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 net/netfilter/nfnetlink.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 046aa13..1da5ef1 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -399,12 +399,9 @@ static void nfnetlink_bind(int group)
 
 	rcu_read_lock();
 	ss = nfnetlink_get_subsys(type);
-	if (!ss) {
-		rcu_read_unlock();
-		request_module("nfnetlink-subsys-%d", type);
-		return;
-	}
 	rcu_read_unlock();
+	if (!ss)
+		request_module("nfnetlink-subsys-%d", type);
 }
 #endif
 
-- 
1.7.1

