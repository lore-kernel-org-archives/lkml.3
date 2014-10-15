Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751418AbaJOFW2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 01:22:28 -0400
Received: from mail-by2on0107.outbound.protection.outlook.com ([207.46.100.107]:60269
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751073AbaJOFW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 01:22:26 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <thierry.reding@gmail.com>, <linux-pwm@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH v2 1/3] pwm: ftm: fix one bug of wrong counting the use counter.
Date: Wed, 15 Oct 2014 13:21:33 +0800
Message-ID: <1413350495-40980-2-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 2.1.0.27.g96db324
In-Reply-To: <1413350495-40980-1-git-send-email-Li.Xiubo@freescale.com>
References: <1413350495-40980-1-git-send-email-Li.Xiubo@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(76482002)(50466002)(48376002)(50226001)(104166001)(93916002)(92726001)(92566001)(77156001)(36756003)(87286001)(21056001)(4396001)(99396003)(19580405001)(104016003)(44976005)(107046002)(6806004)(80022003)(95666004)(50986999)(46102003)(69596002)(106466001)(81156004)(31966008)(229853001)(85306004)(120916001)(97736003)(105606002)(26826002)(87936001)(102836001)(84676001)(76176999)(20776003)(68736004)(88136002)(47776003)(86362001)(89996001)(64706001)(85852003)(19580395003)(62966002);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB0619;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0619;
X-Forefront-PRVS: 0365C0E14B
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Li.Xiubo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No matter what times the FTM pwm is enabled, the use_count will
always be one.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 drivers/pwm/pwm-fsl-ftm.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/pwm/pwm-fsl-ftm.c b/drivers/pwm/pwm-fsl-ftm.c
index 0f2cc7e..1150598 100644
--- a/drivers/pwm/pwm-fsl-ftm.c
+++ b/drivers/pwm/pwm-fsl-ftm.c
@@ -299,7 +299,7 @@ static int fsl_counter_clock_enable(struct fsl_pwm_chip *fpc)
 {
 	int ret;
 
-	if (fpc->use_count != 0)
+	if (fpc->use_count++ != 0)
 		return 0;
 
 	/* select counter clock source */
@@ -316,8 +316,6 @@ static int fsl_counter_clock_enable(struct fsl_pwm_chip *fpc)
 		return ret;
 	}
 
-	fpc->use_count++;
-
 	return 0;
 }
 
-- 
2.1.0.27.g96db324

