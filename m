Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883AbaIOOBW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 10:01:22 -0400
Received: from filter1.ibarracuda.nl ([83.247.7.10]:51421 "EHLO
	filter1.ibarracuda.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892AbaIOOBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 10:01:18 -0400
X-ASG-Debug-ID: 1410789675-0759e746c032500002-xx1T2L
X-Barracuda-Envelope-From: Frans.Klaver@xsens.com
X-Barracuda-AUTH-User: xsenscom
X-Barracuda-Apparent-Source-IP: 87.249.116.215
From: Frans Klaver <frans.klaver@xsens.com>
To: Tony Lindgren <tony@atomide.com>
CC: Frans Klaver <frans.klaver@xsens.com>, Felipe Balbi <balbi@ti.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexey Pelykh <alexey.pelykh@gmail.com>, Jiri Slaby <jslaby@suse.cz>,
        <linux-serial@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/4] tty: omap-serial: support setting of hardware flow control in dts
Date: Mon, 15 Sep 2014 16:00:10 +0200
X-ASG-Orig-Subj: [PATCH 4/4] tty: omap-serial: support setting of hardware flow control in dts
Message-ID: <1410789610-23059-5-git-send-email-frans.klaver@xsens.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410789610-23059-1-git-send-email-frans.klaver@xsens.com>
References: <1410789610-23059-1-git-send-email-frans.klaver@xsens.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.16.11.160]
X-Barracuda-Connect: rev-215.116.249.87.virtu.nl[87.249.116.215]
X-Barracuda-Start-Time: 1410789676
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://filter1.ibarracuda.nl:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=5.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.9505
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes hardware flow control availability configurable from the
device tree.

Signed-off-by: Frans Klaver <frans.klaver@xsens.com>
---
 Documentation/devicetree/bindings/serial/omap_serial.txt | 1 +
 drivers/tty/serial/omap-serial.c                         | 4 ++++
 2 files changed, 5 insertions(+)

diff --git a/Documentation/devicetree/bindings/serial/omap_serial.txt b/Documentation/devicetree/bindings/serial/omap_serial.txt
index 342eedd..1b629e9 100644
--- a/Documentation/devicetree/bindings/serial/omap_serial.txt
+++ b/Documentation/devicetree/bindings/serial/omap_serial.txt
@@ -8,3 +8,4 @@ Required properties:
 
 Optional properties:
 - clock-frequency : frequency of the clock input to the UART
+- has-hw-flow-control : the hardware has flow control capability
diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
index 398139a..bff6874 100644
--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
@@ -1597,6 +1597,10 @@ static struct omap_uart_port_info *of_get_uart_port_info(struct device *dev)
 
 	of_property_read_u32(dev->of_node, "clock-frequency",
 					 &omap_up_info->uartclk);
+
+	if (of_property_read_bool(dev->of_node, "has-hw-flow-control"))
+		omap_up_info->flags |= UPF_HARD_FLOW;
+
 	return omap_up_info;
 }
 
-- 
2.1.0

