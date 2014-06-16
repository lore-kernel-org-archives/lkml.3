Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173AbaFPNX0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 09:23:26 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:50404 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752571AbaFPNXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 09:23:24 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH tty-next 10/22] char: synclink: Remove WARN_ON for bad port count
Date: Mon, 16 Jun 2014 09:17:07 -0400
Message-Id: <1402924639-5164-11-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1402924639-5164-1-git-send-email-peter@hurleysoftware.com>
References: <1402924639-5164-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tty_port_close_start() already validates the port counts and issues
a diagnostic if validation fails.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/char/pcmcia/synclink_cs.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/char/pcmcia/synclink_cs.c b/drivers/char/pcmcia/synclink_cs.c
index a63970f..0ea9986 100644
--- a/drivers/char/pcmcia/synclink_cs.c
+++ b/drivers/char/pcmcia/synclink_cs.c
@@ -2347,8 +2347,6 @@ static void mgslpc_close(struct tty_struct *tty, struct file * filp)
 		printk("%s(%d):mgslpc_close(%s) entry, count=%d\n",
 			 __FILE__, __LINE__, info->device_name, port->count);
 
-	WARN_ON(!port->count);
-
 	if (tty_port_close_start(port, tty, filp) == 0)
 		goto cleanup;
 
-- 
2.0.0

