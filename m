Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468AbaIJTJG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 15:09:06 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:55256 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753240AbaIJTG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 15:06:57 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>,
        Karsten Keil <isdn@linux-pingi.de>, <netdev@vger.kernel.org>
Subject: [PATCH v2 03/14] isdn: i4l: Remove ASYNC_CTS_FLOW
Date: Wed, 10 Sep 2014 15:06:25 -0400
Message-Id: <1410375996-4693-4-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410375996-4693-1-git-send-email-peter@hurleysoftware.com>
References: <1409693975-1028-1-git-send-email-peter@hurleysoftware.com>
 <1410375996-4693-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ISDN4Linux always enables CTS flow control and does not use the
tty_port_cts_enabled() helper function; remove ASYNC_CTS_FLOW
state enable/disable.

cc: Karsten Keil <isdn@linux-pingi.de>
cc: <netdev@vger.kernel.org>
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/isdn/i4l/isdn_tty.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/isdn/i4l/isdn_tty.c b/drivers/isdn/i4l/isdn_tty.c
index 3c5f249..bc91261 100644
--- a/drivers/isdn/i4l/isdn_tty.c
+++ b/drivers/isdn/i4l/isdn_tty.c
@@ -1043,11 +1043,6 @@ isdn_tty_change_speed(modem_info *info)
 	if (!(cflag & PARODD))
 		cval |= UART_LCR_EPAR;
 
-	/* CTS flow control flag and modem status interrupts */
-	if (cflag & CRTSCTS) {
-		port->flags |= ASYNC_CTS_FLOW;
-	} else
-		port->flags &= ~ASYNC_CTS_FLOW;
 	if (cflag & CLOCAL)
 		port->flags &= ~ASYNC_CHECK_CD;
 	else {
-- 
2.1.0

