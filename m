Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030350Ab3HICDw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 22:03:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55905 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030222Ab3HIB7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 21:59:35 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Michal Tesar <mtesar@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 088/102] sysctl net: Keep tcp_syn_retries inside the boundary
Date: Thu,  8 Aug 2013 18:58:04 -0700
Message-Id: <20130809015031.057727511@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130809015010.208118575@linuxfoundation.org>
References: <20130809015010.208118575@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Tesar <mtesar@redhat.com>

[ Upstream commit 651e92716aaae60fc41b9652f54cb6803896e0da ]

Limit the min/max value passed to the
/proc/sys/net/ipv4/tcp_syn_retries.

Signed-off-by: Michal Tesar <mtesar@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/sysctl_net_ipv4.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -36,6 +36,8 @@ static int tcp_adv_win_scale_min = -31;
 static int tcp_adv_win_scale_max = 31;
 static int ip_ttl_min = 1;
 static int ip_ttl_max = 255;
+static int tcp_syn_retries_min = 1;
+static int tcp_syn_retries_max = MAX_TCP_SYNCNT;
 static int ip_ping_group_range_min[] = { 0, 0 };
 static int ip_ping_group_range_max[] = { GID_T_MAX, GID_T_MAX };
 
@@ -331,7 +333,9 @@ static struct ctl_table ipv4_table[] = {
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


