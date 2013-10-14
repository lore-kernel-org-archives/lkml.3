Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757306Ab3JNTif (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 15:38:35 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38026 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756222Ab3JNTid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 15:38:33 -0400
Message-ID: <525C481E.1010908@infradead.org>
Date: Mon, 14 Oct 2013 12:38:06 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
CC: Mark Brown <broonie@kernel.org>,
        Harshavardhan R Kharche <harshavardhan.r.kharche@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nikhil Rao <nikhil.rao@intel.com>, Sudeep Dutt <sudeep.dutt@intel.com>
Subject: [PATCH -next] misc: fix various misc/mic/host/ build errors
References: <1381762088-18880-1-git-send-email-treding@nvidia.com>
In-Reply-To: <1381762088-18880-1-git-send-email-treding@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Fix various build errors (on x86_64) for drivers/misc/mic/host/:

  drivers/misc/mic/host/mic_main.c:378:3: error: too many arguments to function 'sysfs_get_dirent'
  drivers/misc/mic/host/mic_intr.h:134:58: warning: 'struct pci_dev' declared inside parameter list [enabled by default]
  drivers/misc/mic/host/mic_intr.h:134:58: warning: its scope is only this definition or declaration, which is probably not what you want [enabled by default]
  drivers/misc/mic/host/mic_intr.h:135:58: warning: 'struct pci_dev' declared inside parameter list [enabled by default]
  drivers/misc/mic/host/mic_device.h:169:2: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]
  drivers/misc/mic/host/mic_device.h: In function 'mic_mmio_read':
  drivers/misc/mic/host/mic_device.h:169:2: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]
  drivers/misc/mic/host/mic_device.h: In function 'mic_mmio_write':
  drivers/misc/mic/host/mic_device.h:183:2: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Harshavardhan R Kharche <harshavardhan.r.kharche@intel.com>
Cc: Ashutosh Dixit <ashutosh.dixit@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Nikhil Rao <nikhil.rao@intel.com>
Cc: Sudeep Dutt <sudeep.dutt@intel.com>
---
 drivers/misc/mic/host/mic_device.h |    1 +
 drivers/misc/mic/host/mic_intr.h   |    1 +
 drivers/misc/mic/host/mic_main.c   |    3 +--
 3 files changed, 3 insertions(+), 2 deletions(-)

--- next-2013-1014.orig/drivers/misc/mic/host/mic_main.c
+++ next-2013-1014/drivers/misc/mic/host/mic_main.c
@@ -374,8 +374,7 @@ static int mic_probe(struct pci_dev *pde
 			"device_create_with_groups failed rc %d\n", rc);
 		goto smpt_uninit;
 	}
-	mdev->state_sysfs = sysfs_get_dirent(mdev->sdev->kobj.sd,
-		NULL, "state");
+	mdev->state_sysfs = sysfs_get_dirent(mdev->sdev->kobj.sd, "state");
 	if (!mdev->state_sysfs) {
 		rc = -ENODEV;
 		dev_err(&pdev->dev, "sysfs_get_dirent failed rc %d\n", rc);
--- next-2013-1014.orig/drivers/misc/mic/host/mic_device.h
+++ next-2013-1014/drivers/misc/mic/host/mic_device.h
@@ -24,6 +24,7 @@
 #include <linux/cdev.h>
 #include <linux/idr.h>
 #include <linux/notifier.h>
+#include <asm-generic/iomap.h>
 
 #include "mic_intr.h"
 
--- next-2013-1014.orig/drivers/misc/mic/host/mic_intr.h
+++ next-2013-1014/drivers/misc/mic/host/mic_intr.h
@@ -131,6 +131,7 @@ struct mic_irq *mic_request_irq(struct m
 
 void mic_free_irq(struct mic_device *mdev,
 		struct mic_irq *cookie, void *data);
+struct pci_dev;
 int mic_setup_interrupts(struct mic_device *mdev, struct pci_dev *pdev);
 void mic_free_interrupts(struct mic_device *mdev, struct pci_dev *pdev);
 void mic_intr_restore(struct mic_device *mdev);
