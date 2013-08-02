Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509Ab3HBKps (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:45:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37314 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030243Ab3HBKK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:10:28 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tejun Heo <tj@kernel.org>,
        Martin Braure de Calignon <braurede@free.fr>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [ 50/99] libata: make it clear that sata_inic162x is experimental
Date: Fri,  2 Aug 2013 18:08:03 +0800
Message-Id: <20130802100233.015532390@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.4.841.g1a3f60e
In-Reply-To: <20130802100225.478715166@linuxfoundation.org>
References: <20130802100225.478715166@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/ata/Kconfig         |    2 +-
 drivers/ata/sata_inic162x.c |   14 ++++++++++++++
 2 files changed, 15 insertions(+), 1 deletion(-)

--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -107,7 +107,7 @@ config SATA_FSL
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
@@ -807,6 +819,8 @@ static int inic_init_one(struct pci_dev
 
 	ata_print_version_once(&pdev->dev, DRV_VERSION);
 
+	dev_alert(&pdev->dev, "inic162x support is broken with common data corruption issues and will be disabled by default, contact linux-ide@vger.kernel.org if in production use\n");
+
 	/* alloc host */
 	host = ata_host_alloc_pinfo(&pdev->dev, ppi, NR_PORTS);
 	hpriv = devm_kzalloc(&pdev->dev, sizeof(*hpriv), GFP_KERNEL);


