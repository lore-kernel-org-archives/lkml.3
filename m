Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078AbaBHRcG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 12:32:06 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:62755 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831AbaBHRcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 12:32:04 -0500
From: Antonios Motakis <a.motakis@virtualopensystems.com>
To: alex.williamson@redhat.com, kvmarm@lists.cs.columbia.edu,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org
Cc: tech@virtualopensystems.com, a.rigo@virtualopensystems.com,
        B08248@freescale.com, kim.phillips@linaro.org, jan.kiszka@siemens.com,
        kvm@vger.kernel.org, R65777@freescale.com, B07421@freescale.com,
        christoffer.dall@linaro.org, agraf@suse.de, B16395@freescale.com,
        will.deacon@arm.com, Tejun Heo <tj@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Guenter Roeck <linux@roeck-us.net>, Toshi Kani <toshi.kani@hp.com>,
        Joe Perches <joe@perches.com>,
        Dmitry Kasatkin <d.kasatkin@samsung.com>,
        Michal Hocko <mhocko@suse.cz>, Bjorn Helgaas <bhelgaas@google.com>
Subject: [RFC PATCH v4 01/10] driver core: export driver_probe_device()
Date: Sat,  8 Feb 2014 18:29:31 +0100
Message-Id: <1391880580-471-2-git-send-email-a.motakis@virtualopensystems.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391880580-471-1-git-send-email-a.motakis@virtualopensystems.com>
References: <1391880580-471-1-git-send-email-a.motakis@virtualopensystems.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kim Phillips <kim.phillips@linaro.org>

Needed by drivers, such as the vfio platform driver [1], seeking to
bypass bind_store()'s driver_match_device(), and bind to any device
via a private sysfs bind file.

[1] https://lkml.org/lkml/2013/12/11/522

note: the EXPORT_SYMBOL is needed because vfio-platform can be built
as a module.

Signed-off-by: Kim Phillips <kim.phillips@linaro.org>
---
 drivers/base/base.h    | 1 -
 drivers/base/dd.c      | 1 +
 include/linux/device.h | 1 +
 3 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/base/base.h b/drivers/base/base.h
index 24f4242..fe25ad87 100644
--- a/drivers/base/base.h
+++ b/drivers/base/base.h
@@ -112,7 +112,6 @@ extern int bus_add_driver(struct device_driver *drv);
 extern void bus_remove_driver(struct device_driver *drv);
 
 extern void driver_detach(struct device_driver *drv);
-extern int driver_probe_device(struct device_driver *drv, struct device *dev);
 extern void driver_deferred_probe_del(struct device *dev);
 static inline int driver_match_device(struct device_driver *drv,
 				      struct device *dev)
diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 0605176..44f6184 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -384,6 +384,7 @@ int driver_probe_device(struct device_driver *drv, struct device *dev)
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(driver_probe_device);
 
 static int __device_attach(struct device_driver *drv, void *data)
 {
diff --git a/include/linux/device.h b/include/linux/device.h
index 952b010..ad80dd2 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -257,6 +257,7 @@ extern struct device_driver *driver_find(const char *name,
 					 struct bus_type *bus);
 extern int driver_probe_done(void);
 extern void wait_for_device_probe(void);
+extern int driver_probe_device(struct device_driver *drv, struct device *dev);
 
 
 /* sysfs interface for exporting driver attributes */
-- 
1.8.3.2

