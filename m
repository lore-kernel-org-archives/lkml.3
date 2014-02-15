Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772AbaBOS1B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 13:27:01 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:41322 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753729AbaBOS07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 13:26:59 -0500
From: Jassi Brar <jassisinghbrar@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, s-anna@ti.com, tony@atomide.com,
        omar.ramirez@copitl.com, loic.pallardy@st.com, lftan.linux@gmail.com,
        slapdau@yahoo.com.au, courtney.cavin@sonymobile.com,
        rafael.j.wysocki@intel.com, Jassi Brar <jaswinder.singh@linaro.org>
Subject: [PATCHv3 5/6] mailbox: Fix deleteing poll timer
Date: Sat, 15 Feb 2014 23:56:41 +0530
Message-Id: <1392488801-18133-1-git-send-email-jaswinder.singh@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1392488526-17715-1-git-send-email-jaswinder.singh@linaro.org>
References: <1392488526-17715-1-git-send-email-jaswinder.singh@linaro.org>
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
index f8b31da..bac767e 100644
--- a/drivers/mailbox/mailbox.c
+++ b/drivers/mailbox/mailbox.c
@@ -529,7 +529,8 @@ void ipc_links_unregister(struct ipc_controller *ipc)
 	list_for_each_entry(chan, &con->channels, node)
 		ipc_free_channel((void *)chan);
 
-	del_timer_sync(&con->poll);
+	if (ipc->txdone_poll)
+		del_timer_sync(&con->poll);
 
 	kfree(con);
 }
-- 
1.8.1.2

