Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756813Ab3KAWXI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 18:23:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55366 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756242Ab3KAWIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 18:08:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?=D0=A1=D0=B5=D1=80=D0=B3=D0=B5=D0=B5=D0=B2=20=D0=A1=D0=B5=D1=80=D0=B3=D0=B5=D0=B9?= 
	<adron@yapic.net>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.11 26/66] netem: update backlog after drop
Date: Fri,  1 Nov 2013 15:07:02 -0700
Message-Id: <20131101220642.010268933@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131101220634.605745564@linuxfoundation.org>
References: <20131101220634.605745564@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: stephen hemminger <stephen@networkplumber.org>

[ Upstream commit 638a52b801e40ed276ceb69b73579ad99365361a ]

When packet is dropped from rb-tree netem the backlog statistic should
also be updated.

Reported-by: Сергеев Сергей <adron@yapic.net>
Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_netem.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -523,6 +523,7 @@ static unsigned int netem_drop(struct Qd
 			skb->next = NULL;
 			skb->prev = NULL;
 			len = qdisc_pkt_len(skb);
+			sch->qstats.backlog -= len;
 			kfree_skb(skb);
 		}
 	}


