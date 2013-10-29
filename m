Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525Ab3J2SFU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 14:05:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59307 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973Ab3J2SFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 14:05:16 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Vimalkumar <j.vimal@gmail.com>, Eric Dumazet <edumazet@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Jiri Pirko <jpirko@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 34/81] net_sched: htb: fix a typo in htb_change_class()
Date: Tue, 29 Oct 2013 11:03:55 -0700
Message-Id: <1383069882-11437-35-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383069882-11437-1-git-send-email-kamal@canonical.com>
References: <1383069882-11437-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vimalkumar <j.vimal@gmail.com>

[ Upstream commit f3ad857e3da1abaea780dc892b592cd86c541c52 ]

Fix a typo added in commit 56b765b79 ("htb: improved accuracy at high
rates")

cbuffer should not be a copy of buffer.

Signed-off-by: Vimalkumar <j.vimal@gmail.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Jiri Pirko <jpirko@redhat.com>
Reviewed-by: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: David S. Miller <davem@davemloft.net>
[ kamal: backport to 3.8 ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/sched/sch_htb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index 8ea8a79..ef085f1 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -1513,7 +1513,7 @@ static int htb_change_class(struct Qdisc *sch, u32 classid,
 	htb_precompute_ratedata(&cl->ceil);
 
 	cl->buffer = hopt->buffer << PSCHED_SHIFT;
-	cl->cbuffer = hopt->buffer << PSCHED_SHIFT;
+	cl->cbuffer = hopt->cbuffer << PSCHED_SHIFT;
 
 	sch_tree_unlock(sch);
 
-- 
1.8.1.2

