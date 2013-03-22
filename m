Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933099Ab3CVIFY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 04:05:24 -0400
Received: from mga02.intel.com ([134.134.136.20]:14034 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932680Ab3CVIFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 04:05:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,891,1355126400"; 
   d="scan'208";a="283112584"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Ley Foon Tan <lftan@altera.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, Rob Landley <rob@landley.net>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: [PATCHv2 2/2] serial: of_serial: Handle fifo-size property
Date: Fri, 22 Mar 2013 10:05:16 +0200
Message-Id: <1363939516-17308-1-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20130322074154.GA9250@xps8300>
References: <20130322074154.GA9250@xps8300>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will reduce the need for extra types in 8250.c just
in case the fifo size differs from the standard.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
---
 Documentation/devicetree/bindings/tty/serial/of-serial.txt |    1 +
 drivers/tty/serial/of_serial.c                             |    4 ++++
 2 files changed, 5 insertions(+)

diff --git a/Documentation/devicetree/bindings/tty/serial/of-serial.txt b/Documentation/devicetree/bindings/tty/serial/of-serial.txt
index 8f01cb1..c13f0ce 100644
--- a/Documentation/devicetree/bindings/tty/serial/of-serial.txt
+++ b/Documentation/devicetree/bindings/tty/serial/of-serial.txt
@@ -33,6 +33,7 @@ Optional properties:
   RTAS and should not be registered.
 - no-loopback-test: set to indicate that the port does not implements loopback
   test mode
+- fifo-size: the fifo size of the UART.
 
 Example:
 
diff --git a/drivers/tty/serial/of_serial.c b/drivers/tty/serial/of_serial.c
index b025d54..267711b 100644
--- a/drivers/tty/serial/of_serial.c
+++ b/drivers/tty/serial/of_serial.c
@@ -97,6 +97,10 @@ static int of_platform_serial_setup(struct platform_device *ofdev,
 	if (of_property_read_u32(np, "reg-shift", &prop) == 0)
 		port->regshift = prop;
 
+	/* Check for fifo size */
+	if (of_property_read_u32(np, "fifo-size", &prop) == 0)
+		port->fifosize = prop;
+
 	port->irq = irq_of_parse_and_map(np, 0);
 	port->iotype = UPIO_MEM;
 	if (of_property_read_u32(np, "reg-io-width", &prop) == 0) {
-- 
1.7.10.4

