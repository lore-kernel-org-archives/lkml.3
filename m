Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756471Ab3CYLex (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 07:34:53 -0400
Received: from mga01.intel.com ([192.55.52.88]:32083 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756237Ab3CYLev (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 07:34:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,904,1355126400"; 
   d="scan'208";a="311514220"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Ley Foon Tan <lftan@altera.com>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: [PATCH 1/3] serial: 8250: Allow probe drivers to ignore tx_loadsz
Date: Mon, 25 Mar 2013 13:34:44 +0200
Message-Id: <1364211286-31611-2-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364211286-31611-1-git-send-email-heikki.krogerus@linux.intel.com>
References: <1364211286-31611-1-git-send-email-heikki.krogerus@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In most cases the tx_loadsz is the same as fifosize. This
will store the fifosize in it if it was not separately
delivered from the driver.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
---
 drivers/tty/serial/8250/8250.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/tty/serial/8250/8250.c b/drivers/tty/serial/8250/8250.c
index cf6a538..19ebbdf 100644
--- a/drivers/tty/serial/8250/8250.c
+++ b/drivers/tty/serial/8250/8250.c
@@ -3247,6 +3247,10 @@ int serial8250_register_8250_port(struct uart_8250_port *up)
 		uart->tx_loadsz		= up->tx_loadsz;
 		uart->capabilities	= up->capabilities;
 
+		/* Take tx_loadsz from fifosize if it wasn't set separately */
+		if (uart->port.fifosize && !uart->tx_loadsz)
+			uart->tx_loadsz = uart->port.fifosize;
+
 		if (up->port.dev)
 			uart->port.dev = up->port.dev;
 
-- 
1.7.10.4

