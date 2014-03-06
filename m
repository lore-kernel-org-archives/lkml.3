Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751647AbaCFXwF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 18:52:05 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:39006 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbaCFXwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 18:52:03 -0500
Date: Thu, 6 Mar 2014 15:51:59 -0800
From: John de la Garza <john@jjdev.com>
To: linux-kernel@vger.kernel.org
Cc: linux-usb@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH] usbip:usbip_common.c: check return value of sscanf
Message-ID: <20140306235156.GA3498@vega.jjdev.com>
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
 drivers/staging/usbip/usbip_common.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/usbip/usbip_common.c b/drivers/staging/usbip/usbip_common.c
index 4a2aab1..2a11233 100644
--- a/drivers/staging/usbip/usbip_common.c
+++ b/drivers/staging/usbip/usbip_common.c
@@ -55,7 +55,8 @@ static ssize_t usbip_debug_store(struct device *dev,
 				 struct device_attribute *attr, const char *buf,
 				 size_t count)
 {
-	sscanf(buf, "%lx", &usbip_debug_flag);
+	if (sscanf(buf, "%lx", &usbip_debug_flag) != 1)
+		return -EINVAL;
 	return count;
 }
 DEVICE_ATTR_RW(usbip_debug);
-- 
1.7.10.4

