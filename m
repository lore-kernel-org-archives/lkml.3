Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795AbaFPNYx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 09:24:53 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:50982 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753208AbaFPNYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 09:24:17 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH tty-next 11/22] tty: Call hangup method in modern style
Date: Mon, 16 Jun 2014 09:17:08 -0400
Message-Id: <1402924639-5164-12-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1402924639-5164-1-git-send-email-peter@hurleysoftware.com>
References: <1402924639-5164-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 3411071..714320b 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -688,7 +688,7 @@ static void __tty_hangup(struct tty_struct *tty, int exit_session)
 			for (n = 0; n < closecount; n++)
 				tty->ops->close(tty, cons_filp);
 	} else if (tty->ops->hangup)
-		(tty->ops->hangup)(tty);
+		tty->ops->hangup(tty);
 	/*
 	 * We don't want to have driver/ldisc interactions beyond
 	 * the ones we did here. The driver layer expects no
-- 
2.0.0

