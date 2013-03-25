Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756602Ab3CYLfU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 07:35:20 -0400
Received: from mga01.intel.com ([192.55.52.88]:32083 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756437Ab3CYLex (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 07:34:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,904,1355126400"; 
   d="scan'208";a="311514228"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Ley Foon Tan <lftan@altera.com>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: [PATCH 2/3] serial: of_serial: Handle fifo-size property
Date: Mon, 25 Mar 2013 13:34:45 +0200
Message-Id: <1364211286-31611-3-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364211286-31611-1-git-send-email-heikki.krogerus@linux.intel.com>
References: <1364211286-31611-1-git-send-email-heikki.krogerus@linux.intel.com>
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

