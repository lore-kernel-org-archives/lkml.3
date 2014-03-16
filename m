Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843AbaCPMha (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 08:37:30 -0400
Received: from mga01.intel.com ([192.55.52.88]:47134 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753122AbaCPMhU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 08:37:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,664,1389772800"; 
   d="scan'208";a="493061478"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 5/5] mei: don't use deprecated DEFINE_PCI_DEVICE_TABLE macro
Date: Sun, 16 Mar 2014 14:35:58 +0200
Message-Id: <1394973358-21690-6-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1394973358-21690-1-git-send-email-tomas.winkler@intel.com>
References: <1394973358-21690-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using struct pci_device_id is preferred  over
deprecated DEFINE_PCI_DEVICE_TABLE macro

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/pci-me.c  | 2 +-
 drivers/misc/mei/pci-txe.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/mei/pci-me.c b/drivers/misc/mei/pci-me.c
index 135ea06..1c8fd3a 100644
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -41,7 +41,7 @@
 #include "hw-me.h"
 
 /* mei_pci_tbl - PCI Device ID Table */
-static DEFINE_PCI_DEVICE_TABLE(mei_me_pci_tbl) = {
+static const struct pci_device_id mei_me_pci_tbl[] = {
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_82946GZ)},
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_82G35)},
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_82Q965)},
diff --git a/drivers/misc/mei/pci-txe.c b/drivers/misc/mei/pci-txe.c
index a5bf39a..ad3adb0 100644
--- a/drivers/misc/mei/pci-txe.c
+++ b/drivers/misc/mei/pci-txe.c
@@ -34,7 +34,7 @@
 #include "mei_dev.h"
 #include "hw-txe.h"
 
-static DEFINE_PCI_DEVICE_TABLE(mei_txe_pci_tbl) = {
+static const struct pci_device_id mei_txe_pci_tbl[] = {
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x0F18)}, /* Baytrail */
 	{0, }
 };
-- 
1.8.5.3

