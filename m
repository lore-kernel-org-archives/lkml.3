Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758150AbaJ3CIv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 22:08:51 -0400
Received: from mail-bn1bbn0104.outbound.protection.outlook.com ([157.56.111.104]:24092
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755837AbaJ3CIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 22:08:50 -0400
From: Liu Ying <Ying.Liu@freescale.com>
To: <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] devres: Improve grp->id setting logics in devres_open_group()
Date: Thu, 30 Oct 2014 09:58:19 +0800
Message-ID: <1414634299-18078-1-git-send-email-Ying.Liu@freescale.com>
X-Mailer: git-send-email 2.1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(4396001)(106466001)(107046002)(77156001)(21056001)(88136002)(31966008)(89996001)(36756003)(44976005)(105606002)(50986999)(95666004)(110136001)(50226001)(87936001)(87286001)(48376002)(2351001)(19580405001)(229853001)(104016003)(92566001)(50466002)(62966002)(86362001)(92726001)(104166001)(93916002)(19580395003)(6806004)(68736004)(80022003)(20776003)(85306004)(64706001)(99396003)(26826002)(102836001)(46102003)(47776003)(120916001)(76482002)(97736003)(85852003)(84676001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0628;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0628;
X-Forefront-PRVS: 038002787A
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Ying.Liu@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of setting grp->id directly with a temporary value and
then changing it if a certain condition meets, we may check
the condition first and then decide which value should be set
to grp->id.  This may save two lines of code and potentially
reduces a writing operation.

Signed-off-by: Liu Ying <Ying.Liu@freescale.com>
---
v1->v2:
* Fix a typo in the commit head line.

 drivers/base/devres.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/base/devres.c b/drivers/base/devres.c
index c8a53d1..39e1856 100644
--- a/drivers/base/devres.c
+++ b/drivers/base/devres.c
@@ -544,9 +544,7 @@ void * devres_open_group(struct device *dev, void *id, gfp_t gfp)
 	INIT_LIST_HEAD(&grp->node[1].entry);
 	set_node_dbginfo(&grp->node[0], "grp<", 0);
 	set_node_dbginfo(&grp->node[1], "grp>", 0);
-	grp->id = grp;
-	if (id)
-		grp->id = id;
+	grp->id = id ? id : grp;
 
 	spin_lock_irqsave(&dev->devres_lock, flags);
 	add_dr(dev, &grp->node[0]);
-- 
2.1.0

