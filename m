Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751148Ab3IFGrK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 02:47:10 -0400
Received: from co1ehsobe004.messaging.microsoft.com ([216.32.180.187]:19864
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750782Ab3IFGrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 02:47:08 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzc8kzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097h8275bhz2dh2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h1155h)
From: <hongbo.zhang@freescale.com>
To: <LCTBJ@freescale.com>
CC: <linux-kernel@vger.kernel.org>, Hongbo Zhang <hongbo.zhang@freescale.com>
Subject: [PATCH 2/2] fsl: set wakeup sources
Date: Fri, 6 Sep 2013 14:46:55 +0800
Message-ID: <1378450015-27607-1-git-send-email-hongbo.zhang@freescale.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hongbo Zhang <hongbo.zhang@freescale.com>

Some devices can work as wakeup sources, they should be powerred on during
system deep sleep, this patch adds interface for configuring devices power
supply status during deep sleep.

Signed-off-by: Hongbo Zhang <hongbo.zhang@freescale.com>
---
 arch/powerpc/boot/dts/fsl/qoriq-power.dtsi |   73 ++++++++++++++++++++++++++++
 arch/powerpc/sysdev/fsl_rcpm.c             |   43 ++++++++++++++++
 2 files changed, 116 insertions(+)
 create mode 100644 arch/powerpc/boot/dts/fsl/qoriq-power.dtsi

diff --git a/arch/powerpc/boot/dts/fsl/qoriq-power.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-power.dtsi
new file mode 100644
index 0000000..c5c2ba0
--- /dev/null
+++ b/arch/powerpc/boot/dts/fsl/qoriq-power.dtsi
@@ -0,0 +1,73 @@
+/*
+ * QorIQ Power Management device tree stub
+ *
+ * Copyright 2013 Freescale Semiconductor Inc.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions are met:
+ *     * Redistributions of source code must retain the above copyright
+ *       notice, this list of conditions and the following disclaimer.
+ *     * Redistributions in binary form must reproduce the above copyright
+ *       notice, this list of conditions and the following disclaimer in the
+ *       documentation and/or other materials provided with the distribution.
+ *     * Neither the name of Freescale Semiconductor nor the
+ *       names of its contributors may be used to endorse or promote products
+ *       derived from this software without specific prior written permission.
+ *
+ *
+ * ALTERNATIVELY, this software may be distributed under the terms of the
+ * GNU General Public License ("GPL") as published by the Free Software
+ * Foundation, either version 2 of that License or (at your option) any
+ * later version.
+ *
+ * THIS SOFTWARE IS PROVIDED BY Freescale Semiconductor ``AS IS'' AND ANY
+ * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
+ * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
+ * DISCLAIMED. IN NO EVENT SHALL Freescale Semiconductor BE LIABLE FOR ANY
+ * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
+ * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
+ * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
+ * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
+ * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+
+/* IPPDEXPCR: IP Power Down EXcePtion Control Register */
+rcpm-power@e2140 {
+	compatible = "fsl,rcpm-ippdexpcr";
+	reg = <0xe2140 0x4>;
+
+	mac1_1_power: soc-power@0 {
+		fsl,ippdexpcr-mask = <0x80000000>;
+	};
+	mac1_2_power: soc-power@1 {
+		fsl,ippdexpcr-mask = <0x40000000>;
+	};
+	mac1_3_power: soc-power@2 {
+		fsl,ippdexpcr-mask = <0x20000000>;
+	};
+	mac1_4_power: soc-power@3 {
+		fsl,ippdexpcr-mask = <0x10000000>;
+	};
+	mac1_5_power: soc-power@4 {
+		fsl,ippdexpcr-mask = <0x08000000>;
+	};
+	sdhc_power: soc-power@24 {
+		fsl,ippdexpcr-mask = <0x00000080>;
+	};
+	gpio_power: soc-power@25 {
+		fsl,ippdexpcr-mask = <0x00000040>;
+	};
+	usb1_power: soc-power@26 {
+		fsl,ippdexpcr-mask = <0x00000020>;
+	};
+	usb2_power: soc-power@27 {
+		fsl,ippdexpcr-mask = <0x00000010>;
+	};
+	fman1_power: soc-power@28 {
+		fsl,ippdexpcr-mask = <0x00000008>;
+	};
+	sap_power: soc-power@31 {
+		fsl,ippdexpcr-mask = <0x00000001>;
+	};
+};
diff --git a/arch/powerpc/sysdev/fsl_rcpm.c b/arch/powerpc/sysdev/fsl_rcpm.c
index ecf43a2..bc21aea 100644
--- a/arch/powerpc/sysdev/fsl_rcpm.c
+++ b/arch/powerpc/sysdev/fsl_rcpm.c
@@ -23,6 +23,49 @@
 struct ccsr_rcpm __iomem *rcpm1_regs;
 struct ccsr_rcpm_v2 __iomem *rcpm2_regs;
 
+/**
+ * fsl_rcpm_set_wake - enable/disable device working as wakeup source
+ * @dev: device affected
+ * @enable: true for keeping power on for this device during deep sleep
+ *          false otherwise
+ *
+ * return 0 on success, return -EINVAL if the device cannot wake up system
+ * and -ENODEV if RCPM unavailable
+ */
+int fsl_rcpm_set_wake(struct device *dev, bool enable)
+{
+	int ret = 0;
+	struct device_node *pw_np;
+	u32 pw_mask;
+
+	if (!rcpm2_regs) {
+		dev_err(dev, "%s: RCPM is unavailable\n", __func__);
+		return -ENODEV;
+	}
+
+	if (enable && !device_may_wakeup(dev))
+		return -EINVAL;
+
+	pw_np = of_parse_phandle(dev->of_node, "fsl,rcpm-handle", 0);
+	if (!pw_np)
+		return -EINVAL;
+
+	if (of_property_read_u32(pw_np, "fsl,ippdexpcr-mask", &pw_mask)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (enable)
+		/* clear to enable power in deep sleep mode */
+		clrbits32(&rcpm2_regs->ippdexpcr[0], pw_mask);
+	else
+		setbits32(&rcpm2_regs->ippdexpcr[0], pw_mask);
+
+out:
+	return ret;
+}
+EXPORT_SYMBOL_GPL(fsl_rcpm_set_wake);
+
 static int rcpm_suspend_enter(suspend_state_t state)
 {
 	int ret = 0;
-- 
1.7.9.5



