Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163Ab3IHDUn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 23:20:43 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55976 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756647Ab3IHDSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 23:18:53 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "David S. Miller" <davem@davemloft.net>,
        "Michal Tesar" <mtesar@redhat.com>
Date: Sun, 08 Sep 2013 03:52:01 +0100
Message-ID: <lsq.1378608721.815175859@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [009/121] sysctl net: Keep tcp_syn_retries inside the boundary
In-Reply-To: <lsq.1378608720.401499712@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.51-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Tesar <mtesar@redhat.com>

[ Upstream commit 651e92716aaae60fc41b9652f54cb6803896e0da ]

Limit the min/max value passed to the
/proc/sys/net/ipv4/tcp_syn_retries.

Signed-off-by: Michal Tesar <mtesar@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv4/sysctl_net_ipv4.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 5485077..739b073 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -32,6 +32,8 @@ static int tcp_adv_win_scale_min = -31;
 static int tcp_adv_win_scale_max = 31;
 static int ip_ttl_min = 1;
 static int ip_ttl_max = 255;
+static int tcp_syn_retries_min = 1;
+static int tcp_syn_retries_max = MAX_TCP_SYNCNT;
 static int ip_ping_group_range_min[] = { 0, 0 };
 static int ip_ping_group_range_max[] = { GID_T_MAX, GID_T_MAX };
 
@@ -231,7 +233,9 @@ static struct ctl_table ipv4_table[] = {
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

