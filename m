Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757611Ab3BGERD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 23:17:03 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:30409 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751846Ab3BGEQ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 23:16:59 -0500
X-IronPort-AV: E=Sophos;i="4.84,619,1355068800"; 
   d="scan'208";a="6698449"
Message-ID: <51132A56.60906@cn.fujitsu.com>
Date: Thu, 07 Feb 2013 12:15:18 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.8) Gecko/20121012 Thunderbird/10.0.8
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: davem@davemloft.net, Julian Anastasov <ja@ssi.bg>,
        Simon Horman <horms@verge.net.au>, Linux MM <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] net: fix functions and variables related to netns_ipvs->sysctl_sync_qlen_max
References: <51131B88.6040809@cn.fujitsu.com>
In-Reply-To: <51131B88.6040809@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/07 12:15:34,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/07 12:15:36,
	Serialize complete at 2013/02/07 12:15:36
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the type of netns_ipvs->sysctl_sync_qlen_max has been changed to
unsigned long, type of its related proc var sync_qlen_max should be changed
to unsigned long, too. Also the return type of function sysctl_sync_qlen_max().

Besides, the type of ipvs_master_sync_state->sync_queue_len should also be
changed to unsigned long.

Changelog from V1:
- change type of ipvs_master_sync_state->sync_queue_len to unsigned long
  as Simon addressed.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>
Cc: Julian Anastasov <ja@ssi.bg>
Cc: Simon Horman <horms@verge.net.au>
Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 include/net/ip_vs.h            |    6 +++---
 net/netfilter/ipvs/ip_vs_ctl.c |    4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index 68c69d5..1d56f92 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -874,7 +874,7 @@ struct ip_vs_app {
 struct ipvs_master_sync_state {
 	struct list_head	sync_queue;
 	struct ip_vs_sync_buff	*sync_buff;
-	int			sync_queue_len;
+	unsigned long		sync_queue_len;
 	unsigned int		sync_queue_delay;
 	struct task_struct	*master_thread;
 	struct delayed_work	master_wakeup_work;
@@ -1052,7 +1052,7 @@ static inline int sysctl_sync_ports(struct netns_ipvs *ipvs)
 	return ACCESS_ONCE(ipvs->sysctl_sync_ports);
 }
 
-static inline int sysctl_sync_qlen_max(struct netns_ipvs *ipvs)
+static inline unsigned long sysctl_sync_qlen_max(struct netns_ipvs *ipvs)
 {
 	return ipvs->sysctl_sync_qlen_max;
 }
@@ -1099,7 +1099,7 @@ static inline int sysctl_sync_ports(struct netns_ipvs *ipvs)
 	return 1;
 }
 
-static inline int sysctl_sync_qlen_max(struct netns_ipvs *ipvs)
+static inline unsigned long sysctl_sync_qlen_max(struct netns_ipvs *ipvs)
 {
 	return IPVS_SYNC_QLEN_MAX;
 }
diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index ec664cb..d79a530 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -1747,9 +1747,9 @@ static struct ctl_table vs_vars[] = {
 	},
 	{
 		.procname	= "sync_qlen_max",
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(unsigned long),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_doulongvec_minmax,
 	},
 	{
 		.procname	= "sync_sock_size",
-- 
1.7.1
