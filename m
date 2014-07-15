Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965454AbaGOXpF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 19:45:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45209 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933762AbaGOXN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 19:13:59 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 3.15 14/84] serial: imx: Fix build breakage
Date: Tue, 15 Jul 2014 16:17:11 -0700
Message-Id: <20140715231713.621762682@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140715231713.193785557@linuxfoundation.org>
References: <20140715231713.193785557@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Hurley <peter@hurleysoftware.com>

commit 8bec751bd63847b4044aab8b215db52aa6abde61 upstream.

Fix breakage introduced by
commit c557d392fbf5badd693ea1946a4317c87a26a716,
'serial: Test for no tx data on tx restart'.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/imx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -563,7 +563,7 @@ static void imx_start_tx(struct uart_por
 	struct imx_port *sport = (struct imx_port *)port;
 	unsigned long temp;
 
-	if (uart_circ_empty(&port.state->xmit))
+	if (uart_circ_empty(&port->state->xmit))
 		return;
 
 	if (USE_IRDA(sport)) {


