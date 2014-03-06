Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227AbaCFUEO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 15:04:14 -0500
Received: from mail-bl2on0121.outbound.protection.outlook.com ([65.55.169.121]:58503
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753106AbaCFUEK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 15:04:10 -0500
From: Alan Tull <delicious.quinoa@gmail.com>
To: Linus Walleij <linus.walleij@linaro.com>
CC: Josh Cartwright <joshc@codeaurora.org>, <linux-kernel@vger.kernel.org>,
        <linux-gpio@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        Jamie Iles <jamie@jamieiles.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mark Rutland <mark.rutland@arm.com>,
        "Steffen Trumtrar" <s.trumtrar@pengutronix.de>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        delicious quinoa <delicious.quinoa@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>, Alan Tull <atull@altera.com>,
        Dinh Nguyen <dinguyen@altera.com>,
        Yves Vandervennet <rocket.yvanderv@gmail.com>
Subject: [PATCH] fix build error in gpio-dwapb patch
Date: Thu, 6 Mar 2014 13:29:40 -0600
Message-ID: <1394134180-23208-1-git-send-email-delicious.quinoa@gmail.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Matching-Connectors: 130386079321713565;(6c7e1f6d-ea3d-4e34-ed1d-08d0e4b1def8);()
X-Forefront-Antispam-Report: =?us-ascii?Q?CIP:66.35.236.232;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(1001?=
 =?us-ascii?Q?9001)(6009001)(458001)(189002)(199002)(56776001)(61266001)(4?=
 =?us-ascii?Q?7776003)(63696002)(20776003)(77982001)(59766001)(76176001)(3?=
 =?us-ascii?Q?1966008)(54316002)(74662001)(33646001)(74502001)(47446002)(7?=
 =?us-ascii?Q?9102001)(81816001)(36756003)(73392001)(87286001)(76786001)(8?=
 =?us-ascii?Q?1686001)(82202001)(53416003)(76796001)(80976001)(19580405001?=
 =?us-ascii?Q?)(87936001)(97186001)(19580395003)(85306002)(44976005)(97336?=
 =?us-ascii?Q?001)(47736001)(47976001)(74876001)(87266001)(81342001)(94946?=
 =?us-ascii?Q?001)(73972005)(93516002)(86362001)(81442001)(69226001)(95666?=
 =?us-ascii?Q?003)(95416001)(49866001)(83072002)(51856001)(81542001)(74706?=
 =?us-ascii?Q?001)(85852003)(46102001)(65816001)(62966002)(6806004)(899960?=
 =?us-ascii?Q?01)(56816005)(90146001)(88136002)(55446002)(92566001)(502260?=
 =?us-ascii?Q?01)(53806001)(77096001)(48376002)(50466002)(92726001)(439600?=
 =?us-ascii?Q?1)(93136001)(93916002)(50986001)(77156001)(74366001)(8002200?=
 =?us-ascii?Q?1)(94316002)(42262001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1AFFO11?=
 =?us-ascii?Q?HUB049;H:SJ-ITEXEDGE02.altera.priv.altera.com;CLIP:66.35.236?=
 =?us-ascii?Q?.232;FPR:A715541E.8007CCC9.93F5AFB2.AF62BE61.2014F;MLV:sfv;P?=
 =?us-ascii?Q?TR:InfoDomainNonexistent;MX:1;A:1;LANG:en;?=
X-OriginatorOrg: altera.onmicrosoft.com
X-Forefront-PRVS: 0142F22657
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Tull <atull@altera.com>

fix build error with this message:
kernel/irq/Kconfig:41:error: recursive dependency detected!
kernel/irq/Kconfig:41:  symbol GENERIC_IRQ_CHIP is selected by GPIO_DWAPB
drivers/gpio/Kconfig:131:       symbol GPIO_DWAPB depends on IRQ_DOMAIN
kernel/irq/Kconfig:46:  symbol IRQ_DOMAIN is selected by GENERIC_IRQ_CHIP

Signed-off-by: Alan Tull <atull@altera.com>
---
 drivers/gpio/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 9979017..0e524d7 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -132,7 +132,7 @@ config GPIO_DWAPB
 	tristate "Synopsys DesignWare APB GPIO driver"
 	select GPIO_GENERIC
 	select GENERIC_IRQ_CHIP
-	depends on OF_GPIO && IRQ_DOMAIN
+	depends on OF_GPIO
 	help
 	  Say Y or M here to build support for the Synopsys DesignWare APB
 	  GPIO block.
-- 
1.7.9.5

