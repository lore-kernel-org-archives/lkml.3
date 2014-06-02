Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626AbaFBSc3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 14:32:29 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:64160 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020AbaFBSc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 14:32:28 -0400
From: Jassi Brar <jaswinder.singh@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, s-anna@ti.com, loic.pallardy@st.com,
        lftan.linux@gmail.com, slapdau@yahoo.com.au,
        courtney.cavin@sonymobile.com, robherring2@gmail.com, arnd@arndb.de,
        joshc@codeaurora.org, linus.walleij@linaro.org, galak@codeaurora.org,
        ks.giri@samsung.com, patches@linaro.org, bjorn@kryo.se,
        Jassi Brar <jaswinder.singh@linaro.org>
Subject: [PATCHv6 3/3] mailbox: Fix deleteing poll timer
Date: Tue,  3 Jun 2014 00:02:02 +0530
Message-Id: <1401733922-5943-1-git-send-email-jaswinder.singh@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1401733450-5646-1-git-send-email-jaswinder.singh@linaro.org>
References: <1401733450-5646-1-git-send-email-jaswinder.singh@linaro.org>
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
index 336fa10..ae4abd9 100644
--- a/drivers/mailbox/mailbox.c
+++ b/drivers/mailbox/mailbox.c
@@ -480,7 +480,8 @@ void mbox_controller_unregister(struct mbox_controller *mbox)
 	for (i = 0; i < mbox->num_chans; i++)
 		mbox_free_channel(&mbox->chans[i]);
 
-	del_timer_sync(&mbox->poll);
+	if (mbox->txdone_poll)
+		del_timer_sync(&mbox->poll);
 
 	mutex_unlock(&con_mutex);
 }
-- 
1.8.1.2

