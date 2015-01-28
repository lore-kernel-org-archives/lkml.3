Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965117AbbA1EYY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:24:24 -0500
Received: from mail.kernel.org ([198.145.29.136]:40616 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965066AbbA1EYO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:24:14 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 126/177] USB: opticon: fix non-atomic allocation in write path
Date: Wed, 28 Jan 2015 12:09:44 +0800
Message-Id: <1422418236-12852-217-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit e681286de221af78fc85db9222b6a203148c005a upstream.

Write may be called from interrupt context so make sure to use
GFP_ATOMIC for all allocations in write.

Fixes: 0d930e51cfe6 ("USB: opticon: Add Opticon OPN2001 write support")
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/usb/serial/opticon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/serial/opticon.c b/drivers/usb/serial/opticon.c
index 1f85006..58b7cec 100644
--- a/drivers/usb/serial/opticon.c
+++ b/drivers/usb/serial/opticon.c
@@ -293,7 +293,7 @@ static int opticon_write(struct tty_struct *tty, struct usb_serial_port *port,
 
 	/* The conncected devices do not have a bulk write endpoint,
 	 * to transmit data to de barcode device the control endpoint is used */
-	dr = kmalloc(sizeof(struct usb_ctrlrequest), GFP_NOIO);
+	dr = kmalloc(sizeof(struct usb_ctrlrequest), GFP_ATOMIC);
 	if (!dr) {
 		dev_err(&port->dev, "out of memory\n");
 		count = -ENOMEM;
-- 
1.9.1

