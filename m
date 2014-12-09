Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757913AbaLIQrj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 11:47:39 -0500
Received: from mail-bn1on0114.outbound.protection.outlook.com ([157.56.110.114]:16209
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757891AbaLIQrg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 11:47:36 -0500
From: Fabio Estevam <fabio.estevam@freescale.com>
To: <rafael.j.wysocki@intel.com>
CC: <cooloney@gmail.com>, <grant.likely@linaro.org>,
        <jean-michel.hautbois@vodalys.com>, <festevam@gmail.com>,
        <linux-leds@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] leds: leds-gpio: Fix the "default-state" property check
Date: Tue, 9 Dec 2014 14:31:54 -0200
Message-ID: <1418142714-29794-1-git-send-email-fabio.estevam@freescale.com>
X-Mailer: git-send-email 1.9.1
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(36756003)(77156002)(21056001)(77096005)(48376002)(110136001)(64706001)(20776003)(47776003)(50466002)(62966003)(68736005)(120916001)(99396003)(92566001)(86362001)(89996001)(81156004)(87936001)(107046002)(2351001)(50226001)(50986999)(104016003)(4396001)(31966008)(19580395003)(33646002)(229853001)(97736003)(46102003)(105606002)(69596002)(19580405001)(6806004)(106466001)(84676001);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2PR03MB244;H:az84smr01.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB244;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(602002);SRVR:BL2PR03MB244;
X-Forefront-PRVS: 0420213CCD
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Fabio.Estevam@freescale.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB244;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit a43f2cbbb009f9 ("leds: leds-gpio: Make use of device property API")
caused a regression by reading the incorrect string for the "default-state"
property.

Fix the property string check to restore the original behaviour.

Fixes: a43f2cbbb009 (leds: leds-gpio: Make use of device property API)
Reported-by: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/leds/leds-gpio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/leds/leds-gpio.c b/drivers/leds/leds-gpio.c
index 8a8ba11..7ea1ea42 100644
--- a/drivers/leds/leds-gpio.c
+++ b/drivers/leds/leds-gpio.c
@@ -203,7 +203,7 @@ static struct gpio_leds_priv *gpio_leds_create(struct platform_device *pdev)
 		fwnode_property_read_string(child, "linux,default-trigger",
 					    &led.default_trigger);
 
-		if (!fwnode_property_read_string(child, "linux,default_state",
+		if (!fwnode_property_read_string(child, "default-state",
 						 &state)) {
 			if (!strcmp(state, "keep"))
 				led.default_state = LEDS_GPIO_DEFSTATE_KEEP;
-- 
1.9.1

