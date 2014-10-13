Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476AbaJMC3e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 22:29:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46018 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754415AbaJMC31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 22:29:27 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.16 44/55] net_sched: copy exts->type in tcf_exts_change()
Date: Mon, 13 Oct 2014 04:24:58 +0200
Message-Id: <20141013022445.782526978@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141013022443.729870634@linuxfoundation.org>
References: <20141013022443.729870634@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: WANG Cong <xiyou.wangcong@gmail.com>

[ Upstream commit 5301e3e117d88ef0967ce278912e54757f1a31a2 ]

We need to copy exts->type when committing the change, otherwise
it would be always 0. This is a quick fix for -net and -stable,
for net-next tcf_exts will be removed.

Fixes: commit 33be627159913b094bb578e83 ("net_sched: act: use standard struct list_head")
Reported-by: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/cls_api.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -549,6 +549,7 @@ void tcf_exts_change(struct tcf_proto *t
 	tcf_tree_lock(tp);
 	list_splice_init(&dst->actions, &tmp);
 	list_splice(&src->actions, &dst->actions);
+	dst->type = src->type;
 	tcf_tree_unlock(tp);
 	tcf_action_destroy(&tmp, TCA_ACT_UNBIND);
 #endif


