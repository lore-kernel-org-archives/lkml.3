Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872AbaCFSgi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 13:36:38 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:54440 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbaCFSgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 13:36:37 -0500
Date: Thu, 6 Mar 2014 10:36:34 -0800
From: John de la Garza <john@jjdev.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, shuah.kh@samsung.com
Subject: [PATCH] usbip:vhci_sysfs.c: check return value of sscanf
Message-ID: <20140306183631.GA31595@vega.jjdev.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added code to check return value of sscanf.

Signed-off-by: John de la Garza <john@jjdev.com>
---
 drivers/staging/usbip/vhci_sysfs.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/usbip/vhci_sysfs.c b/drivers/staging/usbip/vhci_sysfs.c
index 03e6edf..82dd49f 100644
--- a/drivers/staging/usbip/vhci_sysfs.c
+++ b/drivers/staging/usbip/vhci_sysfs.c
@@ -114,7 +114,8 @@ static ssize_t store_detach(struct device *dev, struct device_attribute *attr,
 	int err;
 	__u32 rhport = 0;
 
-	sscanf(buf, "%u", &rhport);
+	if (sscanf(buf, "%u", &rhport) != 1)
+		return -EINVAL;
 
 	/* check rhport */
 	if (rhport >= VHCI_NPORTS) {
@@ -182,7 +183,8 @@ static ssize_t store_attach(struct device *dev, struct device_attribute *attr,
 	 * @devid: unique device identifier in a remote host
 	 * @speed: usb device speed in a remote host
 	 */
-	sscanf(buf, "%u %u %u %u", &rhport, &sockfd, &devid, &speed);
+	if (sscanf(buf, "%u %u %u %u", &rhport, &sockfd, &devid, &speed) != 1)
+		return -EINVAL;
 
 	usbip_dbg_vhci_sysfs("rhport(%u) sockfd(%u) devid(%u) speed(%u)\n",
 			     rhport, sockfd, devid, speed);
-- 
1.7.10.4

