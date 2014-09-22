Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744AbaIVTjj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 15:39:39 -0400
Received: from mga09.intel.com ([134.134.136.24]:47090 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752856AbaIVTjg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 15:39:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,573,1406617200"; 
   d="scan'208";a="577112548"
From: Octavian Purdila <octavian.purdila@intel.com>
To: sameo@linux.intel.com, lee.jones@linaro.org
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, johan@kernel.org,
        Octavian Purdila <octavian.purdila@intel.com>
Subject: [PATCH v2 2/2] mfd: viperboard: remove redundant OOM message and NULL pointer check
Date: Mon, 22 Sep 2014 22:39:19 +0300
Message-Id: <1411414759-7056-3-git-send-email-octavian.purdila@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411414759-7056-1-git-send-email-octavian.purdila@intel.com>
References: <1411414759-7056-1-git-send-email-octavian.purdila@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
---
 drivers/mfd/viperboard.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/mfd/viperboard.c b/drivers/mfd/viperboard.c
index 5f62f4e..d27c131 100644
--- a/drivers/mfd/viperboard.c
+++ b/drivers/mfd/viperboard.c
@@ -59,10 +59,8 @@ static int vprbrd_probe(struct usb_interface *interface,
 
 	/* allocate memory for our device state and initialize it */
 	vb = kzalloc(sizeof(*vb), GFP_KERNEL);
-	if (vb == NULL) {
-		dev_err(&interface->dev, "Out of memory\n");
+	if (vb == NULL)
 		return -ENOMEM;
-	}
 
 	vb->buf = kzalloc(sizeof(struct vprbrd_i2c_write_msg), GFP_KERNEL);
 	if (vb->buf == NULL) {
@@ -109,11 +107,9 @@ static int vprbrd_probe(struct usb_interface *interface,
 	return 0;
 
 error:
-	if (vb) {
-		usb_put_dev(vb->usb_dev);
-		kfree(vb->buf);
-		kfree(vb);
-	}
+	usb_put_dev(vb->usb_dev);
+	kfree(vb->buf);
+	kfree(vb);
 
 	return ret;
 }
-- 
1.9.1

