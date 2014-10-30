Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934716AbaJ3UBL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 16:01:11 -0400
Received: from mail-vc0-f202.google.com ([209.85.220.202]:51416 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933129AbaJ3UBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 16:01:10 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: Jassi Brar <jassisinghbrar@gmail.com>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Andrew Bresticker <abrestic@chromium.org>
Subject: [PATCH 1/2] mailbox: Avoid NULL-pointer dereference in mbox_chan_received_data()
Date: Thu, 30 Oct 2014 13:01:06 -0700
Message-Id: <1414699267-17970-1-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a message has been received on a channel, but no client has yet bound
to it, mbox_chan_received_data() will dereference a NULL client pointer.
Check for the presence of a client first.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
 drivers/mailbox/mailbox.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mailbox/mailbox.c b/drivers/mailbox/mailbox.c
index afcb430..5008028 100644
--- a/drivers/mailbox/mailbox.c
+++ b/drivers/mailbox/mailbox.c
@@ -142,7 +142,7 @@ static void poll_txdone(unsigned long data)
 void mbox_chan_received_data(struct mbox_chan *chan, void *mssg)
 {
 	/* No buffering the received data */
-	if (chan->cl->rx_callback)
+	if (chan->cl && chan->cl->rx_callback)
 		chan->cl->rx_callback(chan->cl, mssg);
 }
 EXPORT_SYMBOL_GPL(mbox_chan_received_data);
-- 
2.1.0.rc2.206.gedb03e5

