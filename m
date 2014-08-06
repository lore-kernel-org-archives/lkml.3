Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753697AbaHFDCN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 23:02:13 -0400
Received: from mail-by2lp0239.outbound.protection.outlook.com ([207.46.163.239]:5276
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750922AbaHFDCL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 23:02:11 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <wsa@the-dreams.de>, <linux-i2c@vger.kernel.org>
CC: <s.hauer@pengutronix.de>, <jg1.han@samsung.com>,
        <u.kleine-koenig@pengutronix.de>, <linux-kernel@vger.kernel.org>,
        <b35083@freescale.com>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH] i2c: i2c-imx: Fix format warning for dev_dbg
Date: Wed, 6 Aug 2014 10:54:45 +0800
Message-ID: <1407293685-7003-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.5
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199002)(189002)(79102001)(50986999)(50466002)(68736004)(83322001)(19580405001)(46102001)(44976005)(6806004)(80022001)(74502001)(74662001)(87936001)(62966002)(31966008)(69596002)(19580395003)(89996001)(20776003)(76482001)(81342001)(47776003)(81542001)(77982001)(36756003)(64706001)(77156001)(4396001)(99396002)(88136002)(97736001)(50226001)(83072002)(92726001)(92566001)(93916002)(86362001)(229853001)(26826002)(104016003)(106466001)(104166001)(107046002)(102836001)(21056001)(81156004)(85852003)(105606002)(95666004)(85306004)(84676001)(48376002)(87286001);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB468;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02951C14DC
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Li.Xiubo@freescale.com; 
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/i2c/busses/i2c-imx.c: In function i2c_imx_probe()
drivers/i2c/busses/i2c-imx.c:689:2: warning: format 0x%x expects argument
of type unsigned int, but argument 4 has type resource_size_t [-Wformat=]
  dev_dbg(&i2c_imx->adapter.dev, "device resources from 0x%x to 0x%x\n",
  ^
drivers/i2c/busses/i2c-imx.c:689:2: warning: format 0x%x expects argument
of type unsigned int, but argument 5 has type resource_size_t [-Wformat=]

drivers/i2c/busses/i2c-imx.c:691:2: warning: format %d expects argument
of type int, but argument 4 has type resource_size_t [-Wformat=]
  dev_dbg(&i2c_imx->adapter.dev, "allocated %d bytes at 0x%x\n",
  ^
drivers/i2c/busses/i2c-imx.c:691:2: warning: format 0x%x expects argument
of type unsigned int, but argument 5 has type resource_size_t [-Wformat=]

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 drivers/i2c/busses/i2c-imx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-imx.c b/drivers/i2c/busses/i2c-imx.c
index 1d7efa3..ba4ba32 100644
--- a/drivers/i2c/busses/i2c-imx.c
+++ b/drivers/i2c/busses/i2c-imx.c
@@ -687,9 +687,9 @@ static int i2c_imx_probe(struct platform_device *pdev)
 
 	dev_dbg(&i2c_imx->adapter.dev, "claimed irq %d\n", irq);
 	dev_dbg(&i2c_imx->adapter.dev, "device resources from 0x%x to 0x%x\n",
-		res->start, res->end);
+		(unsigned int)res->start, (unsigned int)res->end);
 	dev_dbg(&i2c_imx->adapter.dev, "allocated %d bytes at 0x%x\n",
-		resource_size(res), res->start);
+		(unsigned int)resource_size(res), (unsigned int)res->start);
 	dev_dbg(&i2c_imx->adapter.dev, "adapter name: \"%s\"\n",
 		i2c_imx->adapter.name);
 	dev_info(&i2c_imx->adapter.dev, "IMX I2C adapter registered\n");
-- 
1.8.5

