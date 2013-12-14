Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690Ab3LNMxU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 07:53:20 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:37818 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053Ab3LNMxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 07:53:18 -0500
Date: Sat, 14 Dec 2013 18:23:10 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Matt Porter <mporter@kernel.crashing.org>,
        Alexandre Bounine <alexandre.bounine@idt.com>, josh@joshtriplett.org
Subject: [PATCH 3/3] drivers: rapidio: Remove unused function
 rio_remove_sysfs_dev_files() in rio-sysfs.c
Message-ID: <63f565ae73de586db2277390618fa781535a55f9.1386926041.git.rashika.kheria@gmail.com>
References: <8522e3b2fefdb6625e9d7ae651cfa2dfd4733293.1386926041.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8522e3b2fefdb6625e9d7ae651cfa2dfd4733293.1386926041.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the function rio_remove_sysfs_dev_files() in
rio-sysfs.c because it is unused.

Thus, it also eliminates the following warning in rio-sysfs.c:
drivers/rapidio/rio-sysfs.c:295:6: warning: no previous prototype for ‘rio_remove_sysfs_dev_files’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
---
 drivers/rapidio/rio-sysfs.c |   16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/drivers/rapidio/rio-sysfs.c b/drivers/rapidio/rio-sysfs.c
index e0221c6..8929b9e 100644
--- a/drivers/rapidio/rio-sysfs.c
+++ b/drivers/rapidio/rio-sysfs.c
@@ -286,22 +286,6 @@ int rio_create_sysfs_dev_files(struct rio_dev *rdev)
 	return err;
 }
 
-/**
- * rio_remove_sysfs_dev_files - cleanup RIO specific sysfs files
- * @rdev: device whose entries we should free
- *
- * Cleanup when @rdev is removed from sysfs.
- */
-void rio_remove_sysfs_dev_files(struct rio_dev *rdev)
-{
-	device_remove_bin_file(&rdev->dev, &rio_config_attr);
-	if (rdev->pef & RIO_PEF_SWITCH) {
-		device_remove_file(&rdev->dev, &dev_attr_routes);
-		device_remove_file(&rdev->dev, &dev_attr_lnext);
-		device_remove_file(&rdev->dev, &dev_attr_hopcount);
-	}
-}
-
 static ssize_t bus_scan_store(struct bus_type *bus, const char *buf,
 				size_t count)
 {
-- 
1.7.9.5

