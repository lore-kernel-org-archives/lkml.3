Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758006Ab3CGMOu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 07:14:50 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:49722 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1757067Ab3CGMMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 07:12:49 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: peter@hurleysoftware.com, jirislaby@gmail.com,
        linux-kernel@vger.kernel.org,
        Lucas Tavares <lucaskt@linux.vnet.ibm.com>
Subject: [PATCH 01/16] TTY: jsm, remove superfluous check
Date: Thu,  7 Mar 2013 13:12:25 +0100
Message-Id: <1362658360-26629-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

data_len in jsm_input cannot be zero as we would jump out early in the
function. It also cannot be negative because it is an int and we do
bitwise and with 8192. So remove the check.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Lucas Tavares <lucaskt@linux.vnet.ibm.com>
---
 drivers/tty/serial/jsm/jsm_tty.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/tty/serial/jsm/jsm_tty.c b/drivers/tty/serial/jsm/jsm_tty.c
index 00f250a..27bb750 100644
--- a/drivers/tty/serial/jsm/jsm_tty.c
+++ b/drivers/tty/serial/jsm/jsm_tty.c
@@ -596,12 +596,6 @@ void jsm_input(struct jsm_channel *ch)
 
 	jsm_dbg(READ, &ch->ch_bd->pci_dev, "start 2\n");
 
-	if (data_len <= 0) {
-		spin_unlock_irqrestore(&ch->ch_lock, lock_flags);
-		jsm_dbg(READ, &ch->ch_bd->pci_dev, "jsm_input 1\n");
-		return;
-	}
-
 	len = tty_buffer_request_room(port, data_len);
 	n = len;
 
-- 
1.8.1.4


