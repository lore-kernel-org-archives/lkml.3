Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932383AbaFQIWy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 04:22:54 -0400
Received: from mail-bn1lp0139.outbound.protection.outlook.com ([207.46.163.139]:24876
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756032AbaFQIWw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 04:22:52 -0400
From: Liu Ying <Ying.Liu@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: <rmk+kernel@arm.linux.org.uk>, <gregkh@linuxfoundation.org>
Subject: [PATCH] drivers/base: redundant return value settings in try_to_bring_up_master()
Date: Tue, 17 Jun 2014 16:25:31 +0800
Message-ID: <1402993531-25244-1-git-send-email-Ying.Liu@freescale.com>
X-Mailer: git-send-email 1.7.9.5
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(979002)(6009001)(199002)(189002)(68736004)(99396002)(80022001)(69596002)(97736001)(84676001)(89996001)(19580405001)(83322001)(83072002)(85852003)(87286001)(19580395003)(88136002)(6806004)(87936001)(44976005)(79102001)(85306003)(20776003)(81156003)(47776003)(64706001)(50226001)(50466002)(104166001)(104016002)(95666004)(86362001)(92566001)(77156001)(48376002)(36756003)(26826002)(102836001)(21056001)(93916002)(92726001)(62966002)(74662001)(46102001)(77982001)(76482001)(4396001)(81542001)(74502001)(81342001)(31966008)(50986999)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR0301MB0638;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
X-Forefront-PRVS: 0245702D7B
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Ying.Liu@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove redundant return value settings 'ret = 0;' in the function
try_to_bring_up_master(), since it has already been set to zero.

Signed-off-by: Liu Ying <Ying.Liu@freescale.com>
---
 drivers/base/component.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/base/component.c b/drivers/base/component.c
index c477899..007600e 100644
--- a/drivers/base/component.c
+++ b/drivers/base/component.c
@@ -123,13 +123,11 @@ static int try_to_bring_up_master(struct master *master,
 		if (master->ops->add_components(master->dev, master)) {
 			/* Failed to find all components */
 			master_remove_components(master);
-			ret = 0;
 			goto out;
 		}
 
 		if (component && component->master != master) {
 			master_remove_components(master);
-			ret = 0;
 			goto out;
 		}
 
-- 
1.7.9.5

