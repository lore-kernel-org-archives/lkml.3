Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757708AbaCRSrB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 14:47:01 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:33928 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757691AbaCRSq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 14:46:57 -0400
From: Jassi Brar <jassisinghbrar@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, s-anna@ti.com, tony@atomide.com,
        omar.ramirez@copitl.com, loic.pallardy@st.com, lftan.linux@gmail.com,
        slapdau@yahoo.com.au, courtney.cavin@sonymobile.com,
        rafael.j.wysocki@intel.com, robherring2@gmail.com, arnd@arndb.de,
        joshc@codeaurora.org, linus.walleij@linaro.org, galak@codeaurora.org,
        ks.giri@samsung.com, Jassi Brar <jaswinder.singh@linaro.org>
Subject: [PATCHv4 5/5] mailbox: Fix deleteing poll timer
Date: Wed, 19 Mar 2014 00:16:39 +0530
Message-Id: <1395168399-29237-1-git-send-email-jaswinder.singh@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1395168169-28978-1-git-send-email-jaswinder.singh@linaro.org>
References: <1395168169-28978-1-git-send-email-jaswinder.singh@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: LeyFoon Tan <lftan.linux@gmail.com>

Try to delete the timer only if it was init/used.

Signed-off-by: LeyFoon Tan <lftan.linux@gmail.com>
Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
---
 drivers/mailbox/mailbox.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mailbox/mailbox.c b/drivers/mailbox/mailbox.c
index cdf7d45..d080fc3 100644
--- a/drivers/mailbox/mailbox.c
+++ b/drivers/mailbox/mailbox.c
@@ -584,7 +584,8 @@ void mbox_controller_unregister(struct mbox_controller *mbox)
 	list_for_each_entry(chan, &con->channels, node)
 		mbox_free_channel(chan);
 
-	del_timer_sync(&con->poll);
+	if (mbox->txdone_poll)
+		del_timer_sync(&con->poll);
 
 	kfree(con);
 }
-- 
1.8.1.2

