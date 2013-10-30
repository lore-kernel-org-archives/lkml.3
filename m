Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188Ab3J3ADD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 20:03:03 -0400
Received: from mga14.intel.com ([143.182.124.37]:30975 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751292Ab3J3ADA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 20:03:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,596,1378882800"; 
   d="scan'208";a="419418229"
From: Ashutosh Dixit <ashutosh.dixit@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jim Davis <jim.epost@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, Fengguang Wu <fengguang.wu@intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Dasaratharaman Chandramouli 
	<dasaratharaman.chandramouli@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Sudeep Dutt <sudeep.dutt@intel.com>, Nikhil Rao <nikhil.rao@intel.com>,
        Harshavardhan R Kharche <harshavardhan.r.kharche@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        "Yaozu (Eddie) Dong" <eddie.dong@intel.com>
Subject: [PATCH char-misc-next] misc: mic: Fixes for randconfig build errors and warnings.
Date: Tue, 29 Oct 2013 17:09:59 -0700
Message-Id: <6af2b0097e54db275d06b71f8a8d33dbf7247b5e.1383087862.git.ashutosh.dixit@intel.com>
X-Mailer: git-send-email 1.8.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the build errors and warnings reported at
https://lkml.org/lkml/2013/10/29/421.

Co-author: Dasaratharaman Chandramouli <dasaratharaman.chandramouli@intel.com>
Reviewed-by: Sudeep Dutt <sudeep.dutt@intel.com>
Reported-by: Jim Davis <jim.epost@gmail.com>
Signed-off-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
---
 drivers/misc/mic/host/mic_boot.c   | 1 +
 drivers/misc/mic/host/mic_fops.c   | 1 +
 drivers/misc/mic/host/mic_virtio.c | 4 ++--
 3 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/mic/host/mic_boot.c b/drivers/misc/mic/host/mic_boot.c
index d56b8bf..b079c65 100644
--- a/drivers/misc/mic/host/mic_boot.c
+++ b/drivers/misc/mic/host/mic_boot.c
@@ -20,6 +20,7 @@
  */
 #include <linux/delay.h>
 #include <linux/firmware.h>
+#include <linux/pci.h>
 
 #include <linux/mic_common.h>
 #include "../common/mic_dev.h"
diff --git a/drivers/misc/mic/host/mic_fops.c b/drivers/misc/mic/host/mic_fops.c
index 8dc6ff1..85776d7 100644
--- a/drivers/misc/mic/host/mic_fops.c
+++ b/drivers/misc/mic/host/mic_fops.c
@@ -19,6 +19,7 @@
  *
  */
 #include <linux/poll.h>
+#include <linux/pci.h>
 
 #include <linux/mic_common.h>
 #include "../common/mic_dev.h"
diff --git a/drivers/misc/mic/host/mic_virtio.c b/drivers/misc/mic/host/mic_virtio.c
index 0c883cd..5b8494b 100644
--- a/drivers/misc/mic/host/mic_virtio.c
+++ b/drivers/misc/mic/host/mic_virtio.c
@@ -517,10 +517,10 @@ int mic_virtio_add_device(struct mic_vdev *mvdev,
 			void __user *argp)
 {
 	struct mic_device *mdev = mvdev->mdev;
-	struct mic_device_desc *dd;
+	struct mic_device_desc *dd = NULL;
 	struct mic_vqconfig *vqconfig;
 	int vr_size, i, j, ret;
-	u8 type;
+	u8 type = 0;
 	s8 db;
 	char irqname[10];
 	struct mic_bootparam *bootparam = mdev->dp;
-- 
1.8.2.3

