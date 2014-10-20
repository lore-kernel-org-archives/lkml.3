Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751609AbaJTPdS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 11:33:18 -0400
Received: from sauhun.de ([89.238.76.85]:56120 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751428AbaJTPdP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 11:33:15 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, Julia Lawall <julia.lawall@lip6.fr>,
        Wolfram Sang <wsa@the-dreams.de>
Subject: [PATCH 1/4] core: platform: add warning if driver has no owner
Date: Mon, 20 Oct 2014 17:33:41 +0200
Message-Id: <1413819224-12677-2-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1413819224-12677-1-git-send-email-wsa@the-dreams.de>
References: <1413819224-12677-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 9447057eaff8 ("platform_device: use a macro instead of
platform_driver_register") introduced a codepath which could result into
drivers having no owner. This went unnoticed for months, so add a
warning in case this happens again somewhere else somewhen.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
 drivers/base/driver.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/base/driver.c b/drivers/base/driver.c
index 9e29943e56ca..6b10ff3bb410 100644
--- a/drivers/base/driver.c
+++ b/drivers/base/driver.c
@@ -151,6 +151,9 @@ int driver_register(struct device_driver *drv)
 
 	BUG_ON(!drv->bus->p);
 
+	if (!drv->owner)
+		printk(KERN_WARNING "Driver '%s' needs an owner", drv->name);
+
 	if ((drv->bus->probe && drv->probe) ||
 	    (drv->bus->remove && drv->remove) ||
 	    (drv->bus->shutdown && drv->shutdown))
-- 
2.0.0

