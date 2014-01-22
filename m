Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547AbaAVVYf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 16:24:35 -0500
Received: from qmta06.emeryville.ca.mail.comcast.net ([76.96.30.56]:47112 "EHLO
	qmta06.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752310AbaAVVYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 16:24:33 -0500
From: Shuah Khan <shuah.kh@samsung.com>
To: gregkh@linuxfoundation.org
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-usb@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        shuahkhan@gmail.com
Subject: [PATCH] staging/usbip: Change vhci_hcd store_attach() device information message to include speed string
Date: Wed, 22 Jan 2014 14:24:29 -0700
Message-Id: <1390425869-11910-1-git-send-email-shuah.kh@samsung.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change vhci_hcd store_attach() routine to include speed string in its device
information message. The current call to dev_info() prints out speed number
which is the enum number. Change to call usb_speed_string() to print speed
string in addition to the number.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/staging/usbip/vhci_sysfs.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/usbip/vhci_sysfs.c b/drivers/staging/usbip/vhci_sysfs.c
index 0141bc3..03e6edf 100644
--- a/drivers/staging/usbip/vhci_sysfs.c
+++ b/drivers/staging/usbip/vhci_sysfs.c
@@ -215,8 +215,9 @@ static ssize_t store_attach(struct device *dev, struct device_attribute *attr,
 		return -EINVAL;
 	}
 
-	dev_info(dev, "rhport(%u) sockfd(%d) devid(%u) speed(%u)\n",
-		 rhport, sockfd, devid, speed);
+	dev_info(dev,
+		 "rhport(%u) sockfd(%d) devid(%u) speed(%u) speed_str(%s)\n",
+		 rhport, sockfd, devid, speed, usb_speed_string(speed));
 
 	vdev->devid         = devid;
 	vdev->speed         = speed;
-- 
1.8.3.2

