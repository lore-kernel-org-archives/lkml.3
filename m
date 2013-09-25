Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758303Ab3IYBdc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 21:33:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38571 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755341Ab3IYAMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:12:23 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Johan Hovold <jhovold@gmail.com>
Subject: [ 10/40] USB: mos7720: use GFP_ATOMIC under spinlock
Date: Tue, 24 Sep 2013 17:11:42 -0700
Message-Id: <20130925001043.075399298@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925001041.939335518@linuxfoundation.org>
References: <20130925001041.939335518@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit d0bd9a41186e076ea543c397ad8a67a6cf604b55 upstream.

The write_parport_reg_nonblock() function shouldn't sleep because it's
called with spinlocks held.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/mos7720.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/serial/mos7720.c
+++ b/drivers/usb/serial/mos7720.c
@@ -383,7 +383,7 @@ static int write_parport_reg_nonblock(st
 		kfree(urbtrack);
 		return -ENOMEM;
 	}
-	urbtrack->setup = kmalloc(sizeof(*urbtrack->setup), GFP_KERNEL);
+	urbtrack->setup = kmalloc(sizeof(*urbtrack->setup), GFP_ATOMIC);
 	if (!urbtrack->setup) {
 		usb_free_urb(urbtrack->urb);
 		kfree(urbtrack);


