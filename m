Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764689AbbA2Dr7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 22:47:59 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:41235 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754808AbbA2BZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:25:17 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Cihangir Akturk <cakturk@gmail.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Kiran Padwal <kiran.padwal21@gmail.com>,
        Gulsah Kose <gulsah.1004@gmail.com>,
        Aybuke Ozdemir <aybuke.147@gmail.com>,
        Abel Moyo <abelmoyo.ab@gmail.com>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Dan Carpenter <dan.carpenter@oracle.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: gdm724x: gdm_usb: Removed variables that is never used
Date: Wed, 28 Jan 2015 23:45:50 +0100
Message-Id: <1422485150-10877-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Variable ar assigned a value that is never used.
I have also removed all the code that thereby serves no purpose.

This was found using a static code analysis program called cppcheck

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/gdm724x/gdm_usb.c |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/staging/gdm724x/gdm_usb.c b/drivers/staging/gdm724x/gdm_usb.c
index d2a3b35..28fa01e 100644
--- a/drivers/staging/gdm724x/gdm_usb.c
+++ b/drivers/staging/gdm724x/gdm_usb.c
@@ -891,14 +891,10 @@ static void gdm_usb_disconnect(struct usb_interface *intf)
 {
 	struct phy_dev *phy_dev;
 	struct lte_udev *udev;
-	u16 idVendor, idProduct;
 	struct usb_device *usbdev;
 
 	usbdev = interface_to_usbdev(intf);
 
-	idVendor = __le16_to_cpu(usbdev->descriptor.idVendor);
-	idProduct = __le16_to_cpu(usbdev->descriptor.idProduct);
-
 	phy_dev = usb_get_intfdata(intf);
 
 	udev = phy_dev->priv_dev;
-- 
1.7.10.4

