Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932485AbaKER3h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 12:29:37 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:45595 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755743AbaKER0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 12:26:53 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH -next 1/9] tty: Replace open-coded test with tty_hung_up_p()
Date: Wed,  5 Nov 2014 12:26:24 -0500
Message-Id: <1415208392-16189-2-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1415208392-16189-1-git-send-email-peter@hurleysoftware.com>
References: <1415208392-16189-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tty_hung_up_p() is equivalent to the open-coded test in tty_open().

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 4bd48f7..1262368 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -2129,7 +2129,7 @@ retry_open:
 		/*
 		 * Need to reset f_op in case a hangup happened.
 		 */
-		if (filp->f_op == &hung_up_tty_fops)
+		if (tty_hung_up_p(filp))
 			filp->f_op = &tty_fops;
 		goto retry_open;
 	}
-- 
2.1.3

