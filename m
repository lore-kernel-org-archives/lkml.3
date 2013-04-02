Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933573Ab3DBWNT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 18:13:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33307 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933486Ab3DBWNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:13:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Vijay Subramanian <subramanian.vijay@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 122/124] net: fq_codel: Fix off-by-one error
Date: Tue,  2 Apr 2013 15:11:44 -0700
Message-Id: <20130402221118.334999450@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130402221104.163133110@linuxfoundation.org>
References: <20130402221104.163133110@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Vijay Subramanian <subramanian.vijay@gmail.com>

[ Upstream commit cd68ddd4c29ab523440299f24ff2417fe7a0dca6 ]

Currently, we hold a max of sch->limit -1 number of packets instead of
sch->limit packets. Fix this off-by-one error.

Signed-off-by: Vijay Subramanian <subramanian.vijay@gmail.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_fq_codel.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sched/sch_fq_codel.c
+++ b/net/sched/sch_fq_codel.c
@@ -195,7 +195,7 @@ static int fq_codel_enqueue(struct sk_bu
 		flow->deficit = q->quantum;
 		flow->dropped = 0;
 	}
-	if (++sch->q.qlen < sch->limit)
+	if (++sch->q.qlen <= sch->limit)
 		return NET_XMIT_SUCCESS;
 
 	q->drop_overlimit++;


