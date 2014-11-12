Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933090AbaKLBb4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:31:56 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59354 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933048AbaKLBbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:31:50 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 3.17 235/319] USB: opticon: fix non-atomic allocation in write path
Date: Wed, 12 Nov 2014 10:16:13 +0900
Message-Id: <20141112011031.650160878@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit e681286de221af78fc85db9222b6a203148c005a upstream.

Write may be called from interrupt context so make sure to use
GFP_ATOMIC for all allocations in write.

Fixes: 0d930e51cfe6 ("USB: opticon: Add Opticon OPN2001 write support")
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/opticon.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/serial/opticon.c
+++ b/drivers/usb/serial/opticon.c
@@ -215,7 +215,7 @@ static int opticon_write(struct tty_stru
 
 	/* The connected devices do not have a bulk write endpoint,
 	 * to transmit data to de barcode device the control endpoint is used */
-	dr = kmalloc(sizeof(struct usb_ctrlrequest), GFP_NOIO);
+	dr = kmalloc(sizeof(struct usb_ctrlrequest), GFP_ATOMIC);
 	if (!dr) {
 		count = -ENOMEM;
 		goto error_no_dr;


