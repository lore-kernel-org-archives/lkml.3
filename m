Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754951AbaJUJiL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 05:38:11 -0400
Received: from mail-by2on0124.outbound.protection.outlook.com ([207.46.100.124]:2784
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751688AbaJUJiI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 05:38:08 -0400
From: Jingchang Lu <jingchang.lu@freescale.com>
To: <gregkh@linuxfoundation.org>
CC: <josephl@nvidia.com>, <peter@hurleysoftware.com>, <arnd@arndb.de>,
        <linux-serial@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Jingchang Lu <jingchang.lu@freescale.com>
Subject: [PATCH] serial: of-serial: fix uninitialized kmalloc variable
Date: Tue, 21 Oct 2014 16:50:21 +0800
Message-ID: <1413881421-9554-1-git-send-email-jingchang.lu@freescale.com>
X-Mailer: git-send-email 1.8.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(31966008)(92726001)(93916002)(86362001)(92566001)(36756003)(107046002)(47776003)(76482002)(20776003)(99396003)(120916001)(64706001)(229853001)(105606002)(2351001)(62966002)(106466001)(97736003)(77156001)(95666004)(110136001)(33646002)(4396001)(102836001)(85852003)(87286001)(87936001)(89996001)(21056001)(44976005)(6806004)(104016003)(19580405001)(19580395003)(68736004)(48376002)(46102003)(50986999)(50466002)(88136002)(104166001)(80022003)(85306004)(26826002)(50226001)(84676001);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR03MB471;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB471;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0371762FE7
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=jingchang.lu@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The info pointer points to an uninitialized kmalloced space.
If a device doesn't have clk property, then info->clk may
have unpredicated value and cause call trace. So use kzalloc
to make sure it is NULL initialized.

Signed-off-by: Jingchang Lu <jingchang.lu@freescale.com>
---
 drivers/tty/serial/of_serial.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/of_serial.c b/drivers/tty/serial/of_serial.c
index 8bc2563..56982da4 100644
--- a/drivers/tty/serial/of_serial.c
+++ b/drivers/tty/serial/of_serial.c
@@ -158,7 +158,7 @@ static int of_platform_serial_probe(struct platform_device *ofdev)
 	if (of_find_property(ofdev->dev.of_node, "used-by-rtas", NULL))
 		return -EBUSY;
 
-	info = kmalloc(sizeof(*info), GFP_KERNEL);
+	info = kzalloc(sizeof(*info), GFP_KERNEL);
 	if (info == NULL)
 		return -ENOMEM;
 
-- 
1.8.0

