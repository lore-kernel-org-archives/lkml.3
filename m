Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752327AbaHSKiZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 06:38:25 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:52506 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423AbaHSKiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 06:38:24 -0400
From: Arjun Sreedharan <arjun024@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] usb: use kcalloc instead of kzalloc
Date: Tue, 19 Aug 2014 16:08:01 +0530
Message-Id: <1408444681-1601-1-git-send-email-arjun024@gmail.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kcalloc has protection from integer overflows
which could arise from the multiplication of
number of elements and size.

Signed-off-by: Arjun Sreedharan <arjun024@gmail.com>
---
 drivers/usb/core/config.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/core/config.c b/drivers/usb/core/config.c
index b2a540b..abde67d 100644
--- a/drivers/usb/core/config.c
+++ b/drivers/usb/core/config.c
@@ -318,7 +318,7 @@ static int usb_parse_interface(struct device *ddev, int cfgno,
 	struct usb_interface_cache *intfc;
 	struct usb_host_interface *alt;
 	int i, n;
-	int len, retval;
+	int retval;
 	int num_ep, num_ep_orig;
 
 	d = (struct usb_interface_descriptor *) buffer;
@@ -380,8 +380,7 @@ static int usb_parse_interface(struct device *ddev, int cfgno,
 
 	if (num_ep > 0) {
 		/* Can't allocate 0 bytes */
-		len = sizeof(struct usb_host_endpoint) * num_ep;
-		alt->endpoint = kzalloc(len, GFP_KERNEL);
+		alt->endpoint = kcalloc(num_ep, sizeof(struct usb_host_endpoint), GFP_KERNEL);
 		if (!alt->endpoint)
 			return -ENOMEM;
 	}
@@ -683,13 +682,11 @@ int usb_get_configuration(struct usb_device *dev)
 		return -EINVAL;
 	}
 
-	length = ncfg * sizeof(struct usb_host_config);
-	dev->config = kzalloc(length, GFP_KERNEL);
+	dev->config = kcalloc(ncfg, sizeof(struct usb_host_config), GFP_KERNEL);
 	if (!dev->config)
 		goto err2;
 
-	length = ncfg * sizeof(char *);
-	dev->rawdescriptors = kzalloc(length, GFP_KERNEL);
+	dev->rawdescriptors = kcalloc(ncfg, sizeof(char *), GFP_KERNEL);
 	if (!dev->rawdescriptors)
 		goto err2;
 
-- 
1.8.1.msysgit.1

