Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932367AbaJ2KKw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 06:10:52 -0400
Received: from mail-bn1on0144.outbound.protection.outlook.com ([157.56.110.144]:35184
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756329AbaJ2KKo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 06:10:44 -0400
X-Greylist: delayed 878 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Oct 2014 06:10:44 EDT
From: Liu Ying <Ying.Liu@freescale.com>
To: <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>
Subject: [PATCH] drvres: Improve grp->id setting logics in devres_open_group()
Date: Wed, 29 Oct 2014 17:59:47 +0800
Message-ID: <1414576787-2074-1-git-send-email-Ying.Liu@freescale.com>
X-Mailer: git-send-email 2.1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(46102003)(92566001)(4396001)(80022003)(93916002)(86362001)(87286001)(88136002)(97736003)(77156001)(85306004)(84676001)(92726001)(87936001)(110136001)(50226001)(99396003)(68736004)(50986999)(120916001)(85852003)(76482002)(89996001)(19580395003)(44976005)(104016003)(6806004)(19580405001)(20776003)(47776003)(62966002)(106466001)(21056001)(104166001)(64706001)(31966008)(229853001)(36756003)(102836001)(26826002)(50466002)(107046002)(95666004)(105606002)(2351001)(48376002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0632;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0632;
X-Forefront-PRVS: 03793408BA
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

