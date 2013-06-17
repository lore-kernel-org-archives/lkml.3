Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755121Ab3FQRkq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 13:40:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50713 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754726Ab3FQRgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 13:36:07 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 26/84] USB: zte_ev: fix broken open
Date: Mon, 17 Jun 2013 10:30:30 -0700
Message-Id: <1371490288-23167-27-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371490288-23167-1-git-send-email-kamal@canonical.com>
References: <1371490288-23167-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit d8a1d0d54d5fdac0347b75e9afd554b3dfaa465f upstream.

Remove bogus port-number check in open and close, which prevented this
driver from being used with a minor number different from zero.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/serial/zte_ev.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/usb/serial/zte_ev.c b/drivers/usb/serial/zte_ev.c
index b9a88f2..870e01e 100644
--- a/drivers/usb/serial/zte_ev.c
+++ b/drivers/usb/serial/zte_ev.c
@@ -41,9 +41,6 @@ static int zte_ev_usb_serial_open(struct tty_struct *tty,
 	int len;
 	unsigned char *buf;
 
-	if (port->number != 0)
-		return -ENODEV;
-
 	buf = kmalloc(MAX_SETUP_DATA_SIZE, GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
@@ -166,9 +163,6 @@ static void zte_ev_usb_serial_close(struct usb_serial_port *port)
 	int len;
 	unsigned char *buf;
 
-	if (port->number != 0)
-		return;
-
 	buf = kmalloc(MAX_SETUP_DATA_SIZE, GFP_KERNEL);
 	if (!buf)
 		return;
-- 
1.8.1.2

