Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759074Ab3ERDKW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 23:10:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26211 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758575Ab3ERDAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 23:00:21 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=ifZyRk3Jce8A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=qB6N6sGYCKYA:10 a=LuxQ-7HEAAAA:8 a=JhOpUDsbAAAA:8 a=J1Y8HTJGAAAA:8 a=31FYUmqyeZ1yupaIOyYA:9 a=Bm8BtE0CId0A:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021657.130094313@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:17:33 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Hans Schillstrom <hans@schillstrom.com>, Julian Anastasov <ja@ssi.bg>,
        Simon Horman <horms@verge.net.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 096/136 ] ipvs: ip_vs_sip_fill_param() BUG: bad check of return value
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0096-ipvs-ip_vs_sip_fill_param-BUG-bad-check-of-return-va.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Hans Schillstrom <hans@schillstrom.com>

[ Upstream commit f7a1dd6e3ad59f0cfd51da29dfdbfd54122c5916 ]

The reason for this patch is crash in kmemdup
caused by returning from get_callid with uniialized
matchoff and matchlen.

Removing Zero check of matchlen since it's done by ct_sip_get_header()

BUG: unable to handle kernel paging request at ffff880457b5763f
IP: [<ffffffff810df7fc>] kmemdup+0x2e/0x35
PGD 27f6067 PUD 0
Oops: 0000 [#1] PREEMPT SMP
Modules linked in: xt_state xt_helper nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_mangle xt_connmark xt_conntrack ip6_tables nf_conntrack_ftp ip_vs_ftp nf_nat xt_tcpudp iptable_mangle xt_mark ip_tables x_tables ip_vs_rr ip_vs_lblcr ip_vs_pe_sip ip_vs nf_conntrack_sip nf_conntrack bonding igb i2c_algo_bit i2c_core
CPU 5
Pid: 0, comm: swapper/5 Not tainted 3.9.0-rc5+ #5                  /S1200KP
RIP: 0010:[<ffffffff810df7fc>]  [<ffffffff810df7fc>] kmemdup+0x2e/0x35
RSP: 0018:ffff8803fea03648  EFLAGS: 00010282
RAX: ffff8803d61063e0 RBX: 0000000000000003 RCX: 0000000000000003
RDX: 0000000000000003 RSI: ffff880457b5763f RDI: ffff8803d61063e0
RBP: ffff8803fea03658 R08: 0000000000000008 R09: 0000000000000011
R10: 0000000000000011 R11: 00ffffffff81a8a3 R12: ffff880457b5763f
R13: ffff8803d67f786a R14: ffff8803fea03730 R15: ffffffffa0098e90
FS:  0000000000000000(0000) GS:ffff8803fea00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff880457b5763f CR3: 0000000001a0c000 CR4: 00000000001407e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper/5 (pid: 0, threadinfo ffff8803ee18c000, task ffff8803ee18a480)
Stack:
 ffff8803d822a080 000000000000001c ffff8803fea036c8 ffffffffa000937a
 ffffffff81f0d8a0 000000038135fdd5 ffff880300000014 ffff880300110000
 ffffffff150118ac ffff8803d7e8a000 ffff88031e0118ac 0000000000000000
Call Trace:
 <IRQ>

 [<ffffffffa000937a>] ip_vs_sip_fill_param+0x13a/0x187 [ip_vs_pe_sip]
 [<ffffffffa007b209>] ip_vs_sched_persist+0x2c6/0x9c3 [ip_vs]
 [<ffffffff8107dc53>] ? __lock_acquire+0x677/0x1697
 [<ffffffff8100972e>] ? native_sched_clock+0x3c/0x7d
 [<ffffffff8100972e>] ? native_sched_clock+0x3c/0x7d
 [<ffffffff810649bc>] ? sched_clock_cpu+0x43/0xcf
 [<ffffffffa007bb1e>] ip_vs_schedule+0x181/0x4ba [ip_vs]
...

Signed-off-by: Hans Schillstrom <hans@schillstrom.com>
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Simon Horman <horms@verge.net.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 net/netfilter/ipvs/ip_vs_pe_sip.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_pe_sip.c b/net/netfilter/ipvs/ip_vs_pe_sip.c
index 1aa5cac..55add93 100644
--- a/net/netfilter/ipvs/ip_vs_pe_sip.c
+++ b/net/netfilter/ipvs/ip_vs_pe_sip.c
@@ -37,14 +37,10 @@ static int get_callid(const char *dptr, unsigned int dataoff,
 		if (ret > 0)
 			break;
 		if (!ret)
-			return 0;
+			return -EINVAL;
 		dataoff += *matchoff;
 	}
 
-	/* Empty callid is useless */
-	if (!*matchlen)
-		return -EINVAL;
-
 	/* Too large is useless */
 	if (*matchlen > IP_VS_PEDATA_MAXLEN)
 		return -EINVAL;
-- 
1.7.10.4


