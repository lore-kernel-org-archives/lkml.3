Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758910Ab3HMR3l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 13:29:41 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:25181 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757843Ab3HMR3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 13:29:40 -0400
From: Rupesh Gujare <rupesh.gujare@atmel.com>
To: <devel@linuxdriverproject.org>
CC: <dan.carpenter@oracle.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>
Subject: [PATCH 05/10] staging: ozwpan: Remove unnecessary pointer check.
Date: Tue, 13 Aug 2013 18:29:21 +0100
Message-ID: <1376414966-23525-1-git-send-email-rupesh.gujare@atmel.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are already checking "ep" earlier in function. Do not
need to check again.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Rupesh Gujare <rupesh.gujare@atmel.com>
---
 drivers/staging/ozwpan/ozhcd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/ozwpan/ozhcd.c b/drivers/staging/ozwpan/ozhcd.c
index 2be15f4..8633f0c 100644
--- a/drivers/staging/ozwpan/ozhcd.c
+++ b/drivers/staging/ozwpan/ozhcd.c
@@ -527,7 +527,7 @@ static int oz_enqueue_ep_urb(struct oz_port *port, u8 ep_addr, int in_dir,
 		return 0;
 	}
 
-	if (ep && port->hpd) {
+	if (port->hpd) {
 		list_add_tail(&urbl->link, &ep->urb_list);
 		if (!in_dir && ep_addr && (ep->credit < 0)) {
 			getrawmonotonic(&ep->timestamp);
-- 
1.7.9.5

