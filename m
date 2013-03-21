Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555Ab3CUKrw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 06:47:52 -0400
Received: from mga01.intel.com ([192.55.52.88]:25282 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753358Ab3CUKrv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 06:47:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,884,1355126400"; 
   d="scan'208";a="309913827"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Ley Foon Tan <lftan@altera.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, Rob Landley <rob@landley.net>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: [PATCH 1/2] serial: 8250: Allow probe drivers to ignore tx_loadsz
Date: Thu, 21 Mar 2013 12:47:47 +0200
Message-Id: <1363862867-17222-1-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20130321104651.GC2862@xps8300>
References: <20130321104651.GC2862@xps8300>
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

