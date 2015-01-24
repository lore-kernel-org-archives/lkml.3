Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781AbbAXBsY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 20:48:24 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:33614 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883AbbAXBsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 20:48:20 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Sasha Levin <sasha.levin@oracle.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org (open list:NETWORKING [GENERAL])
Subject: [PATCH] net: llc: use correct size for sysctl timeout entries
Date: Fri, 23 Jan 2015 20:47:00 -0500
Message-Id: <1422064020-22080-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 2.1.0
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The timeout entries are sizeof(int) rather than sizeof(long), which
means that when they were getting read we'd also leak kernel memory
to userspace along with the timeout values.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 net/llc/sysctl_net_llc.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/llc/sysctl_net_llc.c b/net/llc/sysctl_net_llc.c
index 612a5dd..799bafc 100644
--- a/net/llc/sysctl_net_llc.c
+++ b/net/llc/sysctl_net_llc.c
@@ -18,28 +18,28 @@ static struct ctl_table llc2_timeout_table[] = {
 	{
 		.procname	= "ack",
 		.data		= &sysctl_llc2_ack_timeout,
-		.maxlen		= sizeof(long),
+		.maxlen		= sizeof(sysctl_llc2_ack_timeout),
 		.mode		= 0644,
 		.proc_handler   = proc_dointvec_jiffies,
 	},
 	{
 		.procname	= "busy",
 		.data		= &sysctl_llc2_busy_timeout,
-		.maxlen		= sizeof(long),
+		.maxlen		= sizeof(sysctl_llc2_busy_timeout),
 		.mode		= 0644,
 		.proc_handler   = proc_dointvec_jiffies,
 	},
 	{
 		.procname	= "p",
 		.data		= &sysctl_llc2_p_timeout,
-		.maxlen		= sizeof(long),
+		.maxlen		= sizeof(sysctl_llc2_p_timeout),
 		.mode		= 0644,
 		.proc_handler   = proc_dointvec_jiffies,
 	},
 	{
 		.procname	= "rej",
 		.data		= &sysctl_llc2_rej_timeout,
-		.maxlen		= sizeof(long),
+		.maxlen		= sizeof(sysctl_llc2_rej_timeout),
 		.mode		= 0644,
 		.proc_handler   = proc_dointvec_jiffies,
 	},
-- 
1.7.10.4

