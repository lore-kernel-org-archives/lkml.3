Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751498Ab3GXNYd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 09:24:33 -0400
Received: from mga14.intel.com ([143.182.124.37]:27917 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750863Ab3GXNYc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 09:24:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,735,1367996400"; 
   d="scan'208";a="336062326"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 3/3] mei: bus: do not overflow the device name buffer
Date: Wed, 24 Jul 2013 16:22:59 +0300
Message-Id: <1374672179-23949-4-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374672179-23949-1-git-send-email-tomas.winkler@intel.com>
References: <1374672179-23949-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. use strncmp for comparsion strncpy was used for copying
which may omit the final %NUL terminator
2. id->name is statically defined so we can use sizeof

Acked-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/bus.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/mei/bus.c b/drivers/misc/mei/bus.c
index 9ecd49a..a150a42 100644
--- a/drivers/misc/mei/bus.c
+++ b/drivers/misc/mei/bus.c
@@ -47,7 +47,7 @@ static int mei_cl_device_match(struct device *dev, struct device_driver *drv)
 	id = driver->id_table;
 
 	while (id->name[0]) {
-		if (!strcmp(dev_name(dev), id->name))
+		if (!strncmp(dev_name(dev), id->name, sizeof(id->name)))
 			return 1;
 
 		id++;
@@ -71,7 +71,7 @@ static int mei_cl_device_probe(struct device *dev)
 
 	dev_dbg(dev, "Device probe\n");
 
-	strncpy(id.name, dev_name(dev), MEI_CL_NAME_SIZE);
+	strncpy(id.name, dev_name(dev), sizeof(id.name));
 
 	return driver->probe(device, &id);
 }
-- 
1.8.1.2

