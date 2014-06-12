Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933640AbaFLRCs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 13:02:48 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:52005 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933275AbaFLRCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 13:02:46 -0400
From: Jassi Brar <jaswinder.singh@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: devicetree@vger.kernel.org, mporter@linaro.org, patches@linaro.org,
        bjorn@kryo.se, ashwin.chaugule@linaro.org, gregkh@linuxfoundation.org,
        s-anna@ti.com, loic.pallardy@st.com, lftan.linux@gmail.com,
        slapdau@yahoo.com.au, courtney.cavin@sonymobile.com,
        pawel.moll@arm.com, robh+dt@kernel.org, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, arnd@arndb.de, joshc@codeaurora.org,
        linus.walleij@linaro.org, galak@codeaurora.org, ks.giri@samsung.com,
        Jassi Brar <jaswinder.singh@linaro.org>
Subject: [PATCHv7 4/5] mailbox: Fix deleteing poll timer
Date: Thu, 12 Jun 2014 22:32:22 +0530
Message-Id: <1402592542-7318-1-git-send-email-jaswinder.singh@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1402592317-7043-1-git-send-email-jaswinder.singh@linaro.org>
References: <1402592317-7043-1-git-send-email-jaswinder.singh@linaro.org>
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

