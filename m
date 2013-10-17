Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761560Ab3JQA3k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 20:29:40 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:50767 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761224Ab3JQA3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 20:29:38 -0400
Date: Wed, 16 Oct 2013 17:29:34 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: Randy Dunlap <rdunlap@infradead.org>, David Miller <davem@davemloft.net>
Cc: Vitaly Lavrov <lve@guap.ru>, Thierry Reding <thierry.reding@gmail.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>
Subject: [PATCH net-next] em_ipset: use dev_net() accessor
Message-ID: <20131016172934.7913a297@nehalam.linuxnetplumber.net>
In-Reply-To: <525F2D7D.7010708@infradead.org>
References: <1381949500-501-1-git-send-email-treding@nvidia.com>
	<525F09B0.4080802@infradead.org>
	<20131016153949.5f2257b4@nehalam.linuxnetplumber.net>
	<525F2D7D.7010708@infradead.org>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy found that if network namespace not enabled then
nd_net does not exist and would cause compilation failure.

This is handled correctly by using the dev_net() macro.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org>


--- a/net/sched/em_ipset.c	2013-10-06 14:48:25.030449222 -0700
+++ b/net/sched/em_ipset.c	2013-10-16 15:38:05.030278287 -0700
@@ -24,7 +24,7 @@ static int em_ipset_change(struct tcf_pr
 {
 	struct xt_set_info *set = data;
 	ip_set_id_t index;
-	struct net *net = qdisc_dev(tp->q)->nd_net;
+	struct net *net = dev_net(qdisc_dev(tp->q));
 
 	if (data_len != sizeof(*set))
 		return -EINVAL;
@@ -46,7 +46,7 @@ static void em_ipset_destroy(struct tcf_
 {
 	const struct xt_set_info *set = (const void *) em->data;
 	if (set) {
-		ip_set_nfnl_put(qdisc_dev(p->q)->nd_net, set->index);
+		ip_set_nfnl_put(dev_net(qdisc_dev(p->q)), set->index);
 		kfree((void *) em->data);
 	}
 }

