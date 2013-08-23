Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993Ab3HWRei (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 13:34:38 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:13031 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755797Ab3HWReg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 13:34:36 -0400
From: Rupesh Gujare <rupesh.gujare@atmel.com>
To: <devel@linuxdriverproject.org>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>
Subject: [PATCH 4/6] staging: ozwpan: change variable type.
Date: Fri, 23 Aug 2013 18:33:31 +0100
Message-ID: <1377279213-17074-4-git-send-email-rupesh.gujare@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1377279213-17074-1-git-send-email-rupesh.gujare@atmel.com>
References: <1377279213-17074-1-git-send-email-rupesh.gujare@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have icreased interrupt end point buffer size to 512 bytes,
Change variable data type to accomodate it.

Signed-off-by: Rupesh Gujare <rupesh.gujare@atmel.com>
---
 drivers/staging/ozwpan/ozhcd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/ozwpan/ozhcd.c b/drivers/staging/ozwpan/ozhcd.c
index 16fd60b..3548860 100644
--- a/drivers/staging/ozwpan/ozhcd.c
+++ b/drivers/staging/ozwpan/ozhcd.c
@@ -441,9 +441,9 @@ static void oz_complete_buffered_urb(struct oz_port *port,
 			struct oz_endpoint *ep,
 			struct urb *urb)
 {
-	u8 data_len, available_space, copy_len;
+	int data_len, available_space, copy_len;
 
-	memcpy(&data_len, &ep->buffer[ep->out_ix], sizeof(u8));
+	data_len = ep->buffer[ep->out_ix];
 	if (data_len <= urb->transfer_buffer_length)
 		available_space = data_len;
 	else
-- 
1.7.9.5

