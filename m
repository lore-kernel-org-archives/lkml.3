Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757233Ab3FKUTF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 16:19:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41860 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756544Ab3FKUDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 16:03:43 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [ 19/79] USB: zte_ev: fix broken open
Date: Tue, 11 Jun 2013 13:02:45 -0700
Message-Id: <20130611195314.979496081@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.254.g5578ad7
In-Reply-To: <20130611195312.352656079@linuxfoundation.org>
References: <20130611195312.352656079@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit d8a1d0d54d5fdac0347b75e9afd554b3dfaa465f upstream.

Remove bogus port-number check in open and close, which prevented this
driver from being used with a minor number different from zero.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/zte_ev.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/drivers/usb/serial/zte_ev.c
+++ b/drivers/usb/serial/zte_ev.c
@@ -41,9 +41,6 @@ static int zte_ev_usb_serial_open(struct
 	int len;
 	unsigned char *buf;
 
-	if (port->number != 0)
-		return -ENODEV;
-
 	buf = kmalloc(MAX_SETUP_DATA_SIZE, GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
@@ -166,9 +163,6 @@ static void zte_ev_usb_serial_close(stru
 	int len;
 	unsigned char *buf;
 
-	if (port->number != 0)
-		return;
-
 	buf = kmalloc(MAX_SETUP_DATA_SIZE, GFP_KERNEL);
 	if (!buf)
 		return;


