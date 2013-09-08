Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759562Ab3IHDuP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 23:50:15 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56147 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756333Ab3IHDTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 23:19:03 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Martin Braure de Calignon" <braurede@free.fr>,
        "Tejun Heo" <tj@kernel.org>, risc4all@yahoo.com
Date: Sun, 08 Sep 2013 03:52:01 +0100
Message-ID: <lsq.1378608721.415135944@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [003/121] libata: make it clear that sata_inic162x is experimental
In-Reply-To: <lsq.1378608720.401499712@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.51-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/ata/Kconfig         |  2 +-
 drivers/ata/sata_inic162x.c | 14 ++++++++++++++
 2 files changed, 15 insertions(+), 1 deletion(-)

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
@@ -809,6 +821,8 @@ static int inic_init_one(struct pci_dev
 
 	ata_print_version_once(&pdev->dev, DRV_VERSION);
 
+	dev_alert(&pdev->dev, "inic162x support is broken with common data corruption issues and will be disabled by default, contact linux-ide@vger.kernel.org if in production use\n");
+
 	/* alloc host */
 	host = ata_host_alloc_pinfo(&pdev->dev, ppi, NR_PORTS);
 	hpriv = devm_kzalloc(&pdev->dev, sizeof(*hpriv), GFP_KERNEL);

