Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883AbaCNQoM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 12:44:12 -0400
Received: from mail-bl2on0141.outbound.protection.outlook.com ([65.55.169.141]:2741
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753644AbaCNQoK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 12:44:10 -0400
From: Alan Tull <delicious.quinoa@gmail.com>
To: Linus Walleij <linus.walleij@linaro.com>
CC: Rob Herring <robh+dt@kernel.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        "Josh Cartwright" <joshc@codeaurora.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-gpio@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, Jamie Iles <jamie@jamieiles.com>,
        "Steffen Trumtrar" <s.trumtrar@pengutronix.de>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>, "Kumar Gala" <galak@codeaurora.org>,
        Rob Landley <rob@landley.net>, Alan Tull <atull@altera.com>,
        delicious quinoa <delicious.quinoa@gmail.com>,
        "Dinh Nguyen" <dinguyen@altera.com>,
        Yves Vandervennet <rocket.yvanderv@gmail.com>
Subject: [PATCH] gpio: gpio-dwapb size-cells should be two
Date: Fri, 14 Mar 2014 11:08:54 -0500
Message-ID: <1394813334-22549-1-git-send-email-delicious.quinoa@gmail.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Matching-Connectors: 130392870882817992;(6c7e1f6d-ea3d-4e34-ed1d-08d0e4b1def8);()
X-Forefront-Antispam-Report: =?us-ascii?Q?CIP:66.35.236.232;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(1001?=
 =?us-ascii?Q?9001)(6009001)(458001)(37524003)(189002)(199002)(93916002)(9?=
 =?us-ascii?Q?5416001)(93516002)(94316002)(74366001)(86362001)(92566001)(3?=
 =?us-ascii?Q?1966008)(74662001)(89996001)(73972005)(47446002)(69226001)(7?=
 =?us-ascii?Q?4502001)(85306002)(94946001)(74876001)(87266001)(81816001)(8?=
 =?us-ascii?Q?2202001)(55446002)(93136001)(76796001)(50466002)(95666003)(6?=
 =?us-ascii?Q?5816001)(48376002)(80976001)(56816005)(87286001)(73392001)(4?=
 =?us-ascii?Q?4976005)(81542001)(88136002)(79102001)(97336001)(59766001)(8?=
 =?us-ascii?Q?7936001)(19580395003)(85852003)(81442001)(53806001)(47736001?=
 =?us-ascii?Q?)(50986001)(77096001)(56776001)(54316002)(49866001)(61266001?=
 =?us-ascii?Q?)(77982001)(36756003)(97186001)(19580405001)(20776003)(76176?=
 =?us-ascii?Q?001)(47776003)(33646001)(62966002)(76786001)(46102001)(92726?=
 =?us-ascii?Q?001)(81686001)(81342001)(50226001)(63696002)(80022001)(47976?=
 =?us-ascii?Q?001)(4396001)(51856001)(83072002)(6806004)(90146001)(7470600?=
 =?us-ascii?Q?1)(77156001)(53416003)(42262001);DIR:OUT;SFP:1102;SCL:1;SRVR?=
 =?us-ascii?Q?:BN1AFFO11HUB065;H:SJ-ITEXEDGE02.altera.priv.altera.com;CLIP?=
 =?us-ascii?Q?:66.35.236.232;FPR:DD90EA7C.2088262B.4356AA37.48C7E229.2018B?=
 =?us-ascii?Q?;MLV:nov;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;?=
X-Forefront-PRVS: 0150F3F97D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Tull <atull@altera.com>

Fix size-cells to show use of OF_GPIO_ACTIVE_LOW flag.

Signed-off-by: Alan Tull <atull@altera.com>
---
 .../devicetree/bindings/gpio/snps-dwapb-gpio.txt   |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/gpio/snps-dwapb-gpio.txt b/Documentation/devicetree/bindings/gpio/snps-dwapb-gpio.txt
index 0934950..91cc90c 100644
--- a/Documentation/devicetree/bindings/gpio/snps-dwapb-gpio.txt
+++ b/Documentation/devicetree/bindings/gpio/snps-dwapb-gpio.txt
@@ -12,7 +12,10 @@ represented as child nodes with the following properties:
 Required properties:
 - compatible : "snps,dw-apb-gpio-port"
 - gpio-controller : Marks the device node as a gpio controller.
-- #gpio-cells : Should be 1.  It is the pin number.
+- #gpio-cells : Should be two.  The first cell is the pin number and
+  the second cell is used to specify the gpio polarity:
+      0 = active high
+      1 = active low
 - reg : The integer port index of the port, a single cell.
 
 Optional properties:
-- 
1.7.9.5

