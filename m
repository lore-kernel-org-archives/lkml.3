Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932246AbbAFCUd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 21:20:33 -0500
Received: from mail-bn1bon0062.outbound.protection.outlook.com ([157.56.111.62]:40880
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753822AbbAFCUT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 21:20:19 -0500
From: <thloh@altera.com>
To: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linus.walleij@linaro.org>, <gnurou@gmail.com>,
        <grant.likely@linaro.org>, <akpm@linux-foundation.org>,
        <davem@davemloft.net>, <gregkh@linuxfoundation.org>, <joe@perches.com>,
        <mchehab@osg.samsung.com>, <crope@iki.fi>,
        <linux-gpio@vger.kernel.org>
CC: <thloh.linux@gmail.com>, <thloh@altera.com>
Subject: [PATCH v9 1/2] drivers/gpio: Altera soft IP GPIO driver device tree binding
Date: Mon, 5 Jan 2015 18:19:32 -0800
Message-ID: <1420510773-24605-2-git-send-email-thloh@altera.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1420510773-24605-1-git-send-email-thloh@altera.com>
References: <1420510773-24605-1-git-send-email-thloh@altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
Authentication-Results: spf=softfail (sender IP is 66.35.236.227)
 smtp.mailfrom=thloh@altera.com; 
X-Forefront-Antispam-Report: CIP:66.35.236.227;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(189002)(199003)(19580405001)(19580395003)(76176999)(105596002)(84676001)(120916001)(50986999)(6806004)(99396003)(21056001)(86362001)(89996001)(87936001)(31966008)(42186005)(50226001)(4396001)(48376002)(50466002)(64706001)(20776003)(47776003)(92566001)(46102003)(86152002)(2201001)(229853001)(68736005)(33646002)(97736003)(36756003)(2950100001)(62966003)(106466001)(77156002)(107046002)(7099022)(921003)(2101003)(83996005)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB223;H:sj-itexedge03.altera.priv.altera.com;FPR:;SPF:SoftFail;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-DmarcAction: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005003);SRVR:BY2PR03MB223;
X-Forefront-PRVS: 0448A97BF2
X-OriginatorOrg: altera.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2015 02:20:15.6779
 (UTC)
X-MS-Exchange-CrossTenant-Id: fbd72e03-d4a5-4110-adce-614d51f2077a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=fbd72e03-d4a5-4110-adce-614d51f2077a;Ip=[66.35.236.227]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY2PR03MB223
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tien Hock Loh <thloh@altera.com>

Adds a new driver device tree binding for Altera soft GPIO IP

Signed-off-by: Tien Hock Loh <thloh@altera.com>
---
 .../devicetree/bindings/gpio/gpio-altera.txt       | 43 ++++++++++++++++++++++
 1 file changed, 43 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-altera.txt

diff --git a/Documentation/devicetree/bindings/gpio/gpio-altera.txt b/Documentation/devicetree/bindings/gpio/gpio-altera.txt
new file mode 100644
index 0000000..0af2f7c
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
+  GPIO device has. Ranges between 1-32. Optional and defaults to 32 if not
+  specified.
+
+Example:
+
+gpio_altr: gpio@0xff200000 {
+	compatible = "altr,pio-1.0";
+	reg = <0xff200000 0x10>;
+	interrupts = <0 45 4>;
+	altr,ngpio = <32>;
+	altr,interrupt-trigger = <IRQ_TYPE_EDGE_RISING>;
+	#gpio-cells = <1>;
+	gpio-controller;
+	#interrupt-cells = <1>;
+	interrupt-controller;
+};
-- 
1.7.11.GIT

