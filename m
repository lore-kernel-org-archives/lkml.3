Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759617Ab3FCSON (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 14:14:13 -0400
Received: from mail-bk0-f47.google.com ([209.85.214.47]:49670 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758101Ab3FCSOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 14:14:07 -0400
From: Marcus Overhagen <marcus.overhagen@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] staging: rts5139: Fix SD card detection on Samsung NP730U3E Ultrabook
Date: Mon,  3 Jun 2013 20:14:01 +0200
Message-Id: <1370283242-24434-2-git-send-email-marcus.overhagen@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370283242-24434-1-git-send-email-marcus.overhagen@gmail.com>
References: <1370283242-24434-1-git-send-email-marcus.overhagen@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The timeout detection implemented in this driver isn't very
robust. Although the USB interrupt transfer was successful,
the polling thread often reported timeouts because the 50ms
had expired before it got scheduled, and the SD card wasn't
detected. Increasing it to 100ms, as used in other places of
this driver, makes it work.

Signed-off-by: Marcus Overhagen <marcus.overhagen@gmail.com>
---
 drivers/staging/rts5139/rts51x_transport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rts5139/rts51x_transport.c b/drivers/staging/rts5139/rts51x_transport.c
index 89e4d80..c573618 100644
--- a/drivers/staging/rts5139/rts51x_transport.c
+++ b/drivers/staging/rts5139/rts51x_transport.c
@@ -640,7 +640,7 @@ int rts51x_get_epc_status(struct rts51x_chip *chip, u16 *status)
 	usb_fill_int_urb(chip->usb->intr_urb, chip->usb->pusb_dev, pipe,
 			 status, 2, urb_done_completion, &urb_done, 1);
 
-	result = rts51x_msg_common(chip, chip->usb->intr_urb, 50);
+	result = rts51x_msg_common(chip, chip->usb->intr_urb, 100);
 
 	return interpret_urb_result(chip, pipe, 2, result,
 				    chip->usb->intr_urb->actual_length);
-- 
1.8.1.2

