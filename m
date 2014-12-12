Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965969AbaLLGrL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 01:47:11 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51733 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758620AbaLLGQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:16:54 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Hans de Goede" <hdegoede@redhat.com>
Date: Fri, 12 Dec 2014 06:14:25 +0000
Message-ID: <lsq.1418364865.176551897@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 156/164] usb-quirks: Add reset-resume quirk for MS
 Wireless Laser Mouse 6000
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.65-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 263e80b43559a6103e178a9176938ce171b23872 upstream.

This wireless mouse receiver needs a reset-resume quirk to properly come
out of reset.

BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1165206
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/core/quirks.c | 3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -43,6 +43,9 @@ static const struct usb_device_id usb_qu
 	/* Creative SB Audigy 2 NX */
 	{ USB_DEVICE(0x041e, 0x3020), .driver_info = USB_QUIRK_RESET_RESUME },
 
+	/* Microsoft Wireless Laser Mouse 6000 Receiver */
+	{ USB_DEVICE(0x045e, 0x00e1), .driver_info = USB_QUIRK_RESET_RESUME },
+
 	/* Microsoft LifeCam-VX700 v2.0 */
 	{ USB_DEVICE(0x045e, 0x0770), .driver_info = USB_QUIRK_RESET_RESUME },
 

