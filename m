Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757279Ab3HARpN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 13:45:13 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:8685 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754243Ab3HARpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 13:45:11 -0400
From: Rupesh Gujare <rupesh.gujare@atmel.com>
To: <devel@linuxdriverproject.org>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>
Subject: [PATCH 6/6] staging: ozwpan: Set farewell report length.
Date: Thu, 1 Aug 2013 18:45:02 +0100
Message-ID: <1375379102-18217-2-git-send-email-rupesh.gujare@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1375379102-18217-1-git-send-email-rupesh.gujare@atmel.com>
References: <1375379102-18217-1-git-send-email-rupesh.gujare@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes a bug where we were not setting length field causing wrong
report size to be copied.

Signed-off-by: Rupesh Gujare <rupesh.gujare@atmel.com>
---
 drivers/staging/ozwpan/ozproto.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/ozwpan/ozproto.c b/drivers/staging/ozwpan/ozproto.c
index ec60286..084307a 100644
--- a/drivers/staging/ozwpan/ozproto.c
+++ b/drivers/staging/ozwpan/ozproto.c
@@ -296,6 +296,7 @@ static void oz_add_farewell(struct oz_pd *pd, u8 ep_num, u8 index,
 		return;
 	f->ep_num = ep_num;
 	f->index = index;
+	f->len = len;
 	memcpy(f->report, report, len);
 	oz_dbg(ON, "RX: Adding farewell report\n");
 	spin_lock(&g_polling_lock);
-- 
1.7.9.5

