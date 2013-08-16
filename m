Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077Ab3HPWiA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 18:38:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51482 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755994Ab3HPWh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:37:56 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 130/133] net_sched: info leak in atm_tc_dump_class()
Date: Fri, 16 Aug 2013 15:34:32 -0700
Message-Id: <1376692475-28413-131-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376692475-28413-1-git-send-email-kamal@canonical.com>
References: <1376692475-28413-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 8cb3b9c3642c0263d48f31d525bcee7170eedc20 ]

The "pvc" struct has a hole after pvc.sap_family which is not cleared.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/sched/sch_atm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sched/sch_atm.c b/net/sched/sch_atm.c
index ca8e0a5..1f9c314 100644
--- a/net/sched/sch_atm.c
+++ b/net/sched/sch_atm.c
@@ -605,6 +605,7 @@ static int atm_tc_dump_class(struct Qdisc *sch, unsigned long cl,
 		struct sockaddr_atmpvc pvc;
 		int state;
 
+		memset(&pvc, 0, sizeof(pvc));
 		pvc.sap_family = AF_ATMPVC;
 		pvc.sap_addr.itf = flow->vcc->dev ? flow->vcc->dev->number : -1;
 		pvc.sap_addr.vpi = flow->vcc->vpi;
-- 
1.8.1.2

