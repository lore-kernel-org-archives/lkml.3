Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757521AbaFANm3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 09:42:29 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:56938 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980AbaFANm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 09:42:27 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Johan Hovold <jhovold@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] usb: class: usbtmc.c:  Cleaning up uninitialized variables
Date: Sun,  1 Jun 2014 15:43:19 +0200
Message-Id: <1401630199-19830-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a risk that the variable will be used without being initialized.

This was largely found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/usb/class/usbtmc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/class/usbtmc.c b/drivers/usb/class/usbtmc.c
index cfbec9c..9f5397f 100644
--- a/drivers/usb/class/usbtmc.c
+++ b/drivers/usb/class/usbtmc.c
@@ -711,7 +711,7 @@ static int usbtmc_ioctl_clear(struct usbtmc_device_data *data)
 	u8 *buffer;
 	int rv;
 	int n;
-	int actual;
+	int actual = 0;
 	int max_size;
 
 	dev = &data->intf->dev;
-- 
1.7.10.4

