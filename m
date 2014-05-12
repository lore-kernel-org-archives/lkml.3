Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513AbaELBoD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 21:44:03 -0400
Received: from 1wt.eu ([62.212.114.60]:34755 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754372AbaELBn4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:43:56 -0400
Message-Id: <20140512003203.253098331@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:33:03 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>, Willy Tarreau <w@1wt.eu>
Subject: [ 063/143] net_sched: info leak in atm_tc_dump_class()
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 8cb3b9c3642c0263d48f31d525bcee7170eedc20 ]

The "pvc" struct has a hole after pvc.sap_family which is not cleared.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/sched/sch_atm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sched/sch_atm.c b/net/sched/sch_atm.c
index ab82f14..b022c59 100644
--- a/net/sched/sch_atm.c
+++ b/net/sched/sch_atm.c
@@ -628,6 +628,7 @@ static int atm_tc_dump_class(struct Qdisc *sch, unsigned long cl,
 		struct sockaddr_atmpvc pvc;
 		int state;
 
+		memset(&pvc, 0, sizeof(pvc));
 		pvc.sap_family = AF_ATMPVC;
 		pvc.sap_addr.itf = flow->vcc->dev ? flow->vcc->dev->number : -1;
 		pvc.sap_addr.vpi = flow->vcc->vpi;
-- 
1.7.12.2.21.g234cd45.dirty



