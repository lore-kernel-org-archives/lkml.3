Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756700AbaFEA0b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 20:26:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40092 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065AbaFDXWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:22:19 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>,
        Tedd Ho-Jeong An <tedd.an@intel.com>,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Subject: [PATCH 3.14 098/228] Revert "Bluetooth: Enable autosuspend for Intel Bluetooth device"
Date: Wed,  4 Jun 2014 16:22:07 -0700
Message-Id: <20140604232351.194835527@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marcel Holtmann <marcel@holtmann.org>

commit 3c49aa852e00978ba2f1a4d1e4598a0c669a5347 upstream.

This reverts commit d2bee8fb6e18f6116aada39851918473761f7ab1.

Enabling autosuspend for Intel Bluetooth devices has been shown to not
work reliable. It does work for some people with certain combinations
of USB host controllers, but for others it puts the device to sleep and
it will not wake up for any event.

These events can be important ones like HCI Inquiry Complete or HCI
Connection Request. The events will arrive as soon as you poke the
device with a new command, but that is not something we can do in
these cases.

Initially there were patches to the xHCI USB controller that fixed
this for some people, but not for all. This could be well a problem
somewhere in the USB subsystem or in the USB host controllers or
just plain a hardware issue somewhere. At this moment we just do
not know and the only safe action is to revert this patch.

Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Cc: Tedd Ho-Jeong An <tedd.an@intel.com>
Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/bluetooth/btusb.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -1479,10 +1479,8 @@ static int btusb_probe(struct usb_interf
 	if (id->driver_info & BTUSB_BCM92035)
 		hdev->setup = btusb_setup_bcm92035;
 
-	if (id->driver_info & BTUSB_INTEL) {
-		usb_enable_autosuspend(data->udev);
+	if (id->driver_info & BTUSB_INTEL)
 		hdev->setup = btusb_setup_intel;
-	}
 
 	/* Interface numbers are hardcoded in the specification */
 	data->isoc = usb_ifnum_to_if(data->udev, 1);


