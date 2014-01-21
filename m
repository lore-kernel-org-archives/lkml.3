Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684AbaAUTSm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 14:18:42 -0500
Received: from qmta05.emeryville.ca.mail.comcast.net ([76.96.30.48]:51133 "EHLO
	qmta05.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751749AbaAUTSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 14:18:40 -0500
From: Shuah Khan <shuah.kh@samsung.com>
To: gregkh@linuxfoundation.org, geert@linux-m68k.org, navinp@cdac.in,
        ke42caxa@cip.cs.fau.de, harvey.huawei.yang@gmail.com
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-usb@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        shuahkhan@gmail.com
Subject: [PATCH] staging/usbip: remove vhci_hcd vhci_hub_status change message
Date: Tue, 21 Jan 2014 12:18:34 -0700
Message-Id: <1390331914-16291-1-git-send-email-shuah.kh@samsung.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When vhci_hcd is enabled, the following message floods the dmesg buffer.
This message doesn't provide any useful information other than cluttering
the dmesg buffer. Fix it by removing the message. There is another debug
message in this routine that dumps detailed port status change information.

[ 4062.716662] vhci_hcd: changed 0

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/staging/usbip/vhci_hcd.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/usbip/vhci_hcd.c b/drivers/staging/usbip/vhci_hcd.c
index 72391ef..adb6201 100644
--- a/drivers/staging/usbip/vhci_hcd.c
+++ b/drivers/staging/usbip/vhci_hcd.c
@@ -205,8 +205,6 @@ static int vhci_hub_status(struct usb_hcd *hcd, char *buf)
 		}
 	}
 
-	pr_info("changed %d\n", changed);
-
 	if ((hcd->state == HC_STATE_SUSPENDED) && (changed == 1))
 		usb_hcd_resume_root_hub(hcd);
 
-- 
1.8.3.2

