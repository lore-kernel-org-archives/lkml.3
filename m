Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758050AbaEPSCa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 14:02:30 -0400
Received: from mail-1.atlantis.sk ([80.94.52.57]:35933 "EHLO
	mail-1.atlantis.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757109AbaEPSC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 14:02:29 -0400
To: linux-wireless@vger.kernel.org
Subject: [PATCH] [RESEND] orinoco_usb: Fix broken firmware load error checking
Cc: Kumar Amit Mehta <gmate.amit@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Content-Disposition: inline
From: Ondrej Zary <linux@rainbow-software.org>
Date: Fri, 16 May 2014 20:01:59 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201405162001.59695.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The check of ezusb_firmware_download() return value (added by commit
488ec878034eccb852267b0e27ce9d511f75c587) is broken because
ezusb_firmware_download() returns 1 on success.
This causes the driver not to work with the following error:
orinoco_usb: probe of 3-3:1.0 failed with error -14

Check the return value only for negative values.

This fix should be applied to -stable kernels too.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/net/wireless/orinoco/orinoco_usb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/orinoco/orinoco_usb.c b/drivers/net/wireless/orinoco/orinoco_usb.c
index f9805c9..1cbb783 100644
--- a/drivers/net/wireless/orinoco/orinoco_usb.c
+++ b/drivers/net/wireless/orinoco/orinoco_usb.c
@@ -1687,7 +1687,7 @@ static int ezusb_probe(struct usb_interface *interface,
 		firmware.code = fw_entry->data;
 	}
 	if (firmware.size && firmware.code) {
-		if (ezusb_firmware_download(upriv, &firmware))
+		if (ezusb_firmware_download(upriv, &firmware) < 0)
 			goto error;
 	} else {
 		err("No firmware to download");
-- 
Ondrej Zary
