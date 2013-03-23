Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037Ab3CWHER (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 03:04:17 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:55541 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169Ab3CWHEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 03:04:16 -0400
MIME-Version: 1.0
Date: Sat, 23 Mar 2013 15:04:14 +0800
Message-ID: <CAPgLHd_FMbnYSFFL4rKVDC59CgHcDmDyCngdFHnexom-q538gQ@mail.gmail.com>
Subject: [PATCH -next v2] mailbox: fix invalid use of sizeof in mailbox_msg_send()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: s-anna@ti.com, linus.walleij@linaro.org, loic.pallardy@st.com,
        omar.ramirez@copitl.com, lugo.fernando@gmail.com
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

sizeof() when applied to a pointer typed expression gives the
size of the pointer, not that of the pointed data.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/mailbox/mailbox.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/mailbox/mailbox.c b/drivers/mailbox/mailbox.c
index 5fea5c2..78e52c0 100644
--- a/drivers/mailbox/mailbox.c
+++ b/drivers/mailbox/mailbox.c
@@ -83,7 +83,7 @@ int mailbox_msg_send(struct mailbox *mbox, struct mailbox_msg *msg)
 
 	mutex_lock(&mq->mlock);
 
-	if (kfifo_avail(&mq->fifo) < (sizeof(msg) + msg->size)) {
+	if (kfifo_avail(&mq->fifo) < (sizeof(*msg) + msg->size)) {
 		ret = -ENOMEM;
 		goto out;
 	}
@@ -93,8 +93,8 @@ int mailbox_msg_send(struct mailbox *mbox, struct mailbox_msg *msg)
 		goto out;
 	}
 
-	len = kfifo_in(&mq->fifo, (unsigned char *)msg, sizeof(msg));
-	WARN_ON(len != sizeof(msg));
+	len = kfifo_in(&mq->fifo, (unsigned char *)msg, sizeof(*msg));
+	WARN_ON(len != sizeof(*msg));
 
 	if (msg->size && msg->pdata) {
 		len = kfifo_in(&mq->fifo, (unsigned char *)msg->pdata,


