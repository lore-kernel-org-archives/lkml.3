Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759818Ab3HNK7P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 06:59:15 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34444 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932236Ab3HNKh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 06:37:29 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tejun Heo <tj@kernel.org>, Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 17/75] libata: make it clear that sata_inic162x is experimental
Date: Wed, 14 Aug 2013 11:36:06 +0100
Message-Id: <1376476624-10011-18-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1376476624-10011-1-git-send-email-luis.henriques@canonical.com>
References: <1376476624-10011-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.19 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit bb9696192826a7d9279caf872e95b41bc26c7eff upstream.

sata_inic162x never reached a state where it's reliable enough for
production use and data corruption is a relatively common occurrence.
Make the driver generate warning about the issues and mark the Kconfig
option as experimental.

If the situation doesn't improve, we'd be better off making it depend
on CONFIG_BROKEN.  Let's wait for several cycles and see if the kernel
message draws any attention.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Martin Braure de Calignon <braurede@free.fr>
Reported-by: Ben Hutchings <ben@decadent.org.uk>
Reported-by: risc4all@yahoo.com
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/ata/Kconfig         |  2 +-
 drivers/ata/sata_inic162x.c | 14 ++++++++++++++
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index 2be8ef1..39cafa6 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -93,7 +93,7 @@ config SATA_FSL
 	  If unsure, say N.
 
 config SATA_INIC162X
-	tristate "Initio 162x SATA support"
+	tristate "Initio 162x SATA support (Very Experimental)"
 	depends on PCI
 	help
 	  This option enables support for Initio 162x Serial ATA.
diff --git a/drivers/ata/sata_inic162x.c b/drivers/ata/sata_inic162x.c
index 5c7d70c..3a8b55e 100644
--- a/drivers/ata/sata_inic162x.c
+++ b/drivers/ata/sata_inic162x.c
@@ -6,6 +6,18 @@
  *
  * This file is released under GPL v2.
  *
+ * **** WARNING ****
+ *
+ * This driver never worked properly and unfortunately data corruption is
+ * relatively common.  There isn't anyone working on the driver and there's
+ * no support from the vendor.  Do not use this driver in any production
+ * environment.
+ *
+ * http://thread.gmane.org/gmane.linux.debian.devel.bugs.rc/378525/focus=54491
+ * https://bugzilla.kernel.org/show_bug.cgi?id=60565
+ *
+ * *****************
+ *
  * This controller is eccentric and easily locks up if something isn't
  * right.  Documentation is available at initio's website but it only
  * documents registers (not programming model).
@@ -809,6 +821,8 @@ static int inic_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	ata_print_version_once(&pdev->dev, DRV_VERSION);
 
+	dev_alert(&pdev->dev, "inic162x support is broken with common data corruption issues and will be disabled by default, contact linux-ide@vger.kernel.org if in production use\n");
+
 	/* alloc host */
 	host = ata_host_alloc_pinfo(&pdev->dev, ppi, NR_PORTS);
 	hpriv = devm_kzalloc(&pdev->dev, sizeof(*hpriv), GFP_KERNEL);
-- 
1.8.3.2

