Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710AbaF0HDR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 03:03:17 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:56567 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbaF0HDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 03:03:15 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] iommu: Constify struct iommu_ops
Date: Fri, 27 Jun 2014 09:03:12 +0200
Message-Id: <1403852592-10637-1-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

This structure is read-only data and should never be modified.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
Changes in v2:
- add missing hunk from include/device.h

 drivers/iommu/amd_iommu.c       |  4 ++--
 drivers/iommu/arm-smmu.c        |  2 +-
 drivers/iommu/exynos-iommu.c    |  2 +-
 drivers/iommu/fsl_pamu_domain.c |  2 +-
 drivers/iommu/intel-iommu.c     |  4 ++--
 drivers/iommu/iommu.c           | 19 ++++++++++++++-----
 drivers/iommu/ipmmu-vmsa.c      |  2 +-
 drivers/iommu/msm_iommu.c       |  2 +-
 drivers/iommu/omap-iommu.c      |  2 +-
 drivers/iommu/shmobile-iommu.c  |  2 +-
 drivers/iommu/tegra-gart.c      |  2 +-
 drivers/iommu/tegra-smmu.c      |  2 +-
 include/linux/device.h          |  2 +-
 include/linux/iommu.h           |  4 ++--
 14 files changed, 30 insertions(+), 21 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 4aec6a29e316..7eb0e4246a79 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -81,7 +81,7 @@ LIST_HEAD(hpet_map);
  */
 static struct protection_domain *pt_domain;
 
-static struct iommu_ops amd_iommu_ops;
+static const struct iommu_ops amd_iommu_ops;
 
 static ATOMIC_NOTIFIER_HEAD(ppr_notifier);
 int amd_iommu_max_glx_val = -1;
@@ -3473,7 +3473,7 @@ static int amd_iommu_domain_has_cap(struct iommu_domain *domain,
 	return 0;
 }
 
-static struct iommu_ops amd_iommu_ops = {
+static const struct iommu_ops amd_iommu_ops = {
 	.domain_init = amd_iommu_domain_init,
 	.domain_destroy = amd_iommu_domain_destroy,
 	.attach_dev = amd_iommu_attach_device,
diff --git a/drivers/iommu/arm-smmu.c b/drivers/iommu/arm-smmu.c
index 1599354e974d..67727294e6b5 100644
--- a/drivers/iommu/arm-smmu.c
+++ b/drivers/iommu/arm-smmu.c
@@ -1609,7 +1609,7 @@ static void arm_smmu_remove_device(struct device *dev)
 	iommu_group_remove_device(dev);
 }
 
-static struct iommu_ops arm_smmu_ops = {
+static const struct iommu_ops arm_smmu_ops = {
 	.domain_init	= arm_smmu_domain_init,
 	.domain_destroy	= arm_smmu_domain_destroy,
 	.attach_dev	= arm_smmu_attach_dev,
diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 99054d2c040d..d037e87a1fe5 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -1170,7 +1170,7 @@ static void exynos_iommu_remove_device(struct device *dev)
 	iommu_group_remove_device(dev);
 }
 
-static struct iommu_ops exynos_iommu_ops = {
+static const struct iommu_ops exynos_iommu_ops = {
 	.domain_init = exynos_iommu_domain_init,
 	.domain_destroy = exynos_iommu_domain_destroy,
 	.attach_dev = exynos_iommu_attach_device,
diff --git a/drivers/iommu/fsl_pamu_domain.c b/drivers/iommu/fsl_pamu_domain.c
index 93072ba44b1d..5b47c5495873 100644
--- a/drivers/iommu/fsl_pamu_domain.c
+++ b/drivers/iommu/fsl_pamu_domain.c
@@ -1140,7 +1140,7 @@ static u32 fsl_pamu_get_windows(struct iommu_domain *domain)
 	return dma_domain->win_cnt;
 }
 
-static struct iommu_ops fsl_pamu_ops = {
+static const struct iommu_ops fsl_pamu_ops = {
 	.domain_init	= fsl_pamu_domain_init,
 	.domain_destroy = fsl_pamu_domain_destroy,
 	.attach_dev	= fsl_pamu_attach_device,
diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 51b6b77dc3e5..9aab7963f424 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -451,7 +451,7 @@ EXPORT_SYMBOL_GPL(intel_iommu_gfx_mapped);
 static DEFINE_SPINLOCK(device_domain_lock);
 static LIST_HEAD(device_domain_list);
 
-static struct iommu_ops intel_iommu_ops;
+static const struct iommu_ops intel_iommu_ops;
 
 static int __init intel_iommu_setup(char *str)
 {
@@ -4465,7 +4465,7 @@ static void intel_iommu_remove_device(struct device *dev)
 	iommu_group_remove_device(dev);
 }
 
-static struct iommu_ops intel_iommu_ops = {
+static const struct iommu_ops intel_iommu_ops = {
 	.domain_init	= intel_iommu_domain_init,
 	.domain_destroy = intel_iommu_domain_destroy,
 	.attach_dev	= intel_iommu_attach_device,
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index e5555fcfe703..806b55d056b7 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -35,6 +35,10 @@ static struct kset *iommu_group_kset;
 static struct ida iommu_group_ida;
 static struct mutex iommu_group_mutex;
 
+struct iommu_callback_data {
+	const struct iommu_ops *ops;
+};
+
 struct iommu_group {
 	struct kobject kobj;
 	struct kobject *devices_kobj;
@@ -516,7 +520,8 @@ EXPORT_SYMBOL_GPL(iommu_group_id);
 
 static int add_iommu_group(struct device *dev, void *data)
 {
-	struct iommu_ops *ops = data;
+	struct iommu_callback_data *cb = data;
+	const struct iommu_ops *ops = cb->ops;
 
 	if (!ops->add_device)
 		return -ENODEV;
@@ -532,7 +537,7 @@ static int iommu_bus_notifier(struct notifier_block *nb,
 			      unsigned long action, void *data)
 {
 	struct device *dev = data;
-	struct iommu_ops *ops = dev->bus->iommu_ops;
+	const struct iommu_ops *ops = dev->bus->iommu_ops;
 	struct iommu_group *group;
 	unsigned long group_action = 0;
 
@@ -585,10 +590,14 @@ static struct notifier_block iommu_bus_nb = {
 	.notifier_call = iommu_bus_notifier,
 };
 
-static void iommu_bus_init(struct bus_type *bus, struct iommu_ops *ops)
+static void iommu_bus_init(struct bus_type *bus, const struct iommu_ops *ops)
 {
+	struct iommu_callback_data cb = {
+		.ops = ops,
+	};
+
 	bus_register_notifier(bus, &iommu_bus_nb);
-	bus_for_each_dev(bus, NULL, ops, add_iommu_group);
+	bus_for_each_dev(bus, NULL, &cb, add_iommu_group);
 }
 
 /**
@@ -604,7 +613,7 @@ static void iommu_bus_init(struct bus_type *bus, struct iommu_ops *ops)
  * is set up. With this function the iommu-driver can set the iommu-ops
  * afterwards.
  */
-int bus_set_iommu(struct bus_type *bus, struct iommu_ops *ops)
+int bus_set_iommu(struct bus_type *bus, const struct iommu_ops *ops)
 {
 	if (bus->iommu_ops != NULL)
 		return -EBUSY;
diff --git a/drivers/iommu/ipmmu-vmsa.c b/drivers/iommu/ipmmu-vmsa.c
index 53cde086e83b..7dab5cbcc775 100644
--- a/drivers/iommu/ipmmu-vmsa.c
+++ b/drivers/iommu/ipmmu-vmsa.c
@@ -1120,7 +1120,7 @@ static void ipmmu_remove_device(struct device *dev)
 	dev->archdata.iommu = NULL;
 }
 
-static struct iommu_ops ipmmu_ops = {
+static const struct iommu_ops ipmmu_ops = {
 	.domain_init = ipmmu_domain_init,
 	.domain_destroy = ipmmu_domain_destroy,
 	.attach_dev = ipmmu_attach_device,
diff --git a/drivers/iommu/msm_iommu.c b/drivers/iommu/msm_iommu.c
index f5ff657f49fa..49f41d6e02f1 100644
--- a/drivers/iommu/msm_iommu.c
+++ b/drivers/iommu/msm_iommu.c
@@ -674,7 +674,7 @@ fail:
 	return 0;
 }
 
-static struct iommu_ops msm_iommu_ops = {
+static const struct iommu_ops msm_iommu_ops = {
 	.domain_init = msm_iommu_domain_init,
 	.domain_destroy = msm_iommu_domain_destroy,
 	.attach_dev = msm_iommu_attach_dev,
diff --git a/drivers/iommu/omap-iommu.c b/drivers/iommu/omap-iommu.c
index 895af06a667f..031b2476bcc4 100644
--- a/drivers/iommu/omap-iommu.c
+++ b/drivers/iommu/omap-iommu.c
@@ -1291,7 +1291,7 @@ static void omap_iommu_remove_device(struct device *dev)
 	kfree(arch_data);
 }
 
-static struct iommu_ops omap_iommu_ops = {
+static const struct iommu_ops omap_iommu_ops = {
 	.domain_init	= omap_iommu_domain_init,
 	.domain_destroy	= omap_iommu_domain_destroy,
 	.attach_dev	= omap_iommu_attach_dev,
diff --git a/drivers/iommu/shmobile-iommu.c b/drivers/iommu/shmobile-iommu.c
index 464acda0bbc4..1333e6fb3405 100644
--- a/drivers/iommu/shmobile-iommu.c
+++ b/drivers/iommu/shmobile-iommu.c
@@ -354,7 +354,7 @@ static int shmobile_iommu_add_device(struct device *dev)
 	return 0;
 }
 
-static struct iommu_ops shmobile_iommu_ops = {
+static const struct iommu_ops shmobile_iommu_ops = {
 	.domain_init = shmobile_iommu_domain_init,
 	.domain_destroy = shmobile_iommu_domain_destroy,
 	.attach_dev = shmobile_iommu_attach_device,
diff --git a/drivers/iommu/tegra-gart.c b/drivers/iommu/tegra-gart.c
index dba1a9fd5070..b10a8ecede8e 100644
--- a/drivers/iommu/tegra-gart.c
+++ b/drivers/iommu/tegra-gart.c
@@ -309,7 +309,7 @@ static int gart_iommu_domain_has_cap(struct iommu_domain *domain,
 	return 0;
 }
 
-static struct iommu_ops gart_iommu_ops = {
+static const struct iommu_ops gart_iommu_ops = {
 	.domain_init	= gart_iommu_domain_init,
 	.domain_destroy	= gart_iommu_domain_destroy,
 	.attach_dev	= gart_iommu_attach_dev,
diff --git a/drivers/iommu/tegra-smmu.c b/drivers/iommu/tegra-smmu.c
index 605b5b46a903..792da5ea6d12 100644
--- a/drivers/iommu/tegra-smmu.c
+++ b/drivers/iommu/tegra-smmu.c
@@ -947,7 +947,7 @@ static void smmu_iommu_domain_destroy(struct iommu_domain *domain)
 	dev_dbg(smmu->dev, "smmu_as@%p\n", as);
 }
 
-static struct iommu_ops smmu_iommu_ops = {
+static const struct iommu_ops smmu_iommu_ops = {
 	.domain_init	= smmu_iommu_domain_init,
 	.domain_destroy	= smmu_iommu_domain_destroy,
 	.attach_dev	= smmu_iommu_attach_dev,
diff --git a/include/linux/device.h b/include/linux/device.h
index 921fa0a74df6..28113885260c 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -124,7 +124,7 @@ struct bus_type {
 
 	const struct dev_pm_ops *pm;
 
-	struct iommu_ops *iommu_ops;
+	const struct iommu_ops *iommu_ops;
 
 	struct subsys_private *p;
 	struct lock_class_key lock_key;
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index b96a5b2136e4..284a4683fdc1 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -50,7 +50,7 @@ struct iommu_domain_geometry {
 };
 
 struct iommu_domain {
-	struct iommu_ops *ops;
+	const struct iommu_ops *ops;
 	void *priv;
 	iommu_fault_handler_t handler;
 	void *handler_token;
@@ -140,7 +140,7 @@ struct iommu_ops {
 #define IOMMU_GROUP_NOTIFY_UNBIND_DRIVER	5 /* Pre Driver unbind */
 #define IOMMU_GROUP_NOTIFY_UNBOUND_DRIVER	6 /* Post Driver unbind */
 
-extern int bus_set_iommu(struct bus_type *bus, struct iommu_ops *ops);
+extern int bus_set_iommu(struct bus_type *bus, const struct iommu_ops *ops);
 extern bool iommu_present(struct bus_type *bus);
 extern struct iommu_domain *iommu_domain_alloc(struct bus_type *bus);
 extern struct iommu_group *iommu_group_get_by_id(int id);
-- 
2.0.0

