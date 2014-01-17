Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193AbaAQIrf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 03:47:35 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:62468 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892AbaAQIrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 03:47:33 -0500
X-AuditID: cbfee61a-b7fb26d00000724f-2a-52d8ee2306b6
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-cris-kernel@axis.com
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>
Subject: [PATCH] cris: cryptocop: fix GFP_ATOMIC macro usage
Date: Fri, 17 Jan 2014 09:47:18 +0100
Message-id: <1389948438-26437-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKJMWRmVeSWpSXmKPExsVy+t9jAV2VdzeCDF7sZ7R4fmgWs8WK1euY
	LS7vmsNmsfbIXXaLPb9jHFg9rq8L8OjbsorR4/MmuQDmKC6blNSczLLUIn27BK6MlR0TWAqW
	sldsffqJtYGxm62LkZNDQsBEYtPPOYwQtpjEhXvrgeJcHEICixglbr98BOW0MknMXdzDClLF
	JmAo0fW2C6xbRMBGYlP3YWYQm1mgTuLBsk1gNcJA8d0fbrOA2CwCqhLtk6+BxXkFPCR6HjwE
	2sYBtE1BYs4kmwmM3AsYGVYxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525iBHv+mdQOxpUNFocY
	BTgYlXh4JcRvBAmxJpYVV+YeYpTgYFYS4d16EyjEm5JYWZValB9fVJqTWnyIUZqDRUmc90Cr
	daCQQHpiSWp2ampBahFMlomDU6qBUUF9fiL32fK3Hd6v+9j6HwZXnn6Zu7NlW7WvX9Q2Zuv9
	dbUxJmHrVn2srv598Tbfoa+mnb0cd+fxeAnM0lj17eUrlWjDPY8epl4SuGu/nT9ozpdGEban
	C89P3GXRyMf1WkfmkMy7PLuoH68Nti34NfuN+t0nFhdPHu+W9hJ7t2u39IOEbS8WTVViKc5I
	NNRiLipOBAB/r01b+AEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GFP_ATOMIC is not a single gfp flag, but a macro which expands to the other
flags and LACK of __GFP_WAIT flag. To check if caller wanted to perform an
atomic allocation, the code must test __GFP_WAIT flag presence.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 arch/cris/arch-v32/drivers/cryptocop.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/cris/arch-v32/drivers/cryptocop.c b/arch/cris/arch-v32/drivers/cryptocop.c
index 877da19..7f2e60a 100644
--- a/arch/cris/arch-v32/drivers/cryptocop.c
+++ b/arch/cris/arch-v32/drivers/cryptocop.c
@@ -306,7 +306,7 @@ static void free_cdesc(struct cryptocop_dma_desc *cdesc)
 
 static struct cryptocop_dma_desc *alloc_cdesc(int alloc_flag)
 {
-	int use_pool = (alloc_flag & GFP_ATOMIC) ? 1 : 0;
+	int use_pool = (alloc_flag & __GFP_WAIT) ? 0 : 1;
 	struct cryptocop_dma_desc *cdesc;
 
 	if (use_pool) {
-- 
1.7.9.5

