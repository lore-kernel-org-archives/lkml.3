Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759950Ab3BZJNB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 04:13:01 -0500
Received: from smtp4.mundo-r.com ([212.51.32.151]:61596 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759832Ab3BZJM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 04:12:59 -0500
X-Greylist: delayed 573 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Feb 2013 04:12:58 EST
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjEFAMZ5LFFbdWOb/2dsb2JhbABFhgi7WH8Wc4JNUoE+E4gXrzCQAo03gVODRwOWPYlihwWDCIFo
X-IPAS-Result: AjEFAMZ5LFFbdWOb/2dsb2JhbABFhgi7WH8Wc4JNUoE+E4gXrzCQAo03gVODRwOWPYlihwWDCIFo
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jens Taprogge <jens.taprogge@taprogge.org>,
        industrypack-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Subject: [PATCH] ipack: add missing put_device() after device_register() failed
Date: Tue, 26 Feb 2013 10:03:15 +0100
Message-Id: <1361869395-23110-1-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

put_device() must be called after device_register() fails,
since device_register() always initializes the refcount
on the device structure to one.

dev->id is free'd inside of ipack_device_release function.
So, it's not needed to do it here.

Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/ipack/ipack.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ipack/ipack.c b/drivers/ipack/ipack.c
index 7ec6b20..3588ccf 100644
--- a/drivers/ipack/ipack.c
+++ b/drivers/ipack/ipack.c
@@ -449,7 +449,7 @@ int ipack_device_register(struct ipack_device *dev)
 
 	ret = device_register(&dev->dev);
 	if (ret < 0)
-		kfree(dev->id);
+		put_device(&dev->dev);
 
 	return ret;
 }
-- 
1.7.10.4

