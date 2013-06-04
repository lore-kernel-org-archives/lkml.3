Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757202Ab3FDOZY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 10:25:24 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46673 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754993Ab3FDOHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 10:07:47 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Oliver Neukum <oliver@neukum.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 13/70] USB: reset resume quirk needed by a hub
Date: Tue,  4 Jun 2013 15:06:29 +0100
Message-Id: <1370354846-14213-14-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370354846-14213-1-git-send-email-luis.henriques@canonical.com>
References: <1370354846-14213-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oliver@neukum.org>

commit bac6b03275184c912ad0818c9a0a736847804dca upstream.

Werner Fink has reported problems with this hub.

Signed-off-by: Oliver Neukum <oliver@neukum.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/core/quirks.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index 3f08c09..b801512 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -113,6 +113,9 @@ static const struct usb_device_id usb_quirk_list[] = {
 	/* Edirol SD-20 */
 	{ USB_DEVICE(0x0582, 0x0027), .driver_info = USB_QUIRK_RESET_RESUME },
 
+	/* Alcor Micro Corp. Hub */
+	{ USB_DEVICE(0x058f, 0x9254), .driver_info = USB_QUIRK_RESET_RESUME },
+
 	/* appletouch */
 	{ USB_DEVICE(0x05ac, 0x021a), .driver_info = USB_QUIRK_RESET_RESUME },
 
-- 
1.8.1.2

