Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956AbaKJXsR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 18:48:17 -0500
Received: from sauhun.de ([89.238.76.85]:57854 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751311AbaKJXsQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 18:48:16 -0500
From: Wolfram Sang <wsa@the-dreams.de>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>
Subject: [PATCH] Revert "core: platform: add warning if driver has no owner"
Date: Tue, 11 Nov 2014 00:49:25 +0100
Message-Id: <1415663365-2853-1-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is too noisy at the moment, triggered by codepaths not accessed on
our test-systems. Needs more investigation.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
 drivers/base/driver.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/base/driver.c b/drivers/base/driver.c
index 6b10ff3bb410..9e29943e56ca 100644
--- a/drivers/base/driver.c
+++ b/drivers/base/driver.c
@@ -151,9 +151,6 @@ int driver_register(struct device_driver *drv)
 
 	BUG_ON(!drv->bus->p);
 
-	if (!drv->owner)
-		printk(KERN_WARNING "Driver '%s' needs an owner", drv->name);
-
 	if ((drv->bus->probe && drv->probe) ||
 	    (drv->bus->remove && drv->remove) ||
 	    (drv->bus->shutdown && drv->shutdown))
-- 
2.1.1

