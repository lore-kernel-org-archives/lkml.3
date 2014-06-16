Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387AbaFPNRx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 09:17:53 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:35420 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753251AbaFPNRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 09:17:48 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Peter Hurley <peter@hurleysoftware.com>, Jiri Kosina <jkosina@suse.cz>,
        David Sterba <dsterba@suse.cz>
Subject: [PATCH tty-next 07/22] tty: ipwireless: Remove tty->closing abort from ipw_open()
Date: Mon, 16 Jun 2014 09:17:04 -0400
Message-Id: <1402924639-5164-8-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1402924639-5164-1-git-send-email-peter@hurleysoftware.com>
References: <1402924639-5164-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tty->closing cannot be set on ipw_open() because the ipwireless tty
driver does not call any functions that set tty->closing.

CC: Jiri Kosina <jkosina@suse.cz>
CC: David Sterba <dsterba@suse.cz>
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/ipwireless/tty.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/tty/ipwireless/tty.c b/drivers/tty/ipwireless/tty.c
index 17ee3bf..345cebb 100644
--- a/drivers/tty/ipwireless/tty.c
+++ b/drivers/tty/ipwireless/tty.c
@@ -93,11 +93,6 @@ static int ipw_open(struct tty_struct *linux_tty, struct file *filp)
 		return -ENODEV;
 
 	mutex_lock(&tty->ipw_tty_mutex);
-
-	if (tty->closing) {
-		mutex_unlock(&tty->ipw_tty_mutex);
-		return -ENODEV;
-	}
 	if (tty->port.count == 0)
 		tty->tx_bytes_queued = 0;
 
-- 
2.0.0

