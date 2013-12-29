Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755779Ab3L2CjK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:39:10 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55224 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752438Ab3L2CKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:10:37 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "David Cluytens" <david.cluytens@gmail.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date: Sun, 29 Dec 2013 03:08:44 +0100
Message-ID: <lsq.1388282924.232629277@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 123/185] USB: cdc-acm: Added support for the Lenovo
 RD02-D400 USB Modem
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: David Cluytens <david.cluytens@gmail.com>

commit 3b59d16c513da258ec8f6a0b4db85f257a0380d6 upstream.

Signed-off-by: David Cluytens <david.cluytens@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/class/cdc-acm.c | 2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1448,6 +1448,8 @@ static int acm_reset_resume(struct usb_i
 
 static const struct usb_device_id acm_ids[] = {
 	/* quirky and broken devices */
+	{ USB_DEVICE(0x17ef, 0x7000), /* Lenovo USB modem */
+	.driver_info = NO_UNION_NORMAL, },/* has no union descriptor */
 	{ USB_DEVICE(0x0870, 0x0001), /* Metricom GS Modem */
 	.driver_info = NO_UNION_NORMAL, /* has no union descriptor */
 	},

