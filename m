Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752224AbaLXRYG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 12:24:06 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:50977 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751813AbaLXRXC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 12:23:02 -0500
From: Nishanth Menon <nm@ti.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Nishanth Menon <nm@ti.com>
Subject: [PATCH 2/3] PM / OPP: Ensure consistent naming of static functions
Date: Wed, 24 Dec 2014 11:22:56 -0600
Message-ID: <1419441777-25651-3-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1419441777-25651-1-git-send-email-nm@ti.com>
References: <1419441777-25651-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All exported functions use dev_pm_* prefix and all static functions
are now standardized with _ prefix. This is better than having to deal
with multiple function naming styles within the same file.

Signed-off-by: Nishanth Menon <nm@ti.com>
---
 drivers/base/power/opp.c |   62 +++++++++++++++++++++++-----------------------
 1 file changed, 31 insertions(+), 31 deletions(-)

diff --git a/drivers/base/power/opp.c b/drivers/base/power/opp.c
index 1b385e4..8ff78c7 100644
--- a/drivers/base/power/opp.c
+++ b/drivers/base/power/opp.c
@@ -109,7 +109,7 @@ static LIST_HEAD(dev_opp_list);
 static DEFINE_MUTEX(dev_opp_list_lock);
 
 /**
- * find_device_opp() - find device_opp struct using device pointer
+ * _find_device_opp() - find device_opp struct using device pointer
  * @dev:	device pointer used to lookup device OPPs
  *
  * Search list of device OPPs for one containing matching device. Does a RCU
@@ -122,7 +122,7 @@ static DEFINE_MUTEX(dev_opp_list_lock);
  * is a RCU protected pointer. This means that device_opp is valid as long
  * as we are under RCU lock.
  */
-static struct device_opp *find_device_opp(struct device *dev)
+static struct device_opp *_find_device_opp(struct device *dev)
 {
 	struct device_opp *tmp_dev_opp, *dev_opp = ERR_PTR(-ENODEV);
 
@@ -218,7 +218,7 @@ int dev_pm_opp_get_opp_count(struct device *dev)
 	struct dev_pm_opp *temp_opp;
 	int count = 0;
 
-	dev_opp = find_device_opp(dev);
+	dev_opp = _find_device_opp(dev);
 	if (IS_ERR(dev_opp)) {
 		int r = PTR_ERR(dev_opp);
 		dev_err(dev, "%s: device OPP not found (%d)\n", __func__, r);
@@ -267,7 +267,7 @@ struct dev_pm_opp *dev_pm_opp_find_freq_exact(struct device *dev,
 	struct device_opp *dev_opp;
 	struct dev_pm_opp *temp_opp, *opp = ERR_PTR(-ERANGE);
 
-	dev_opp = find_device_opp(dev);
+	dev_opp = _find_device_opp(dev);
 	if (IS_ERR(dev_opp)) {
 		int r = PTR_ERR(dev_opp);
 		dev_err(dev, "%s: device OPP not found (%d)\n", __func__, r);
@@ -318,7 +318,7 @@ struct dev_pm_opp *dev_pm_opp_find_freq_ceil(struct device *dev,
 		return ERR_PTR(-EINVAL);
 	}
 
-	dev_opp = find_device_opp(dev);
+	dev_opp = _find_device_opp(dev);
 	if (IS_ERR(dev_opp))
 		return ERR_CAST(dev_opp);
 
@@ -366,7 +366,7 @@ struct dev_pm_opp *dev_pm_opp_find_freq_floor(struct device *dev,
 		return ERR_PTR(-EINVAL);
 	}
 
-	dev_opp = find_device_opp(dev);
+	dev_opp = _find_device_opp(dev);
 	if (IS_ERR(dev_opp))
 		return ERR_CAST(dev_opp);
 
@@ -386,7 +386,7 @@ struct dev_pm_opp *dev_pm_opp_find_freq_floor(struct device *dev,
 }
 EXPORT_SYMBOL_GPL(dev_pm_opp_find_freq_floor);
 
-static struct device_opp *add_device_opp(struct device *dev)
+static struct device_opp *_add_device_opp(struct device *dev)
 {
 	struct device_opp *dev_opp;
 
@@ -407,8 +407,8 @@ static struct device_opp *add_device_opp(struct device *dev)
 	return dev_opp;
 }
 
-static int dev_pm_opp_add_dynamic(struct device *dev, unsigned long freq,
-				  unsigned long u_volt, bool dynamic)
+static int _opp_add_dynamic(struct device *dev, unsigned long freq,
+			    long u_volt, bool dynamic)
 {
 	struct device_opp *dev_opp = NULL;
 	struct dev_pm_opp *opp, *new_opp;
@@ -432,9 +432,9 @@ static int dev_pm_opp_add_dynamic(struct device *dev, unsigned long freq,
 	new_opp->dynamic = dynamic;
 
 	/* Check for existing list for 'dev' */
-	dev_opp = find_device_opp(dev);
+	dev_opp = _find_device_opp(dev);
 	if (IS_ERR(dev_opp)) {
-		dev_opp = add_device_opp(dev);
+		dev_opp = _add_device_opp(dev);
 		if (!dev_opp) {
 			ret = -ENOMEM;
 			goto free_opp;
@@ -510,26 +510,26 @@ free_opp:
  */
 int dev_pm_opp_add(struct device *dev, unsigned long freq, unsigned long u_volt)
 {
-	return dev_pm_opp_add_dynamic(dev, freq, u_volt, true);
+	return _opp_add_dynamic(dev, freq, u_volt, true);
 }
 EXPORT_SYMBOL_GPL(dev_pm_opp_add);
 
-static void kfree_opp_rcu(struct rcu_head *head)
+static void _kfree_opp_rcu(struct rcu_head *head)
 {
 	struct dev_pm_opp *opp = container_of(head, struct dev_pm_opp, rcu_head);
 
 	kfree_rcu(opp, rcu_head);
 }
 
-static void kfree_device_rcu(struct rcu_head *head)
+static void _kfree_device_rcu(struct rcu_head *head)
 {
 	struct device_opp *device_opp = container_of(head, struct device_opp, rcu_head);
 
 	kfree_rcu(device_opp, rcu_head);
 }
 
-static void __dev_pm_opp_remove(struct device_opp *dev_opp,
-				struct dev_pm_opp *opp)
+static void _opp_remove(struct device_opp *dev_opp,
+			struct dev_pm_opp *opp)
 {
 	/*
 	 * Notify the changes in the availability of the operable
@@ -537,12 +537,12 @@ static void __dev_pm_opp_remove(struct device_opp *dev_opp,
 	 */
 	srcu_notifier_call_chain(&dev_opp->srcu_head, OPP_EVENT_REMOVE, opp);
 	list_del_rcu(&opp->node);
-	call_srcu(&dev_opp->srcu_head.srcu, &opp->rcu_head, kfree_opp_rcu);
+	call_srcu(&dev_opp->srcu_head.srcu, &opp->rcu_head, _kfree_opp_rcu);
 
 	if (list_empty(&dev_opp->opp_list)) {
 		list_del_rcu(&dev_opp->node);
 		call_srcu(&dev_opp->srcu_head.srcu, &dev_opp->rcu_head,
-			  kfree_device_rcu);
+			  _kfree_device_rcu);
 	}
 }
 
@@ -562,7 +562,7 @@ void dev_pm_opp_remove(struct device *dev, unsigned long freq)
 	/* Hold our list modification lock here */
 	mutex_lock(&dev_opp_list_lock);
 
-	dev_opp = find_device_opp(dev);
+	dev_opp = _find_device_opp(dev);
 	if (IS_ERR(dev_opp))
 		goto unlock;
 
@@ -579,14 +579,14 @@ void dev_pm_opp_remove(struct device *dev, unsigned long freq)
 		goto unlock;
 	}
 
-	__dev_pm_opp_remove(dev_opp, opp);
+	_opp_remove(dev_opp, opp);
 unlock:
 	mutex_unlock(&dev_opp_list_lock);
 }
 EXPORT_SYMBOL_GPL(dev_pm_opp_remove);
 
 /**
- * opp_set_availability() - helper to set the availability of an opp
+ * _opp_set_availability() - helper to set the availability of an opp
  * @dev:		device for which we do this operation
  * @freq:		OPP frequency to modify availability
  * @availability_req:	availability status requested for this opp
@@ -604,8 +604,8 @@ EXPORT_SYMBOL_GPL(dev_pm_opp_remove);
  * that this function is *NOT* called under RCU protection or in contexts where
  * mutex locking or synchronize_rcu() blocking calls cannot be used.
  */
-static int opp_set_availability(struct device *dev, unsigned long freq,
-		bool availability_req)
+static int _opp_set_availability(struct device *dev, unsigned long freq,
+				 bool availability_req)
 {
 	struct device_opp *dev_opp;
 	struct dev_pm_opp *new_opp, *tmp_opp, *opp = ERR_PTR(-ENODEV);
@@ -621,7 +621,7 @@ static int opp_set_availability(struct device *dev, unsigned long freq,
 	mutex_lock(&dev_opp_list_lock);
 
 	/* Find the device_opp */
-	dev_opp = find_device_opp(dev);
+	dev_opp = _find_device_opp(dev);
 	if (IS_ERR(dev_opp)) {
 		r = PTR_ERR(dev_opp);
 		dev_warn(dev, "%s: Device OPP not found (%d)\n", __func__, r);
@@ -651,7 +651,7 @@ static int opp_set_availability(struct device *dev, unsigned long freq,
 
 	list_replace_rcu(&opp->node, &new_opp->node);
 	mutex_unlock(&dev_opp_list_lock);
-	call_srcu(&dev_opp->srcu_head.srcu, &opp->rcu_head, kfree_opp_rcu);
+	call_srcu(&dev_opp->srcu_head.srcu, &opp->rcu_head, _kfree_opp_rcu);
 
 	/* Notify the change of the OPP availability */
 	if (availability_req)
@@ -686,7 +686,7 @@ unlock:
  */
 int dev_pm_opp_enable(struct device *dev, unsigned long freq)
 {
-	return opp_set_availability(dev, freq, true);
+	return _opp_set_availability(dev, freq, true);
 }
 EXPORT_SYMBOL_GPL(dev_pm_opp_enable);
 
@@ -708,7 +708,7 @@ EXPORT_SYMBOL_GPL(dev_pm_opp_enable);
  */
 int dev_pm_opp_disable(struct device *dev, unsigned long freq)
 {
-	return opp_set_availability(dev, freq, false);
+	return _opp_set_availability(dev, freq, false);
 }
 EXPORT_SYMBOL_GPL(dev_pm_opp_disable);
 
@@ -718,7 +718,7 @@ EXPORT_SYMBOL_GPL(dev_pm_opp_disable);
  */
 struct srcu_notifier_head *dev_pm_opp_get_notifier(struct device *dev)
 {
-	struct device_opp *dev_opp = find_device_opp(dev);
+	struct device_opp *dev_opp = _find_device_opp(dev);
 
 	if (IS_ERR(dev_opp))
 		return ERR_CAST(dev_opp); /* matching type */
@@ -761,7 +761,7 @@ int of_init_opp_table(struct device *dev)
 		unsigned long freq = be32_to_cpup(val++) * 1000;
 		unsigned long volt = be32_to_cpup(val++);
 
-		if (dev_pm_opp_add_dynamic(dev, freq, volt, false))
+		if (_opp_add_dynamic(dev, freq, volt, false))
 			dev_warn(dev, "%s: Failed to add OPP %ld\n",
 				 __func__, freq);
 		nr -= 2;
@@ -783,7 +783,7 @@ void of_free_opp_table(struct device *dev)
 	struct dev_pm_opp *opp, *tmp;
 
 	/* Check for existing list for 'dev' */
-	dev_opp = find_device_opp(dev);
+	dev_opp = _find_device_opp(dev);
 	if (WARN(IS_ERR(dev_opp), "%s: dev_opp: %ld\n", dev_name(dev),
 		 PTR_ERR(dev_opp)))
 		return;
@@ -794,7 +794,7 @@ void of_free_opp_table(struct device *dev)
 	/* Free static OPPs */
 	list_for_each_entry_safe(opp, tmp, &dev_opp->opp_list, node) {
 		if (!opp->dynamic)
-			__dev_pm_opp_remove(dev_opp, opp);
+			_opp_remove(dev_opp, opp);
 	}
 
 	mutex_unlock(&dev_opp_list_lock);
-- 
1.7.9.5

