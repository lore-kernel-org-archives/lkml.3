Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932210Ab3FEVBr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 17:01:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36246 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757653Ab3FEUxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 16:53:19 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Oliver Neukum <oliver@neukum.org>
Subject: [ 10/33] USB: reset resume quirk needed by a hub
Date: Wed,  5 Jun 2013 13:52:48 -0700
Message-Id: <20130605204704.798620111@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130605204702.359510786@linuxfoundation.org>
References: <20130605204702.359510786@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oliver@neukum.org>

commit bac6b03275184c912ad0818c9a0a736847804dca upstream.

Werner Fink has reported problems with this hub.

Signed-off-by: Oliver Neukum <oliver@neukum.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/core/quirks.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -110,6 +110,9 @@ static const struct usb_device_id usb_qu
 	/* Edirol SD-20 */
 	{ USB_DEVICE(0x0582, 0x0027), .driver_info = USB_QUIRK_RESET_RESUME },
 
+	/* Alcor Micro Corp. Hub */
+	{ USB_DEVICE(0x058f, 0x9254), .driver_info = USB_QUIRK_RESET_RESUME },
+
 	/* appletouch */
 	{ USB_DEVICE(0x05ac, 0x021a), .driver_info = USB_QUIRK_RESET_RESUME },
 


