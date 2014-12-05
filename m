Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409AbaLEW4W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 17:56:22 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54400 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364AbaLEW4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 17:56:15 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 3.14 39/73] usb-quirks: Add reset-resume quirk for MS Wireless Laser Mouse 6000
Date: Fri,  5 Dec 2014 14:44:45 -0800
Message-Id: <20141205224435.113628039@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141205224433.921659956@linuxfoundation.org>
References: <20141205224433.921659956@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 263e80b43559a6103e178a9176938ce171b23872 upstream.

This wireless mouse receiver needs a reset-resume quirk to properly come
out of reset.

BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1165206
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/core/quirks.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -44,6 +44,9 @@ static const struct usb_device_id usb_qu
 	/* Creative SB Audigy 2 NX */
 	{ USB_DEVICE(0x041e, 0x3020), .driver_info = USB_QUIRK_RESET_RESUME },
 
+	/* Microsoft Wireless Laser Mouse 6000 Receiver */
+	{ USB_DEVICE(0x045e, 0x00e1), .driver_info = USB_QUIRK_RESET_RESUME },
+
 	/* Microsoft LifeCam-VX700 v2.0 */
 	{ USB_DEVICE(0x045e, 0x0770), .driver_info = USB_QUIRK_RESET_RESUME },
 


