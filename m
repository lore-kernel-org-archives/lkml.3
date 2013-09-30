Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187Ab3I3KL5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 06:11:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43403 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755016Ab3I3KLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 06:11:52 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 017/104] USB: mos7720: use GFP_ATOMIC under spinlock
Date: Mon, 30 Sep 2013 11:09:54 +0100
Message-Id: <1380535881-9239-18-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
References: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.22 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit d0bd9a41186e076ea543c397ad8a67a6cf604b55 upstream.

The write_parport_reg_nonblock() function shouldn't sleep because it's
called with spinlocks held.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/serial/mos7720.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/serial/mos7720.c b/drivers/usb/serial/mos7720.c
index 9809fbc..feda880 100644
--- a/drivers/usb/serial/mos7720.c
+++ b/drivers/usb/serial/mos7720.c
@@ -379,7 +379,7 @@ static int write_parport_reg_nonblock(struct mos7715_parport *mos_parport,
 		kfree(urbtrack);
 		return -ENOMEM;
 	}
-	urbtrack->setup = kmalloc(sizeof(*urbtrack->setup), GFP_KERNEL);
+	urbtrack->setup = kmalloc(sizeof(*urbtrack->setup), GFP_ATOMIC);
 	if (!urbtrack->setup) {
 		usb_free_urb(urbtrack->urb);
 		kfree(urbtrack);
-- 
1.8.3.2

