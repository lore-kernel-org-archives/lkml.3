Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109AbaLXIg4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 03:36:56 -0500
Received: from mail-bl2on0129.outbound.protection.outlook.com ([65.55.169.129]:39168
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752012AbaLXIgx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 03:36:53 -0500
From: Liu Ying <Ying.Liu@freescale.com>
To: <dri-devel@lists.freedesktop.org>
CC: <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux@arm.linux.org.uk>, <kernel@pengutronix.de>,
        <p.zabel@pengutronix.de>, <thierry.reding@gmail.com>,
        <shawn.guo@linaro.org>, <mturquette@linaro.org>, <airlied@linux.ie>,
        <andyshrk@gmail.com>, <stefan.wahren@i2se.com>, <a.hajda@samsung.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH RFC v5 15/21] Documentation: dt-bindings: Add bindings for Himax HX8369A DRM panel driver
Date: Wed, 24 Dec 2014 16:39:37 +0800
Message-ID: <1419410383-6359-16-git-send-email-Ying.Liu@freescale.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1419410383-6359-1-git-send-email-Ying.Liu@freescale.com>
References: <1419410383-6359-1-git-send-email-Ying.Liu@freescale.com>
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Ying.Liu@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(339900001)(189002)(199003)(107046002)(106466001)(99396003)(2351001)(21056001)(89996001)(2950100001)(85426001)(36756003)(31966008)(87936001)(50986999)(86362001)(97736003)(62966003)(110136001)(105606002)(77156002)(229853001)(4396001)(68736005)(77096005)(120916001)(46102003)(50226001)(19580395003)(19580405001)(50466002)(92566001)(20776003)(76176999)(64706001)(84676001)(47776003)(104016003)(48376002)(6806004)(217873001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0625;H:tx30smr01.am.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0625;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BN1PR0301MB0625;
X-Forefront-PRVS: 04359FAD81
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0625;
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Dec 2014 08:36:50.5814
 (UTC)
X-MS-Exchange-CrossTenant-Id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=710a03f5-10f6-4d38-9ff4-a80b81da590d;Ip=[192.88.168.50]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN1PR0301MB0625
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds device tree bindings for Himax HX8369A DRM panel driver.

Signed-off-by: Liu Ying <Ying.Liu@freescale.com>
---
v4->v5:
 * Merge the bs[3:0]-gpios properties into one property - bs-gpios.
   This addresses Andrzej Hajda's comment.

v3->v4:
 * Newly introduced in v4.  This is separated from the relevant driver patch
   in v3 to address Stefan Wahren's comment.

 .../devicetree/bindings/panel/himax,hx8369a.txt    | 39 ++++++++++++++++++++++
 1 file changed, 39 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/panel/himax,hx8369a.txt

diff --git a/Documentation/devicetree/bindings/panel/himax,hx8369a.txt b/Documentation/devicetree/bindings/panel/himax,hx8369a.txt
new file mode 100644
index 0000000..3a44b70
--- /dev/null
+++ b/Documentation/devicetree/bindings/panel/himax,hx8369a.txt
@@ -0,0 +1,39 @@
+Himax HX8369A WVGA 16.7M color TFT single chip driver with internal GRAM
+
+Himax HX8369A is a WVGA resolution driving controller.
+It is designed to provide a single chip solution that combines a source
+driver and power supply circuits to drive a TFT dot matrix LCD with
+480RGBx864 dots at the maximum.
+
+The HX8369A supports several interface modes, including MPU MIPI DBI Type
+A/B mode, MIPI DPI/DBI Type C mode, MIPI DSI video mode, MIPI DSI command
+mode and MDDI mode. The interface mode is selected by the external hardware
+pins BS[3:0].
+
+Currently, only the MIPI DSI video mode is supported.
+
+Required properties:
+  - compatible: should be a panel's compatible string
+  - reg: the virtual channel number of a DSI peripheral, as described in [1]
+  - reset-gpios: a GPIO spec for the reset pin, as described in [2]
+
+Optional properties:
+  - vdd1-supply: I/O and interface power supply
+  - vdd2-supply: analog power supply
+  - vdd3-supply: logic power supply
+  - dsi-vcc-supply: DSI and MDDI power supply
+  - vpp-supply: OTP programming voltage
+  - bs-gpios: a GPIO spec for the pins BS[3:0], as described in [2]
+
+[1] Documentation/devicetree/bindings/mipi/dsi/mipi-dsi-bus.txt
+[2] Documentation/devicetree/bindings/gpio/gpio.txt
+
+Example:
+	panel {
+		compatible = "truly,tft480800-16-e-dsi";
+		reg = <0>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&pinctrl_mipi_panel>;
+		reset-gpios = <&gpio6 11 GPIO_ACTIVE_LOW>;
+		bs-gpios = <0>, <0>, <&gpio6 14 GPIO_ACTIVE_HIGH>, <0>;
+	};
-- 
2.1.0

