Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758344AbaELCUm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 22:20:42 -0400
Received: from 1wt.eu ([62.212.114.60]:34368 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751808AbaELBlg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:41:36 -0400
Message-Id: <20140512003203.088027167@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:32:59 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Michal Tesar <mtesar@redhat.com>, "David S. Miller" <davem@davemloft.net>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 059/143] sysctl net: Keep tcp_syn_retries inside the boundary
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Tesar <mtesar@redhat.com>

[ Upstream commit 651e92716aaae60fc41b9652f54cb6803896e0da ]

Limit the min/max value passed to the
/proc/sys/net/ipv4/tcp_syn_retries.

Signed-off-by: Michal Tesar <mtesar@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/ipv4/sysctl_net_ipv4.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 2dcf04d..910fa54 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -23,6 +23,8 @@
 
 static int zero;
 static int tcp_retr1_max = 255;
+static int tcp_syn_retries_min = 1;
+static int tcp_syn_retries_max = MAX_TCP_SYNCNT;
 static int ip_local_port_range_min[] = { 1, 1 };
 static int ip_local_port_range_max[] = { 65535, 65535 };
 
@@ -237,7 +239,9 @@ static struct ctl_table ipv4_table[] = {
 		.data		= &ipv4_config.no_pmtu_disc,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &tcp_syn_retries_min,
+		.extra2		= &tcp_syn_retries_max
 	},
 	{
 		.ctl_name	= NET_IPV4_NONLOCAL_BIND,
-- 
1.7.12.2.21.g234cd45.dirty



