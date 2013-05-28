Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758979Ab3E1Dyc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 23:54:32 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52601 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758900Ab3E1DyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 23:54:08 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Oliver Neukum" <oliver@neukum.org>
Date: Tue, 28 May 2013 04:49:53 +0100
Message-ID: <lsq.1369712993.210656899@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [43/94] USB: reset resume quirk needed by a hub
In-Reply-To: <lsq.1369712992.755341692@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.46-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oliver@neukum.org>

commit bac6b03275184c912ad0818c9a0a736847804dca upstream.

Werner Fink has reported problems with this hub.

Signed-off-by: Oliver Neukum <oliver@neukum.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/core/quirks.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -88,6 +88,9 @@ static const struct usb_device_id usb_qu
 	/* Edirol SD-20 */
 	{ USB_DEVICE(0x0582, 0x0027), .driver_info = USB_QUIRK_RESET_RESUME },
 
+	/* Alcor Micro Corp. Hub */
+	{ USB_DEVICE(0x058f, 0x9254), .driver_info = USB_QUIRK_RESET_RESUME },
+
 	/* appletouch */
 	{ USB_DEVICE(0x05ac, 0x021a), .driver_info = USB_QUIRK_RESET_RESUME },
 

