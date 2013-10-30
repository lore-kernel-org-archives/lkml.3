Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881Ab3J3H5l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 03:57:41 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:51790 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071Ab3J3H5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 03:57:40 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.37 with qID r9U7ri7R010606, This message is accepted by code: ctloc85258
From: <rogerable@realtek.com>
To: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>
CC: <maximlevitsky@gmail.com>, <gregkh@linuxfoundation.org>, <oakad@yahoo.com>,
        <wei_wang@realsil.com.cn>, <micky_ching@realsil.com.cn>,
        Roger Tseng <rogerable@realtek.com>
Subject: [PATCH] memstick: fix unreachable state in h_msb_read_page() in ms_block.c
Date: Wed, 30 Oct 2013 15:54:11 +0800
Message-ID: <1383119651-31317-1-git-send-email-rogerable@realtek.com>
X-Mailer: git-send-email 1.8.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.81.189]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roger Tseng <rogerable@realtek.com>

In h_msb_read_page() in ms_block.c, flow never reaches case
MSB_RP_RECIVE_STATUS_REG. This causes error when MEMSTICK_INT_ERR is
encountered and status error bits are going to be examined, but the status will
never be copied back.

Fix it by transiting to MSB_RP_RECIVE_STATUS_REG right after
MSB_RP_SEND_READ_STATUS_REG.

Signed-off-by: Roger Tseng <rogerable@realtek.com>
---
 drivers/memstick/core/ms_block.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/memstick/core/ms_block.c b/drivers/memstick/core/ms_block.c
index 08e7023..9188ef5 100644
--- a/drivers/memstick/core/ms_block.c
+++ b/drivers/memstick/core/ms_block.c
@@ -401,7 +401,7 @@ again:
 			sizeof(struct ms_status_register)))
 			return 0;
 
-		msb->state = MSB_RP_RECEIVE_OOB_READ;
+		msb->state = MSB_RP_RECIVE_STATUS_REG;
 		return 0;
 
 	case MSB_RP_RECIVE_STATUS_REG:
-- 
1.8.2

