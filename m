Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966AbaG2PDK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 11:03:10 -0400
Received: from filter1.ibarracuda.nl ([83.247.7.10]:33170 "EHLO
	filter1.ibarracuda.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753856AbaG2PCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 11:02:43 -0400
X-ASG-Debug-ID: 1406646161-0759e7416beb16a0002-xx1T2L
X-Barracuda-Envelope-From: Frans.Klaver@xsens.com
X-Barracuda-AUTH-User: xsenscom
X-Barracuda-Apparent-Source-IP: 87.249.116.215
From: Frans Klaver <frans.klaver@xsens.com>
To: <linux-serial@vger.kernel.org>
CC: Frans Klaver <frans.klaver@xsens.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] tty: omap-serial: support setting of hardware flow control in dts
Date: Tue, 29 Jul 2014 17:02:32 +0200
X-ASG-Orig-Subj: [PATCH 3/3] tty: omap-serial: support setting of hardware flow control in dts
Message-ID: <1406646152-24698-4-git-send-email-frans.klaver@xsens.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1406646152-24698-1-git-send-email-frans.klaver@xsens.com>
References: <1406645577-18620-1-git-send-email-frans.klaver@xsens.com>
 <1406646152-24698-1-git-send-email-frans.klaver@xsens.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.16.11.49]
X-Barracuda-Connect: rev-215.116.249.87.virtu.nl[87.249.116.215]
X-Barracuda-Start-Time: 1406646161
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://filter1.ibarracuda.nl:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=5.0 tests=BSF_SC0_MISMATCH_TO
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.7924
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.00 BSF_SC0_MISMATCH_TO    Envelope rcpt doesn't match header
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes hardware flow control availability configurable from the
device tree.

Signed-off-by: Frans Klaver <frans.klaver@xsens.com>
---
 Documentation/devicetree/bindings/serial/omap_serial.txt | 1 +
 drivers/tty/serial/omap-serial.c                         | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/serial/omap_serial.txt b/Documentation/devicetree/bindings/serial/omap_serial.txt
index 342eedd..1b629e9 100644
--- a/Documentation/devicetree/bindings/serial/omap_serial.txt
+++ b/Documentation/devicetree/bindings/serial/omap_serial.txt
@@ -8,3 +8,4 @@ Required properties:
 
 Optional properties:
 - clock-frequency : frequency of the clock input to the UART
+- has-hw-flow-control : the hardware has flow control capability
diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
index ff2d931..87df0ee 100644
--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
@@ -1660,6 +1660,9 @@ static int serial_omap_probe(struct platform_device *pdev)
 			return -EPROBE_DEFER;
 		wakeirq = irq_of_parse_and_map(pdev->dev.of_node, 1);
 		omap_up_info = of_get_uart_port_info(&pdev->dev);
+		if (of_property_read_bool(pdev->dev.of_node,
+					"has-hw-flow-control"))
+			omap_up_info->flags |= UPF_HARD_FLOW;
 		pdev->dev.platform_data = omap_up_info;
 	} else {
 		uartirq = platform_get_irq(pdev, 0);
-- 
1.9.3

