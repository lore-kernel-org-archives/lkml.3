Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440AbaAUVbr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 16:31:47 -0500
Received: from mail1.windriver.com ([147.11.146.13]:50817 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754961AbaAUVZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 16:25:48 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arch@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Bjorn Helgaas <bhelgaas@google.com>, <linux-pci@vger.kernel.org>
Subject: [PATCH 69/73] drivers/pci: delete non-required instances of <linux/init.h>
Date: Tue, 21 Jan 2014 16:23:12 -0500
Message-ID: <1390339396-3479-70-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.4.1
In-Reply-To: <1390339396-3479-1-git-send-email-paul.gortmaker@windriver.com>
References: <1390339396-3479-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

None of these files are actually using any __init type directives
and hence don't need to include <linux/init.h>.  Most are just a
left over from __devinit and __cpuinit removal, or simply due to
code getting copied from one driver to the next.

Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/pci/bus.c                  | 1 -
 drivers/pci/host-bridge.c          | 1 -
 drivers/pci/hotplug/acpiphp_glue.c | 1 -
 drivers/pci/hotplug/cpqphp_nvram.c | 1 -
 drivers/pci/hotplug/s390_pci_hpc.c | 1 -
 drivers/pci/msi.c                  | 1 -
 drivers/pci/search.c               | 1 -
 drivers/pci/setup-irq.c            | 1 -
 drivers/pci/setup-res.c            | 1 -
 9 files changed, 9 deletions(-)

diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
index 00660cc..ad0f20a 100644
--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -13,7 +13,6 @@
 #include <linux/errno.h>
 #include <linux/ioport.h>
 #include <linux/proc_fs.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 
 #include "pci.h"
diff --git a/drivers/pci/host-bridge.c b/drivers/pci/host-bridge.c
index 06ace62..389e3df 100644
--- a/drivers/pci/host-bridge.c
+++ b/drivers/pci/host-bridge.c
@@ -3,7 +3,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/pci.h>
 #include <linux/module.h>
 
diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
index cd929ae..1629963 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -41,7 +41,6 @@
 
 #define pr_fmt(fmt) "acpiphp_glue: " fmt
 
-#include <linux/init.h>
 #include <linux/module.h>
 
 #include <linux/kernel.h>
diff --git a/drivers/pci/hotplug/cpqphp_nvram.c b/drivers/pci/hotplug/cpqphp_nvram.c
index 76ba8a1..9600a39 100644
--- a/drivers/pci/hotplug/cpqphp_nvram.c
+++ b/drivers/pci/hotplug/cpqphp_nvram.c
@@ -34,7 +34,6 @@
 #include <linux/workqueue.h>
 #include <linux/pci.h>
 #include <linux/pci_hotplug.h>
-#include <linux/init.h>
 #include <asm/uaccess.h>
 #include "cpqphp.h"
 #include "cpqphp_nvram.h"
diff --git a/drivers/pci/hotplug/s390_pci_hpc.c b/drivers/pci/hotplug/s390_pci_hpc.c
index 8d2ce22..d1332d2 100644
--- a/drivers/pci/hotplug/s390_pci_hpc.c
+++ b/drivers/pci/hotplug/s390_pci_hpc.c
@@ -15,7 +15,6 @@
 #include <linux/slab.h>
 #include <linux/pci.h>
 #include <linux/pci_hotplug.h>
-#include <linux/init.h>
 #include <asm/pci_debug.h>
 #include <asm/sclp.h>
 
diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 7a0fec6..18ca2497 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -10,7 +10,6 @@
 #include <linux/mm.h>
 #include <linux/irq.h>
 #include <linux/interrupt.h>
-#include <linux/init.h>
 #include <linux/export.h>
 #include <linux/ioport.h>
 #include <linux/pci.h>
diff --git a/drivers/pci/search.c b/drivers/pci/search.c
index 3ff2ac7..cc6db38 100644
--- a/drivers/pci/search.c
+++ b/drivers/pci/search.c
@@ -7,7 +7,6 @@
  *	Copyright (C) 2003 -- 2004 Greg Kroah-Hartman <greg@kroah.com>
  */
 
-#include <linux/init.h>
 #include <linux/pci.h>
 #include <linux/slab.h>
 #include <linux/module.h>
diff --git a/drivers/pci/setup-irq.c b/drivers/pci/setup-irq.c
index 9bd6864..dbc4ffc 100644
--- a/drivers/pci/setup-irq.c
+++ b/drivers/pci/setup-irq.c
@@ -10,7 +10,6 @@
  */
 
 
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/pci.h>
 #include <linux/errno.h>
diff --git a/drivers/pci/setup-res.c b/drivers/pci/setup-res.c
index 5c060b1..3e5682c 100644
--- a/drivers/pci/setup-res.c
+++ b/drivers/pci/setup-res.c
@@ -16,7 +16,6 @@
  *	     Resource sorting
  */
 
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/export.h>
 #include <linux/pci.h>
-- 
1.8.4.1

