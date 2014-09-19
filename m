Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758067AbaISVIZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 17:08:25 -0400
Received: from mail-by2on0084.outbound.protection.outlook.com ([207.46.100.84]:30528
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757740AbaISVIY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 17:08:24 -0400
From: <dinguyen@opensource.altera.com>
To: <a.zummo@towertech.it>
CC: <dinh.linux@gmail.com>, <rtc-linux@googlegroups.com>,
        <linux-kernel@vger.kernel.org>,
        Dinh Nguyen <dinguyen@opensource.altera.com>
Subject: [PATCH] drivers/rtc/rtc-pcf8563.c: fix warning
Date: Fri, 19 Sep 2014 16:04:40 -0500
Message-ID: <1411160680-3869-1-git-send-email-dinguyen@opensource.altera.com>
X-Mailer: git-send-email 2.0.3
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BN1PR08CA0025.namprd08.prod.outlook.com (10.242.217.153) To
 BN3PR0301MB1188.namprd03.prod.outlook.com (25.160.156.15)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0339F89554
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(199003)(189002)(81542003)(74662003)(79102003)(50986999)(46102003)(101416001)(81342003)(104166001)(74502003)(80022003)(89996001)(102836001)(19580405001)(19580395003)(85852003)(92726001)(86152002)(92566001)(83072002)(86362001)(93916002)(88136002)(83322001)(31966008)(76482002)(77982003)(87976001)(50226001)(99396002)(69596002)(62966002)(4396001)(64706001)(81156004)(42186005)(110136001)(107046002)(77156001)(50466002)(53416004)(21056001)(20776003)(47776003)(66066001)(77096002)(95666004)(97736003)(90102001)(229853001)(106356001)(2351001)(33646002)(105586002)(48376002)(85306004)(87286001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN3PR0301MB1188;H:linux-builds1.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dinh Nguyen <dinguyen@opensource.altera.com>

drivers/rtc/rtc-pcf8563.c: In function pfc8563_irq:
drivers/rtc/rtc-pcf8563.c:173:5: warning: pending may be used uninitialized
in this function [-Wmaybe-uninitialized]

Signed-off-by: Dinh Nguyen <dinguyen@opensource.altera.com>
---
 drivers/rtc/rtc-pcf8563.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-pcf8563.c b/drivers/rtc/rtc-pcf8563.c
index 5a197d9..29ba5e7 100644
--- a/drivers/rtc/rtc-pcf8563.c
+++ b/drivers/rtc/rtc-pcf8563.c
@@ -164,7 +164,7 @@ static irqreturn_t pcf8563_irq(int irq, void *dev_id)
 {
 	struct pcf8563 *pcf8563 = i2c_get_clientdata(dev_id);
 	int err;
-	char pending;
+	char pending = 0;
 
 	err = pcf8563_get_alarm_mode(pcf8563->client, NULL, &pending);
 	if (err < 0)
-- 
2.0.3

