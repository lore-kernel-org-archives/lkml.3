Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993Ab3COQwA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 12:52:00 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:41279 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752232Ab3COQv6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 12:51:58 -0400
X-IronPort-AV: E=Sophos;i="4.84,852,1355068800"; 
   d="scan'208";a="6880049"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
        "David S. Miller" <davem@davemloft.net>, Cong Wang <amwang@redhat.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Eric Dumazet <edumazet@google.com>, Jiri Pirko <jiri@resnulli.us>,
        netdev@vger.kernel.org
Subject: [PATCH 4/9] netpoll: use DEFINE_STATIC_SRCU() to define netpoll_srcu
Date: Sat, 16 Mar 2013 00:50:52 +0800
Message-Id: <1363366257-4886-5-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1363366257-4886-1-git-send-email-laijs@cn.fujitsu.com>
References: <1363366257-4886-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/16 00:50:38,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/16 00:50:38,
	Serialize complete at 2013/03/16 00:50:38
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DEFINE_STATIC_SRCU() defines srcu struct and do init at build time.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 net/core/netpoll.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index fa32899..a3a17ae 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -47,7 +47,7 @@ static struct sk_buff_head skb_pool;
 
 static atomic_t trapped;
 
-static struct srcu_struct netpoll_srcu;
+DEFINE_STATIC_SRCU(netpoll_srcu);
 
 #define USEC_PER_POLL	50
 #define NETPOLL_RX_ENABLED  1
@@ -1212,7 +1212,6 @@ EXPORT_SYMBOL(netpoll_setup);
 static int __init netpoll_init(void)
 {
 	skb_queue_head_init(&skb_pool);
-	init_srcu_struct(&netpoll_srcu);
 	return 0;
 }
 core_initcall(netpoll_init);
-- 
1.7.4.4

