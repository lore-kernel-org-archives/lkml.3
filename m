Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105AbaEOGNM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 02:13:12 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:42144 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753467AbaEOGNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 02:13:11 -0400
X-Google-Original-From: Jassi Brar <jaswinder.singh@linaro.org>
From: Jassi Brar <jassisinghbrar@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, s-anna@ti.com, loic.pallardy@st.com,
        lftan.linux@gmail.com, slapdau@yahoo.com.au,
        courtney.cavin@sonymobile.com, robherring2@gmail.com, arnd@arndb.de,
        joshc@codeaurora.org, linus.walleij@linaro.org, galak@codeaurora.org,
        ks.giri@samsung.com, Jassi Brar <jaswinder.singh@linaro.org>
Subject: [PATCHv5 4/4] mailbox: Fix deleteing poll timer
Date: Thu, 15 May 2014 11:42:22 +0530
Message-Id: <1400134342-4058-1-git-send-email-jaswinder.singh@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1400134105-3847-1-git-send-email-jaswinder.singh@linaro.org>
References: <1400134105-3847-1-git-send-email-jaswinder.singh@linaro.org>
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
index befb256..d83d12c 100644
--- a/drivers/mailbox/mailbox.c
+++ b/drivers/mailbox/mailbox.c
@@ -475,7 +475,8 @@ void mbox_controller_unregister(struct mbox_controller *mbox)
 	for (i = 0; i < mbox->num_chans; i++)
 		mbox_free_channel(&mbox->chans[i]);
 
-	del_timer_sync(&mbox->poll);
+	if (mbox->txdone_poll)
+		del_timer_sync(&mbox->poll);
 
 	mutex_unlock(&con_mutex);
 }
-- 
1.8.1.2

