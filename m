Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754959AbaDSAPy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 20:15:54 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:38721 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754651AbaDSAOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 20:14:46 -0400
X-Originating-IP: 76.119.93.133
From: Ryan Desfosses <ryan@desfo.org>
To: bhelgaas@google.com
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Ryan Desfosses <ryan@desfo.org>
Subject: [PATCH 7/8] pci-driver: moved EXPORT_SYMBOL so that it immediately followed its function/variable
Date: Fri, 18 Apr 2014 20:13:52 -0400
Message-Id: <1397866433-21119-8-git-send-email-ryan@desfo.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1397866433-21119-1-git-send-email-ryan@desfo.org>
References: <1397866433-21119-1-git-send-email-ryan@desfo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

change made to resolve following checkpatch message:
        WARNING: EXPORT_SYMBOL(foo); should immediately follow
        its function/aariable
branch: Linux 3.15-rc1

Signed-off-by: Ryan Desfosses <ryan@desfo.org>
---
 drivers/pci/pci-driver.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index 821efe2..2c921a2 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -77,6 +77,7 @@ int pci_add_dynid(struct pci_driver *drv,
 
 	return retval;
 }
+EXPORT_SYMBOL_GPL(pci_add_dynid);
 
 static void pci_free_dynids(struct pci_driver *drv)
 {
@@ -242,6 +243,7 @@ static const struct pci_device_id *pci_match_device(struct pci_driver *drv,
 
 	return pci_match_id(drv->id_table, dev);
 }
+EXPORT_SYMBOL(pci_match_id);
 
 struct drv_dev_and_id {
 	struct pci_driver *drv;
@@ -1216,6 +1218,7 @@ int __pci_register_driver(struct pci_driver *drv, struct module *owner,
 	/* register with core */
 	return driver_register(&drv->driver);
 }
+EXPORT_SYMBOL(__pci_register_driver);
 
 /**
  * pci_unregister_driver - unregister a pci driver
@@ -1233,6 +1236,7 @@ pci_unregister_driver(struct pci_driver *drv)
 	driver_unregister(&drv->driver);
 	pci_free_dynids(drv);
 }
+EXPORT_SYMBOL(pci_unregister_driver);
 
 static struct pci_driver pci_compat_driver = {
 	.name = "compat"
@@ -1258,6 +1262,7 @@ pci_dev_driver(const struct pci_dev *dev)
 	}
 	return NULL;
 }
+EXPORT_SYMBOL(pci_dev_driver);
 
 /**
  * pci_bus_match - Tell if a PCI device structure has a matching PCI device id structure
@@ -1303,6 +1308,7 @@ struct pci_dev *pci_dev_get(struct pci_dev *dev)
 		get_device(&dev->dev);
 	return dev;
 }
+EXPORT_SYMBOL(pci_dev_get);
 
 /**
  * pci_dev_put - release a use of the pci device structure
@@ -1316,6 +1322,7 @@ void pci_dev_put(struct pci_dev *dev)
 	if (dev)
 		put_device(&dev->dev);
 }
+EXPORT_SYMBOL(pci_dev_put);
 
 static int pci_uevent(struct device *dev, struct kobj_uevent_env *env)
 {
@@ -1362,6 +1369,7 @@ struct bus_type pci_bus_type = {
 	.drv_groups	= pci_drv_groups,
 	.pm		= PCI_PM_OPS_PTR,
 };
+EXPORT_SYMBOL(pci_bus_type);
 
 static int __init pci_driver_init(void)
 {
@@ -1370,11 +1378,3 @@ static int __init pci_driver_init(void)
 
 postcore_initcall(pci_driver_init);
 
-EXPORT_SYMBOL_GPL(pci_add_dynid);
-EXPORT_SYMBOL(pci_match_id);
-EXPORT_SYMBOL(__pci_register_driver);
-EXPORT_SYMBOL(pci_unregister_driver);
-EXPORT_SYMBOL(pci_dev_driver);
-EXPORT_SYMBOL(pci_bus_type);
-EXPORT_SYMBOL(pci_dev_get);
-EXPORT_SYMBOL(pci_dev_put);
-- 
1.9.1

