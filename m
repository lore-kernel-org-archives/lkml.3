Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191AbaLITAc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 14:00:32 -0500
Received: from mail-qg0-f53.google.com ([209.85.192.53]:60894 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043AbaLITAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 14:00:30 -0500
MIME-Version: 1.0
In-Reply-To: <9914.1418151288@turing-police.cc.vt.edu>
References: <6468.1418147500@turing-police.cc.vt.edu>
	<CANn89iJAN815z3TefSjj0uZyQQyH-wTiAckt3WeMc-F7DRgpKA@mail.gmail.com>
	<9914.1418151288@turing-police.cc.vt.edu>
Date: Tue, 9 Dec 2014 11:00:29 -0800
Message-ID: <CANn89i+fLqXT2J-98UhC8x9sZCF1kh-twvZ2FXEAgOgKS5-oYg@mail.gmail.com>
Subject: Re: linux-next 20141208 - net/sched/sch_fq_codel.c:97 suspicious RCU
From: Eric Dumazet <edumazet@google.com>
To: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Cc: John Fastabend <john.r.fastabend@intel.com>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 9, 2014 at 10:54 AM,  <Valdis.Kletnieks@vt.edu> wrote:

> You want a patch, or you got it already?
>

If you could submit it formally, this would be great , thanks !

diff --git a/net/sched/sch_fq_codel.c b/net/sched/sch_fq_codel.c
index b9ca32ebc1de..1e52decb7b59 100644
--- a/net/sched/sch_fq_codel.c
+++ b/net/sched/sch_fq_codel.c
@@ -94,7 +94,7 @@ static unsigned int fq_codel_classify(struct sk_buff
*skb, struct Qdisc *sch,
            TC_H_MIN(skb->priority) <= q->flows_cnt)
                return TC_H_MIN(skb->priority);

-       filter = rcu_dereference(q->filter_list);
+filter = rcu_dereference_bh(q->filter_list);
        if (!filter)
                return fq_codel_hash(q, skb) + 1;
