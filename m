Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757578Ab3IHDTH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 23:19:07 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55959 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751788Ab3IHDSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 23:18:34 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Jiri Pirko" <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        "Dan Carpenter" <dan.carpenter@oracle.com>
Date: Sun, 08 Sep 2013 03:52:01 +0100
Message-ID: <lsq.1378608721.871442579@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [015/121] net_sched: info leak in atm_tc_dump_class()
In-Reply-To: <lsq.1378608720.401499712@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.51-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 8cb3b9c3642c0263d48f31d525bcee7170eedc20 ]

The "pvc" struct has a hole after pvc.sap_family which is not cleared.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/sched/sch_atm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sched/sch_atm.c b/net/sched/sch_atm.c
index e25e490..6e38ef0 100644
--- a/net/sched/sch_atm.c
+++ b/net/sched/sch_atm.c
@@ -606,6 +606,7 @@ static int atm_tc_dump_class(struct Qdisc *sch, unsigned long cl,
 		struct sockaddr_atmpvc pvc;
 		int state;
 
+		memset(&pvc, 0, sizeof(pvc));
 		pvc.sap_family = AF_ATMPVC;
 		pvc.sap_addr.itf = flow->vcc->dev ? flow->vcc->dev->number : -1;
 		pvc.sap_addr.vpi = flow->vcc->vpi;

