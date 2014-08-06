Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504AbaHFDtP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 23:49:15 -0400
Received: from dns-bn1lp0143.outbound.protection.outlook.com ([207.46.163.143]:41248
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751961AbaHFDtN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 23:49:13 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <wsa@the-dreams.de>, <linux-i2c@vger.kernel.org>, <joe@perches.com>
CC: <s.hauer@pengutronix.de>, <jg1.han@samsung.com>,
        <u.kleine-koenig@pengutronix.de>, <linux-kernel@vger.kernel.org>,
        <b35083@freescale.com>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCHv2] i2c: i2c-imx: Fix format warning for dev_dbg
Date: Wed, 6 Aug 2014 11:45:08 +0800
Message-ID: <1407296708-12563-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.5
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199002)(189002)(69596002)(104016003)(79102001)(102836001)(68736004)(77982001)(2201001)(92726001)(92566001)(50466002)(44976005)(89996001)(88136002)(85852003)(83072002)(50986999)(87936001)(74662001)(74502001)(107046002)(81542001)(229853001)(95666004)(21056001)(46102001)(26826002)(31966008)(47776003)(76482001)(81342001)(85306004)(36756003)(93916002)(86362001)(105606002)(81156004)(6806004)(64706001)(106466001)(77156001)(50226001)(62966002)(84676001)(99396002)(20776003)(104166001)(19580405001)(83322001)(48376002)(87286001)(19580395003)(80022001)(97736001)(4396001);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR03MB477;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02951C14DC
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Li.Xiubo@freescale.com; 
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

Change in v2:
- Follow Joe Perches's advice.





 drivers/i2c/busses/i2c-imx.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/i2c/busses/i2c-imx.c b/drivers/i2c/busses/i2c-imx.c
index 1d7efa3..b8a9543 100644
--- a/drivers/i2c/busses/i2c-imx.c
+++ b/drivers/i2c/busses/i2c-imx.c
@@ -686,10 +686,7 @@ static int i2c_imx_probe(struct platform_device *pdev)
 	clk_disable_unprepare(i2c_imx->clk);
 
 	dev_dbg(&i2c_imx->adapter.dev, "claimed irq %d\n", irq);
-	dev_dbg(&i2c_imx->adapter.dev, "device resources from 0x%x to 0x%x\n",
-		res->start, res->end);
-	dev_dbg(&i2c_imx->adapter.dev, "allocated %d bytes at 0x%x\n",
-		resource_size(res), res->start);
+	dev_dbg(&i2c_imx->adapter.dev, "device resources: %pR\n", res);
 	dev_dbg(&i2c_imx->adapter.dev, "adapter name: \"%s\"\n",
 		i2c_imx->adapter.name);
 	dev_info(&i2c_imx->adapter.dev, "IMX I2C adapter registered\n");
-- 
1.8.5

