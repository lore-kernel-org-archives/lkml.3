Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751427AbaETVdi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 17:33:38 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:36318 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747AbaETVdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 17:33:37 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Larry Finger <Larry.Finger@lwfinger.net>,
        Florian Schilhabel <florian.c.schilhabel@googlemail.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: rtl8712: usb_intf.c:  Fix for possible null pointer dereference
Date: Tue, 20 May 2014 23:34:25 +0200
Message-Id: <1400621665-7746-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is otherwise a risk of a possible null pointer dereference.

Was largely found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/rtl8712/usb_intf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8712/usb_intf.c b/drivers/staging/rtl8712/usb_intf.c
index bbd5888..ba74354 100644
--- a/drivers/staging/rtl8712/usb_intf.c
+++ b/drivers/staging/rtl8712/usb_intf.c
@@ -595,7 +595,7 @@ static int r871xu_drv_init(struct usb_interface *pusb_intf,
 error:
 	usb_put_dev(udev);
 	usb_set_intfdata(pusb_intf, NULL);
-	if (padapter->dvobj_deinit != NULL)
+	if (padapter && padapter->dvobj_deinit != NULL)
 		padapter->dvobj_deinit(padapter);
 	if (pnetdev)
 		free_netdev(pnetdev);
-- 
1.7.10.4

