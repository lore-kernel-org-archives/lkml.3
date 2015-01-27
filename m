Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758622AbbA0PLu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 10:11:50 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:40006 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487AbbA0PLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 10:11:42 -0500
From: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>
To: <wim@iguana.be>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-watchdog@vger.kernel.org>, <Zubair.Kakakhel@imgtec.com>,
        <paul@crapouillou.net>
Subject: [PATCH 1/2] dt: watchdog: Add DT binding documentation for jz47xx watchdog timer
Date: Tue, 27 Jan 2015 15:11:29 +0000
Message-ID: <1422371490-44402-2-git-send-email-Zubair.Kakakhel@imgtec.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422371490-44402-1-git-send-email-Zubair.Kakakhel@imgtec.com>
References: <1422371490-44402-1-git-send-email-Zubair.Kakakhel@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.154.89]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add binding for jz47xx watchdog timer. It is a simple watchdog timer.
Needs rtc clock and register addresses

Signed-off-by: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>

---
The jz4740 is platform only at the moment.

But DT support is being added

See http://patchwork.linux-mips.org/bundle/paulburton/ci20-v3.20/

jz47xx is used because jz4780 will also use this driver
---
 .../devicetree/bindings/watchdog/ingenic,jz47xx-wdt.txt | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/watchdog/ingenic,jz47xx-wdt.txt

diff --git a/Documentation/devicetree/bindings/watchdog/ingenic,jz47xx-wdt.txt b/Documentation/devicetree/bindings/watchdog/ingenic,jz47xx-wdt.txt
new file mode 100644
index 0000000..bf4c404
--- /dev/null
+++ b/Documentation/devicetree/bindings/watchdog/ingenic,jz47xx-wdt.txt
@@ -0,0 +1,17 @@
+Ingenic Watchdog Timer (WDT) Controller for JZ47XX
+
+Required properties:
+compatible: "ingenic,jz4740-watchdog"
+reg: Register address and length for watchdog registers
+clocks: phandle to rtcclk
+clock-names: must be "rtc"
+
+Example:
+
+watchdog: jz47xx-watchdog@0x10002000 {
+	compatible = "ingenic,jz4780-watchdog";
+	reg = <0x10002000 0x100>;
+
+	clocks = <&rtclk>;
+	clock-names = "rtc";
+};
-- 
1.9.1

