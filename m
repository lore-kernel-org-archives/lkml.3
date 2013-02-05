Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756887Ab3BEUoI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 15:44:08 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:53892 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755453Ab3BEUoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 15:44:03 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, Jiri Slaby <jslaby@suse.cz>,
        Sasha Levin <levinsasha928@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ilya Zykov <ilya@ilyx.ru>, Dave Jones <davej@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v3 10/23] tty: Wait for SAK work before waiting for hangup work
Date: Tue,  5 Feb 2013 15:20:25 -0500
Message-Id: <1360095638-6624-11-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1360095638-6624-1-git-send-email-peter@hurleysoftware.com>
References: <1355509370-5883-1-git-send-email-peter@hurleysoftware.com>
 <1360095638-6624-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SAK work may schedule hangup work (if TTY_SOFT_SAK is defined), thus
SAK work must be flushed before hangup work.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_ldisc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/tty_ldisc.c b/drivers/tty/tty_ldisc.c
index 7e26e7f..c903778 100644
--- a/drivers/tty/tty_ldisc.c
+++ b/drivers/tty/tty_ldisc.c
@@ -506,8 +506,8 @@ static void tty_ldisc_restore(struct tty_struct *tty, struct tty_ldisc *old)
  */
 static void tty_ldisc_flush_works(struct tty_struct *tty)
 {
-	flush_work(&tty->hangup_work);
 	flush_work(&tty->SAK_work);
+	flush_work(&tty->hangup_work);
 }
 
 /**
-- 
1.8.1.2

