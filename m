Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086AbaHWShL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 14:37:11 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:48310
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751850AbaHWShB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 14:37:01 -0400
X-IronPort-AV: E=Sophos;i="5.04,387,1406584800"; 
   d="scan'208";a="76200907"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: joe@perches.com, kernel-janitors@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/7] serial: vr41xx_siu: delete double assignment
Date: Sat, 23 Aug 2014 20:33:24 +0200
Message-Id: <1408818808-18850-4-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1408818808-18850-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1408818808-18850-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Delete successive assignments to the same location.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression i;
@@

*i = ...;
 i = ...;
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
The patches in this series do not depend on each other.

Not compiled.

 drivers/tty/serial/vr41xx_siu.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/tty/serial/vr41xx_siu.c b/drivers/tty/serial/vr41xx_siu.c
index db0c8a4..d7f9d62 100644
--- a/drivers/tty/serial/vr41xx_siu.c
+++ b/drivers/tty/serial/vr41xx_siu.c
@@ -847,7 +847,6 @@ void __init vr41xx_siu_early_setup(struct uart_port *port)
 	siu_uart_ports[port->line].type = port->type;
 	siu_uart_ports[port->line].uartclk = SIU_BAUD_BASE * 16;
 	siu_uart_ports[port->line].mapbase = port->mapbase;
-	siu_uart_ports[port->line].mapbase = port->mapbase;
 	siu_uart_ports[port->line].ops = &siu_uart_ops;
 }
 

