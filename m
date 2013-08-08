Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757771Ab3HHK4w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 06:56:52 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:54861 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467Ab3HHK4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 06:56:51 -0400
From: Iker Pedrosa <ikerpedrosam@gmail.com>
To: gregkh@linuxfoundation.org
Cc: ikerpedrosam@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: rtl8192e: rtllib_rx: checking NULL value after doing dev_alloc_skb
Date: Thu,  8 Aug 2013 12:56:44 +0200
Message-Id: <1375959404-3276-1-git-send-email-ikerpedrosam@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Checking the return of dev_alloc_skb as stated in the following bug: https://bugzilla.kernel.org/show_bug.cgi?id=60401

Signed-off-by: Iker Pedrosa <ikerpedrosam@gmail.com>
---
 drivers/staging/rtl8192e/rtllib_rx.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/staging/rtl8192e/rtllib_rx.c b/drivers/staging/rtl8192e/rtllib_rx.c
index 8b8a5c6..50cb1fa 100644
--- a/drivers/staging/rtl8192e/rtllib_rx.c
+++ b/drivers/staging/rtl8192e/rtllib_rx.c
@@ -777,6 +777,8 @@ static u8 parse_subframe(struct rtllib_device *ieee, struct sk_buff *skb,
 
 		/* Allocate new skb for releasing to upper layer */
 		sub_skb = dev_alloc_skb(RTLLIB_SKBBUFFER_SIZE);
+		if (!sub_skb)
+			return 0;
 		skb_reserve(sub_skb, 12);
 		data_ptr = (u8 *)skb_put(sub_skb, skb->len);
 		memcpy(data_ptr, skb->data, skb->len);
@@ -825,6 +827,8 @@ static u8 parse_subframe(struct rtllib_device *ieee, struct sk_buff *skb,
 
 			/* Allocate new skb for releasing to upper layer */
 			sub_skb = dev_alloc_skb(nSubframe_Length + 12);
+			if (!sub_skb)
+				return 0;
 			skb_reserve(sub_skb, 12);
 			data_ptr = (u8 *)skb_put(sub_skb, nSubframe_Length);
 			memcpy(data_ptr, skb->data, nSubframe_Length);
-- 
1.8.1.2

