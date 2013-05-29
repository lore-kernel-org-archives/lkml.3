Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965420Ab3E2J3T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 05:29:19 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:38890 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965342Ab3E2J3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 05:29:17 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+yackYocTD1iAi8x+OWJ8KkvZ5rDWwclRyw==
X-RZG-CLASS-ID: mo00
From: Olaf Hering <olaf@aepfle.de>
To: kys@microsoft.com, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Olaf Hering <olaf@aepfle.de>
Subject: [PATCH] Drivers: hv: remove HV_DRV_VERSION
Date: Wed, 29 May 2013 11:29:07 +0200
Message-Id: <1369819747-6218-1-git-send-email-olaf@aepfle.de>
X-Mailer: git-send-email 1.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove HV_DRV_VERSION, it has no meaning for upstream drivers.

Initially it was supposed to show the "Linux Integration Services"
version, now it is not in sync anymore with the out-of-tree drivers
available from the MSFT website.

The only place where a version string is still required is the KVP
command "IntegrationServicesVersion" which is handled by
tools/hv/hv_kvp_daemon.c. To satisfy such KVP request from the host pass
the current string to the daemon during KVP userland registration.

Signed-off-by: Olaf Hering <olaf@aepfle.de>
---
 drivers/hid/hid-hyperv.c        |  1 -
 drivers/hv/hv_balloon.c         |  1 -
 drivers/hv/hv_kvp.c             |  2 ++
 drivers/hv/hv_util.c            |  1 -
 drivers/hv/vmbus_drv.c          |  1 -
 drivers/net/hyperv/netvsc_drv.c |  2 --
 drivers/scsi/storvsc_drv.c      |  1 -
 drivers/video/hyperv_fb.c       |  1 -
 include/linux/hyperv.h          | 21 ---------------------
 9 files changed, 2 insertions(+), 29 deletions(-)

diff --git a/drivers/hid/hid-hyperv.c b/drivers/hid/hid-hyperv.c
index aa3fec0..05f3e96 100644
--- a/drivers/hid/hid-hyperv.c
+++ b/drivers/hid/hid-hyperv.c
@@ -592,6 +592,5 @@ static void __exit mousevsc_exit(void)
 }
 
 MODULE_LICENSE("GPL");
-MODULE_VERSION(HV_DRV_VERSION);
 module_init(mousevsc_init);
 module_exit(mousevsc_exit);
diff --git a/drivers/hv/hv_balloon.c b/drivers/hv/hv_balloon.c
index 4c605c7..c4b50a5 100644
--- a/drivers/hv/hv_balloon.c
+++ b/drivers/hv/hv_balloon.c
@@ -1521,5 +1521,4 @@ static int __init init_balloon_drv(void)
 module_init(init_balloon_drv);
 
 MODULE_DESCRIPTION("Hyper-V Balloon");
-MODULE_VERSION(HV_DRV_VERSION);
 MODULE_LICENSE("GPL");
diff --git a/drivers/hv/hv_kvp.c b/drivers/hv/hv_kvp.c
index ed50e9e..296c16e 100644
--- a/drivers/hv/hv_kvp.c
+++ b/drivers/hv/hv_kvp.c
@@ -76,7 +76,9 @@ static u8 *recv_buffer;
 /*
  * Register the kernel component with the user-level daemon.
  * As part of this registration, pass the LIC version number.
+ * This number has no meaning, it satisfies the registration protocol.
  */
+#define HV_DRV_VERSION           "3.1"
 
 static void
 kvp_register(int reg_value)
diff --git a/drivers/hv/hv_util.c b/drivers/hv/hv_util.c
index 2f561c5..c59cc8b 100644
--- a/drivers/hv/hv_util.c
+++ b/drivers/hv/hv_util.c
@@ -380,5 +380,4 @@ module_init(init_hyperv_utils);
 module_exit(exit_hyperv_utils);
 
 MODULE_DESCRIPTION("Hyper-V Utilities");
-MODULE_VERSION(HV_DRV_VERSION);
 MODULE_LICENSE("GPL");
diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index bf421e0..7ef9585 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -812,7 +812,6 @@ static void __exit vmbus_exit(void)
 
 
 MODULE_LICENSE("GPL");
-MODULE_VERSION(HV_DRV_VERSION);
 
 subsys_initcall(hv_acpi_init);
 module_exit(vmbus_exit);
diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 088c554..e50ca64 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -303,7 +303,6 @@ static void netvsc_get_drvinfo(struct net_device *net,
 			       struct ethtool_drvinfo *info)
 {
 	strlcpy(info->driver, KBUILD_MODNAME, sizeof(info->driver));
-	strlcpy(info->version, HV_DRV_VERSION, sizeof(info->version));
 	strlcpy(info->fw_version, "N/A", sizeof(info->fw_version));
 }
 
@@ -526,7 +525,6 @@ static int __init netvsc_drv_init(void)
 }
 
 MODULE_LICENSE("GPL");
-MODULE_VERSION(HV_DRV_VERSION);
 MODULE_DESCRIPTION("Microsoft Hyper-V network driver");
 
 module_init(netvsc_drv_init);
diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 16a3a0c..1a720cf 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1610,7 +1610,6 @@ static void __exit storvsc_drv_exit(void)
 }
 
 MODULE_LICENSE("GPL");
-MODULE_VERSION(HV_DRV_VERSION);
 MODULE_DESCRIPTION("Microsoft Hyper-V virtual storage driver");
 module_init(storvsc_drv_init);
 module_exit(storvsc_drv_exit);
diff --git a/drivers/video/hyperv_fb.c b/drivers/video/hyperv_fb.c
index d4d2c5f..8ac99b8 100644
--- a/drivers/video/hyperv_fb.c
+++ b/drivers/video/hyperv_fb.c
@@ -825,5 +825,4 @@ module_init(hvfb_drv_init);
 module_exit(hvfb_drv_exit);
 
 MODULE_LICENSE("GPL");
-MODULE_VERSION(HV_DRV_VERSION);
 MODULE_DESCRIPTION("Microsoft Hyper-V Synthetic Video Frame Buffer Driver");
diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index c255984..e294ad7 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -455,27 +455,6 @@ hv_get_ringbuffer_availbytes(struct hv_ring_buffer_info *rbi,
 	*read = dsize - *write;
 }
 
-
-/*
- * We use the same version numbering for all Hyper-V modules.
- *
- * Definition of versioning is as follows;
- *
- *	Major Number	Changes for these scenarios;
- *			1.	When a new version of Windows Hyper-V
- *				is released.
- *			2.	A Major change has occurred in the
- *				Linux IC's.
- *			(For example the merge for the first time
- *			into the kernel) Every time the Major Number
- *			changes, the Revision number is reset to 0.
- *	Minor Number	Changes when new functionality is added
- *			to the Linux IC's that is not a bug fix.
- *
- * 3.1 - Added completed hv_utils driver. Shutdown/Heartbeat/Timesync
- */
-#define HV_DRV_VERSION           "3.1"
-
 /*
  * VMBUS version is 32 bit entity broken up into
  * two 16 bit quantities: major_number. minor_number.
