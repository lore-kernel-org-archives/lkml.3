Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933172Ab3CVNWK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 09:22:10 -0400
Received: from mail-bk0-f43.google.com ([209.85.214.43]:59210 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754097Ab3CVNWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 09:22:09 -0400
MIME-Version: 1.0
Date: Fri, 22 Mar 2013 21:22:07 +0800
Message-ID: <CAPgLHd-4=Nie0-jdy9-0V9v5GfgKP5L3XycQdw1qWL3dhzYjMw@mail.gmail.com>
Subject: [PATCH -next] mailbox: fix invalid use of sizeof in mailbox_msg_send()
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
 drivers/mailbox/mailbox.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mailbox/mailbox.c b/drivers/mailbox/mailbox.c
index 5fea5c2..e011a75 100644
--- a/drivers/mailbox/mailbox.c
+++ b/drivers/mailbox/mailbox.c
@@ -93,8 +93,8 @@ int mailbox_msg_send(struct mailbox *mbox, struct mailbox_msg *msg)
 		goto out;
 	}
 
-	len = kfifo_in(&mq->fifo, (unsigned char *)msg, sizeof(msg));
-	WARN_ON(len != sizeof(msg));
+	len = kfifo_in(&mq->fifo, (unsigned char *)msg, sizeof(*msg));
+	WARN_ON(len != sizeof(*msg));
 
 	if (msg->size && msg->pdata) {
 		len = kfifo_in(&mq->fifo, (unsigned char *)msg->pdata,


