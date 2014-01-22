Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755075AbaAVQiV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 11:38:21 -0500
Received: from qmta05.emeryville.ca.mail.comcast.net ([76.96.30.48]:52999 "EHLO
	qmta05.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752153AbaAVQiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 11:38:18 -0500
From: Shuah Khan <shuah.kh@samsung.com>
To: gregkh@linuxfoundation.org
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-usb@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        shuahkhan@gmail.com
Subject: [PATCH] staging/usbip: Fix vhci_hcd attach failure error message to be informative
Date: Wed, 22 Jan 2014 09:38:14 -0700
Message-Id: <1390408694-2298-1-git-send-email-shuah.kh@samsung.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When attach fails due to unsupported and/or invalid bus speed, the message
vhci_hcd prints out doesn't include any useful information as to what caused
the failure. Change the message to be informative and use usb_speed_string()
to get the right speed string from usb common.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/staging/usbip/vhci_sysfs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/usbip/vhci_sysfs.c b/drivers/staging/usbip/vhci_sysfs.c
index 9b51586..0141bc3 100644
--- a/drivers/staging/usbip/vhci_sysfs.c
+++ b/drivers/staging/usbip/vhci_sysfs.c
@@ -149,7 +149,8 @@ static int valid_args(__u32 rhport, enum usb_device_speed speed)
 	case USB_SPEED_WIRELESS:
 		break;
 	default:
-		pr_err("speed %d\n", speed);
+		pr_err("Failed attach request for unsupported USB speed: %s\n",
+			usb_speed_string(speed));
 		return -EINVAL;
 	}
 
-- 
1.8.3.2

