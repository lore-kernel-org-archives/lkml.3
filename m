Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487AbaGKCjP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 22:39:15 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:42357 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751840AbaGKCjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 22:39:14 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH] serial: imx: Fix build breakage
Date: Thu, 10 Jul 2014 22:36:46 -0400
Message-Id: <1405046206-14495-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140711112108.7631911b@canb.auug.org.au>
References: <20140711112108.7631911b@canb.auug.org.au>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix breakage introduced by
commit c557d392fbf5badd693ea1946a4317c87a26a716,
'serial: Test for no tx data on tx restart'.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/serial/imx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
index 23c1dae..be1c842 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -563,7 +563,7 @@ static void imx_start_tx(struct uart_port *port)
 	struct imx_port *sport = (struct imx_port *)port;
 	unsigned long temp;
 
-	if (uart_circ_empty(&port.state->xmit))
+	if (uart_circ_empty(&port->state->xmit))
 		return;
 
 	if (USE_IRDA(sport)) {
-- 
2.0.0

