Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755119Ab3HQAYs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 20:24:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51498 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756084Ab3HPWiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:38:04 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Michal Tesar <mtesar@redhat.com>, "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 124/133] sysctl net: Keep tcp_syn_retries inside the boundary
Date: Fri, 16 Aug 2013 15:34:26 -0700
Message-Id: <1376692475-28413-125-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376692475-28413-1-git-send-email-kamal@canonical.com>
References: <1376692475-28413-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Tesar <mtesar@redhat.com>

[ Upstream commit 651e92716aaae60fc41b9652f54cb6803896e0da ]

Limit the min/max value passed to the
/proc/sys/net/ipv4/tcp_syn_retries.

Signed-off-by: Michal Tesar <mtesar@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/ipv4/sysctl_net_ipv4.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index d84400b..63632ea 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -35,6 +35,8 @@ static int tcp_adv_win_scale_min = -31;
 static int tcp_adv_win_scale_max = 31;
 static int ip_ttl_min = 1;
 static int ip_ttl_max = 255;
+static int tcp_syn_retries_min = 1;
+static int tcp_syn_retries_max = MAX_TCP_SYNCNT;
 static int ip_ping_group_range_min[] = { 0, 0 };
 static int ip_ping_group_range_max[] = { GID_T_MAX, GID_T_MAX };
 
@@ -330,7 +332,9 @@ static struct ctl_table ipv4_table[] = {
 		.data		= &sysctl_tcp_syn_retries,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &tcp_syn_retries_min,
+		.extra2		= &tcp_syn_retries_max
 	},
 	{
 		.procname	= "tcp_synack_retries",
-- 
1.8.1.2

