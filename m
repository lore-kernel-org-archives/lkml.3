Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757935AbaFTUe7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 16:34:59 -0400
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:19471 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750747AbaFTUe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 16:34:57 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsHANaZpFNXQzOZ/2dsb2JhbABZgw2rRwUBAQEBAQEFAZkqgQ4XdYRgI4EaN4hGAcowF4ViiRQdhC0EmkSLMIgqg0Q7
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH 1/1] net/sched/cls_bpf.c: remove null test before kfree
Date: Fri, 20 Jun 2014 22:33:27 +0200
Message-Id: <1403296407-5877-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch warning:
WARNING: kfree(NULL) is safe this check is probably not required

Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 net/sched/cls_bpf.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/sched/cls_bpf.c b/net/sched/cls_bpf.c
index 13f64df..715367a 100644
--- a/net/sched/cls_bpf.c
+++ b/net/sched/cls_bpf.c
@@ -212,8 +212,7 @@ static int cls_bpf_modify_existing(struct net *net, struct tcf_proto *tp,
 
 	if (fp_old)
 		sk_unattached_filter_destroy(fp_old);
-	if (bpf_old)
-		kfree(bpf_old);
+	kfree(bpf_old);
 
 	return 0;
 
-- 
1.8.4.5

