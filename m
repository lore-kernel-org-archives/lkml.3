Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932111Ab3LQSPd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 13:15:33 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:32860 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755185Ab3LQSPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 13:15:30 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: David Cluytens <david.cluytens@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 077/103] USB: cdc-acm: Added support for the Lenovo RD02-D400 USB Modem
Date: Tue, 17 Dec 2013 18:13:06 +0000
Message-Id: <1387304012-23805-78-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387304012-23805-1-git-send-email-luis.henriques@canonical.com>
References: <1387304012-23805-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.28 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Cluytens <david.cluytens@gmail.com>

commit 3b59d16c513da258ec8f6a0b4db85f257a0380d6 upstream.

Signed-off-by: David Cluytens <david.cluytens@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/class/cdc-acm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 07a9f9c..dc42d09 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1542,6 +1542,8 @@ static int acm_reset_resume(struct usb_interface *intf)
 
 static const struct usb_device_id acm_ids[] = {
 	/* quirky and broken devices */
+	{ USB_DEVICE(0x17ef, 0x7000), /* Lenovo USB modem */
+	.driver_info = NO_UNION_NORMAL, },/* has no union descriptor */
 	{ USB_DEVICE(0x0870, 0x0001), /* Metricom GS Modem */
 	.driver_info = NO_UNION_NORMAL, /* has no union descriptor */
 	},
-- 
1.8.3.2

