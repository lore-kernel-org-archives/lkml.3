Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382AbaFKAda (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 20:33:30 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:57254 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754074AbaFKAd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 20:33:27 -0400
X-AuditID: cbfee68f-b7fef6d000003970-c5-5397a3d47dd6
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, rjw@rjwysocki.net, pavel@ucw.cz,
        len.brown@intel.com, gregkh@linuxfoundation.org, cw00.choi@samsung.com,
        myungjoo.ham@samsung.com, jy0922.shim@samsung.com,
        inki.dae@samsung.com, Jonghwa Lee <jonghwa3.lee@samsung.com>
Subject: [RFC PATCH] PM: Domain: Add flag to assure that device's runtime pm
 callback is called at once.
Date: Wed, 11 Jun 2014 09:33:20 +0900
Message-id: <1402446800-4043-1-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGLMWRmVeSWpSXmKPExsWyRsSkRPfK4unBBg/7BS2uf3nOatG8eD2b
	xaT7E1gsOs8+YbZ4ce8ii8WsKXuZLC7vmsNm8bn3CKPF7cYVbBZ3Tx1lszhz+hKrA7fH4j0v
	mTz2z13D7rHlajuLR9+WVYweK1Z/Z/f4vEkugC2KyyYlNSezLLVI3y6BK2PF4hWsBX+1Klad
	mc7WwHhIuYuRk0NCwETi1rZXbBC2mMSFe+uBbC4OIYGljBJHGz+wwBTdu7gCKjGdUeJhfw8r
	hNPGJNEy5xwrSBWbgI7E/3032UFsEQEFic29z8DizAJ/GCUuPksDsYUFsiQudX4HmsTBwSKg
	KjHjbAhImFfAXeLBpKksIGEJoNY5k2xAxksILGOX6HzeB3YEi4CAxLfJh6BqZCU2HWCGuE1S
	4uCKGywTGAUXMDKsYhRNLUguKE5KLzLWK07MLS7NS9dLzs/dxAgM89P/nvXvYLx7wPoQYzLQ
	uInMUqLJ+cA4ySuJNzQ2M7IwNTE1NjK3NCNNWEmc9/7DpCAhgfTEktTs1NSC1KL4otKc1OJD
	jEwcnFINjOWvbqoqmqtdkhX/U3fR40jCbY1bBpJ/TH7P/+Bw7qF6RU2c45rpb3nPZXkdtnYJ
	NlAXZCmtT3mmu3mRVP2Ripv6cgvqfGYzc56a2dZW6B6ybp6C7A6Bmb/ak2qeVZ0oP1KhlDgj
	s1lracxtUT97fhbGda5zGDtKom496ttwx3HaKnnT7d9uKLEUZyQaajEXFScCAH8fwPyJAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMIsWRmVeSWpSXmKPExsVy+t9jQd0ri6cHGzQfZLe4/uU5q0Xz4vVs
	FpPuT2Cx6Dz7hNnixb2LLBazpuxlsri8aw6bxefeI4wWtxtXsFncPXWUzeLM6UusDtwei/e8
	ZPLYP3cNu8eWq+0sHn1bVjF6rFj9nd3j8ya5ALaoBkabjNTElNQihdS85PyUzLx0WyXv4Hjn
	eFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKADlRTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6
	hgTB9RgZoIGENYwZKxavYC34q1Wx6sx0tgbGQ8pdjJwcEgImEvcurmCDsMUkLtxbD2RzcQgJ
	TGeUeNjfwwrhtDFJtMw5xwpSxSagI/F/3012EFtEQEFic+8zsDizwB9GiYvP0kBsYYEsiUud
	34EmcXCwCKhKzDgbAhLmFXCXeDBpKgtIWAKodc4kmwmM3AsYGVYxiqYWJBcUJ6XnGukVJ+YW
	l+al6yXn525iBEfRM+kdjKsaLA4xCnAwKvHwSkhPDxZiTSwrrsw9xCjBwawkwmuTBhTiTUms
	rEotyo8vKs1JLT7EmAy0eyKzlGhyPjDC80riDY1NzIwsjcwNLYyMzUkTVhLnPdhqHSgkkJ5Y
	kpqdmlqQWgSzhYmDU6qBsW5i+tOMnQEPf/OrM7u6z0mQZJzxQu+AVN8KZ6XSrT+P8T0y049v
	WbH8uV7Hn6gPm9M/xiz4s111rZdBi5/ykxuJv3gjShOz2XW3s3sut3Doi/8mtNWxes2f74WW
	B6IcU287c1y4rnP7fKDiPp/8hwIaVsYTM+tifGzd5Lrb9QMbOBkaLvoqsRRnJBpqMRcVJwIA
	sQbLuOYCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When device uses generic pm domain, its own runtime suspend callback will be
executed only when all devices in the same domain are suspended. However, some
device needs sychronized runtime suspend and not to be deffered.
For those devices, Generic pm domain adds new API for adding device with flag,
which shows that it guerantees driver's runtime suspend will be executed right
away not at the time domain is really powered off.
Existed API, pm_genpd_add_device(), now adds device with flag representing this
device is not needed sychrnoized callback. It will work as same as before.

Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
---
 drivers/base/power/domain.c |   17 ++++++++++++++---
 include/linux/pm_domain.h   |   19 ++++++++++++++++---
 2 files changed, 30 insertions(+), 6 deletions(-)

diff --git a/drivers/base/power/domain.c b/drivers/base/power/domain.c
index ae098a2..6c7a786 100644
--- a/drivers/base/power/domain.c
+++ b/drivers/base/power/domain.c
@@ -503,6 +503,9 @@ static int pm_genpd_poweroff(struct generic_pm_domain *genpd)
 	genpd->poweroff_task = current;
 
 	list_for_each_entry_reverse(pdd, &genpd->dev_list, list_node) {
+		if (dev_gpd_data(pdd->dev)->rpmflags & GENPD_RPM_SYNC)
+			continue;
+
 		ret = atomic_read(&genpd->sd_count) == 0 ?
 			__pm_genpd_save_device(pdd, genpd) : -EBUSY;
 
@@ -625,6 +628,9 @@ static int pm_genpd_runtime_suspend(struct device *dev)
 	if (stop_ok && !stop_ok(dev))
 		return -EBUSY;
 
+	if (dev_gpd_data(dev)->rpmflags & GENPD_RPM_SYNC)
+		genpd_save_dev(genpd, dev);
+
 	ret = genpd_stop_dev(genpd, dev);
 	if (ret)
 		return ret;
@@ -1416,7 +1422,7 @@ static void __pm_genpd_free_dev_data(struct device *dev,
  * @td: Set of PM QoS timing parameters to attach to the device.
  */
 int __pm_genpd_add_device(struct generic_pm_domain *genpd, struct device *dev,
-			  struct gpd_timing_data *td)
+			  struct gpd_timing_data *td, enum genpd_rpmflags flags)
 {
 	struct generic_pm_domain_data *gpd_data_new, *gpd_data = NULL;
 	struct pm_domain_data *pdd;
@@ -1472,6 +1478,7 @@ int __pm_genpd_add_device(struct generic_pm_domain *genpd, struct device *dev,
 	gpd_data->need_restore = genpd->status == GPD_STATE_POWER_OFF;
 	gpd_data->td.constraint_changed = true;
 	gpd_data->td.effective_constraint_ns = -1;
+	gpd_data->rpmflags = flags;
 	mutex_unlock(&gpd_data->lock);
 
  out:
@@ -1494,6 +1501,7 @@ int __pm_genpd_of_add_device(struct device_node *genpd_node, struct device *dev,
 			     struct gpd_timing_data *td)
 {
 	struct generic_pm_domain *genpd = NULL, *gpd;
+	enum genpd_rpmflags rpmflags;
 
 	dev_dbg(dev, "%s()\n", __func__);
 
@@ -1512,7 +1520,9 @@ int __pm_genpd_of_add_device(struct device_node *genpd_node, struct device *dev,
 	if (!genpd)
 		return -EINVAL;
 
-	return __pm_genpd_add_device(genpd, dev, td);
+	rpmflags = of_property_read_bool(dev->of_node, "pm-genpd-rpmsync");
+
+	return __pm_genpd_add_device(genpd, dev, td, rpmflags);
 }
 
 
@@ -1525,7 +1535,8 @@ int __pm_genpd_of_add_device(struct device_node *genpd_node, struct device *dev,
 int __pm_genpd_name_add_device(const char *domain_name, struct device *dev,
 			       struct gpd_timing_data *td)
 {
-	return __pm_genpd_add_device(pm_genpd_lookup_name(domain_name), dev, td);
+	struct generic_pm_domain *genpd = pm_genpd_lookup_name(domain_name);
+	return __pm_genpd_add_device(genpd, dev, td, GENPD_RPM_ASYNC);
 }
 
 /**
diff --git a/include/linux/pm_domain.h b/include/linux/pm_domain.h
index 7c1d252..d36e5cf 100644
--- a/include/linux/pm_domain.h
+++ b/include/linux/pm_domain.h
@@ -106,6 +106,11 @@ struct gpd_timing_data {
 	bool cached_stop_ok;
 };
 
+enum genpd_rpmflags {
+	GENPD_RPM_ASYNC = 0,
+	GENPD_RPM_SYNC,
+};
+
 struct generic_pm_domain_data {
 	struct pm_domain_data base;
 	struct gpd_dev_ops ops;
@@ -114,6 +119,7 @@ struct generic_pm_domain_data {
 	struct mutex lock;
 	unsigned int refcount;
 	bool need_restore;
+	enum genpd_rpmflags rpmflags;
 };
 
 #ifdef CONFIG_PM_GENERIC_DOMAINS
@@ -132,7 +138,8 @@ extern struct dev_power_governor simple_qos_governor;
 extern struct generic_pm_domain *dev_to_genpd(struct device *dev);
 extern int __pm_genpd_add_device(struct generic_pm_domain *genpd,
 				 struct device *dev,
-				 struct gpd_timing_data *td);
+				 struct gpd_timing_data *td,
+				 enum genpd_rpmflags flags);
 
 extern int __pm_genpd_of_add_device(struct device_node *genpd_node,
 				    struct device *dev,
@@ -180,7 +187,8 @@ static inline struct generic_pm_domain *dev_to_genpd(struct device *dev)
 }
 static inline int __pm_genpd_add_device(struct generic_pm_domain *genpd,
 					struct device *dev,
-					struct gpd_timing_data *td)
+					struct gpd_timing_data *td,
+					enum genpd_rpmflags flags);
 {
 	return -ENOSYS;
 }
@@ -263,10 +271,15 @@ static inline bool default_stop_ok(struct device *dev)
 #define pm_domain_always_on_gov NULL
 #endif
 
+static inline int pm_genpd_add_device_rpmsync(struct generic_pm_domain *genpd,
+				      struct device *dev)
+{
+	return __pm_genpd_add_device(genpd, dev, NULL, GENPD_RPM_SYNC);
+}
 static inline int pm_genpd_add_device(struct generic_pm_domain *genpd,
 				      struct device *dev)
 {
-	return __pm_genpd_add_device(genpd, dev, NULL);
+	return __pm_genpd_add_device(genpd, dev, NULL, GENPD_RPM_ASYNC);
 }
 
 static inline int pm_genpd_of_add_device(struct device_node *genpd_node,
-- 
1.7.9.5

