Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760151Ab3EBBqU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 21:46:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12916 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759807Ab3EBBp5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 21:45:57 -0400
Date: Thu, 2 May 2013 04:45:46 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>, Asias He <asias@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org
Subject: [PATCH 3/3] vhost_scsi: module rename
Message-ID: <8afa6e02683e4b20e11a4712d332a6b4545759dd.1367459046.git.mst@redhat.com>
References: <cover.1367459045.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1367459045.git.mst@redhat.com>
X-Mutt-Fcc: =sent
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename module and update Kconfig and Makefile.
Add alias for compatibility with old userspace
scripts if any.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/vhost/Kconfig     | 10 +++++++---
 drivers/vhost/Kconfig.tcm |  6 ------
 drivers/vhost/Makefile    |  4 ++--
 drivers/vhost/scsi.c      |  3 ++-
 4 files changed, 11 insertions(+), 12 deletions(-)
 delete mode 100644 drivers/vhost/Kconfig.tcm

diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
index bf24317..26a64e5 100644
--- a/drivers/vhost/Kconfig
+++ b/drivers/vhost/Kconfig
@@ -9,6 +9,10 @@ config VHOST_NET
 	  To compile this driver as a module, choose M here: the module will
 	  be called vhost_net.
 
-if STAGING
-source "drivers/vhost/Kconfig.tcm"
-endif
+config VHOST_SCSI
+	tristate "VHOST_SCSI TCM fabric driver"
+	depends on TARGET_CORE && EVENTFD && m
+	default n
+	---help---
+	Say M here to enable the vhost_scsi TCM fabric module
+	for use with virtio-scsi guests
diff --git a/drivers/vhost/Kconfig.tcm b/drivers/vhost/Kconfig.tcm
deleted file mode 100644
index 7e3aa28..0000000
--- a/drivers/vhost/Kconfig.tcm
+++ /dev/null
@@ -1,6 +0,0 @@
-config TCM_VHOST
-	tristate "TCM_VHOST fabric module"
-	depends on TARGET_CORE && EVENTFD && m
-	default n
-	---help---
-	Say M here to enable the TCM_VHOST fabric module for use with virtio-scsi guests
diff --git a/drivers/vhost/Makefile b/drivers/vhost/Makefile
index 6ea9cec..ef21d5f 100644
--- a/drivers/vhost/Makefile
+++ b/drivers/vhost/Makefile
@@ -1,5 +1,5 @@
 obj-$(CONFIG_VHOST_NET) += vhost_net.o
 vhost_net-y := vhost.o net.o
 
-obj-$(CONFIG_TCM_VHOST) += tcm_vhost.o
-tcm_vhost-y := scsi.o
+obj-$(CONFIG_VHOST_SCSI) += vhost_scsi.o
+vhost_scsi-y := scsi.o
diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index eb1aa56..5179f7a 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -2136,7 +2136,8 @@ static void tcm_vhost_exit(void)
 	destroy_workqueue(tcm_vhost_workqueue);
 };
 
-MODULE_DESCRIPTION("TCM_VHOST series fabric driver");
+MODULE_DESCRIPTION("VHOST_SCSI series fabric driver");
+MODULE_ALIAS("tcm_vhost");
 MODULE_LICENSE("GPL");
 module_init(tcm_vhost_init);
 module_exit(tcm_vhost_exit);
-- 
MST
