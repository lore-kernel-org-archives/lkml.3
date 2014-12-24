Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751840AbaLXI4W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 03:56:22 -0500
Received: from mail-by2on0088.outbound.protection.outlook.com ([207.46.100.88]:42315
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751790AbaLXI4U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 03:56:20 -0500
X-Greylist: delayed 1125 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Dec 2014 03:56:19 EST
From: <thloh@altera.com>
To: Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        "Ian Campbell" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Antti Palosaari <crope@iki.fi>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-gpio@vger.kernel.org>
CC: Dinh Nguyen <dinguyen@altera.com>, Tien Hock Loh <thloh@altera.com>
Subject: [PATCH v8 1/2] drivers/gpio: Altera soft IP GPIO driver device tree binding
Date: Wed, 24 Dec 2014 00:22:24 -0800
Message-ID: <1419409345-8297-2-git-send-email-thloh@altera.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1419409345-8297-1-git-send-email-thloh@altera.com>
References: <1419409345-8297-1-git-send-email-thloh@altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
Authentication-Results: spf=softfail (sender IP is 66.35.236.227)
 smtp.mailfrom=thloh@altera.com; 
X-Forefront-Antispam-Report: CIP:66.35.236.227;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(199003)(189002)(64706001)(46102003)(89996001)(105596002)(48376002)(47776003)(33646002)(62966003)(87936001)(19580405001)(50466002)(106466001)(120916001)(42186005)(20776003)(77156002)(6806004)(31966008)(19580395003)(4396001)(2950100001)(92566001)(2201001)(76176999)(50226001)(107046002)(86152002)(68736005)(84676001)(36756003)(229853001)(86362001)(21056001)(97736003)(50986999)(99396003)(7099022)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR03MB213;H:sj-itexedge03.altera.priv.altera.com;FPR:;SPF:SoftFail;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB213;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BLUPR03MB213;
X-Forefront-PRVS: 04359FAD81
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB213;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Dec 2014 08:22:45.1640
 (UTC)
X-MS-Exchange-CrossTenant-Id: fbd72e03-d4a5-4110-adce-614d51f2077a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=fbd72e03-d4a5-4110-adce-614d51f2077a;Ip=[66.35.236.227]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLUPR03MB213
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB519;
X-OriginatorOrg: altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tien Hock Loh <thloh@altera.com>

Adds a new driver device tree binding for Altera soft GPIO IP

Signed-off-by: Tien Hock Loh <thloh@altera.com>
---
 .../devicetree/bindings/gpio/gpio-altera.txt       |   43 ++++++++++++++++++++
 1 files changed, 43 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-altera.txt

diff --git a/Documentation/devicetree/bindings/gpio/gpio-altera.txt b/Documentation/devicetree/bindings/gpio/gpio-altera.txt
new file mode 100644
index 0000000..649fa02
--- /dev/null
+++ b/Documentation/devicetree/bindings/gpio/gpio-altera.txt
@@ -0,0 +1,43 @@
+Altera GPIO controller bindings
+
+Required properties:
+- compatible:
+  - "altr,pio-1.0"
+- reg: Physical base address and length of the controller's registers.
+- #gpio-cells : Should be 2
+  - The first cell is the gpio offset number.
+  - The second cell is reserved and is currently unused.
+- gpio-controller : Marks the device node as a GPIO controller.
+- interrupt-controller: Mark the device node as an interrupt controller
+- #interrupt-cells : Should be 1. The interrupt type is fixed in the hardware.
+  - The first cell is the GPIO offset number within the GPIO controller.
+- interrupts: Specify the interrupt.
+- altr,interrupt-trigger: Specifies the interrupt trigger type the GPIO
+  hardware is synthesized. This field is required if the Altera GPIO controller
+  used has IRQ enabled as the interrupt type is not software controlled,
+  but hardware synthesized. Required if GPIO is used as an interrupt
+  controller. The value is defined in <dt-bindings/interrupt-controller/irq.h>
+  Only the following flags are supported:
+    IRQ_TYPE_EDGE_RISING
+    IRQ_TYPE_EDGE_FALLING
+    IRQ_TYPE_EDGE_BOTH
+    IRQ_TYPE_LEVEL_HIGH
+
+Optional properties:
+- altr,ngpio: Width of the GPIO bank. This defines how many pins the
+  GPIO device has. Ranges between 1-32. Optional and defaults to 32 is not
+  specified.
+
+Example:
+
+gpio_altr: gpio@0xff200000 {
+	compatible = "altr,pio-1.0";
+	reg = <0xff200000 0x10>;
+	interrupts = <0 45 4>;
+	altr,ngpio = <32>;
+	altr,interrupt_trigger = <IRQ_TYPE_EDGE_RISING>;
+	#gpio-cells = <1>;
+	gpio-controller;
+	#interrupt-cells = <1>;
+	interrupt-controller;
+};
-- 
1.7.1

