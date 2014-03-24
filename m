Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088AbaCXXMQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 19:12:16 -0400
Received: from qmta03.emeryville.ca.mail.comcast.net ([76.96.30.32]:39952 "EHLO
	qmta03.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751737AbaCXXMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 19:12:14 -0400
From: Shuah Khan <shuah.kh@samsung.com>
To: gregkh@linuxfoundation.org, john@jjdev.com, ced@ryick.net
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-usb@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        shuahkhan@gmail.com
Subject: [PATCH] staging/usbip: fix store_attach() sscanf return value check
Date: Mon, 24 Mar 2014 17:12:09 -0600
Message-Id: <1395702729-3281-1-git-send-email-shuah.kh@samsung.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix commit - 88fa1ebfa21b5deaaad2dc88ecd9f6af91796cf7
This commit added return value check for sscanf() that parses the
input buffer for four input items. However, the return value check
is incorrect, as it checks for one input item instead of four which
is what it is expecting in the input buffer. As a result, sscanf()
will always fail even when the input buffer is correct.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/staging/usbip/vhci_sysfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/usbip/vhci_sysfs.c b/drivers/staging/usbip/vhci_sysfs.c
index e098032..1ff24e9 100644
--- a/drivers/staging/usbip/vhci_sysfs.c
+++ b/drivers/staging/usbip/vhci_sysfs.c
@@ -183,7 +183,7 @@ static ssize_t store_attach(struct device *dev, struct device_attribute *attr,
 	 * @devid: unique device identifier in a remote host
 	 * @speed: usb device speed in a remote host
 	 */
-	if (sscanf(buf, "%u %u %u %u", &rhport, &sockfd, &devid, &speed) != 1)
+	if (sscanf(buf, "%u %u %u %u", &rhport, &sockfd, &devid, &speed) != 4)
 		return -EINVAL;
 
 	usbip_dbg_vhci_sysfs("rhport(%u) sockfd(%u) devid(%u) speed(%u)\n",
-- 
1.7.10.4

