Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100AbaLXRXF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 12:23:05 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:51982 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751466AbaLXRXB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 12:23:01 -0500
From: Nishanth Menon <nm@ti.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Nishanth Menon <nm@ti.com>
Subject: [PATCH 3/3] PM / OPP: Update kernel documentation
Date: Wed, 24 Dec 2014 11:22:57 -0600
Message-ID: <1419441777-25651-4-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1419441777-25651-1-git-send-email-nm@ti.com>
References: <1419441777-25651-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel doc has gotten bit-rotted over time. Re-sync with Locking and
Return information. document all functions properly and ensure that
./scripts/kernel-doc -v  ./drivers/base/power/opp.c >/dev/null returns
no errors

Signed-off-by: Nishanth Menon <nm@ti.com>
---
 drivers/base/power/opp.c |  127 +++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 114 insertions(+), 13 deletions(-)

diff --git a/drivers/base/power/opp.c b/drivers/base/power/opp.c
index 8ff78c7..3e4504c 100644
--- a/drivers/base/power/opp.c
+++ b/drivers/base/power/opp.c
@@ -115,7 +115,7 @@ static DEFINE_MUTEX(dev_opp_list_lock);
  * Search list of device OPPs for one containing matching device. Does a RCU
  * reader operation to grab the pointer needed.
  *
- * Returns pointer to 'struct device_opp' if found, otherwise -ENODEV or
+ * Return: pointer to 'struct device_opp' if found, otherwise -ENODEV or
  * -EINVAL based on type of error.
  *
  * Locking: This function must be called under rcu_read_lock(). device_opp
@@ -145,7 +145,7 @@ static struct device_opp *_find_device_opp(struct device *dev)
  * dev_pm_opp_get_voltage() - Gets the voltage corresponding to an available opp
  * @opp:	opp for which voltage has to be returned for
  *
- * Return voltage in micro volt corresponding to the opp, else
+ * Return: voltage in micro volt corresponding to the opp, else
  * return 0
  *
  * Locking: This function must be called under rcu_read_lock(). opp is a rcu
@@ -175,7 +175,7 @@ EXPORT_SYMBOL_GPL(dev_pm_opp_get_voltage);
  * dev_pm_opp_get_freq() - Gets the frequency corresponding to an available opp
  * @opp:	opp for which frequency has to be returned for
  *
- * Return frequency in hertz corresponding to the opp, else
+ * Return: frequency in hertz corresponding to the opp, else
  * return 0
  *
  * Locking: This function must be called under rcu_read_lock(). opp is a rcu
@@ -205,7 +205,7 @@ EXPORT_SYMBOL_GPL(dev_pm_opp_get_freq);
  * dev_pm_opp_get_opp_count() - Get number of opps available in the opp list
  * @dev:	device for which we do this operation
  *
- * This function returns the number of available opps if there are any,
+ * Return: This function returns the number of available opps if there are any,
  * else returns 0 if none or the corresponding error value.
  *
  * Locking: This function must be called under rcu_read_lock(). This function
@@ -240,9 +240,9 @@ EXPORT_SYMBOL_GPL(dev_pm_opp_get_opp_count);
  * @freq:		frequency to search for
  * @available:		true/false - match for available opp
  *
- * Searches for exact match in the opp list and returns pointer to the matching
- * opp if found, else returns ERR_PTR in case of error and should be handled
- * using IS_ERR. Error return values can be:
+ * Return: Searches for exact match in the opp list and returns pointer to the
+ * matching opp if found, else returns ERR_PTR in case of error and should
+ * be handled using IS_ERR. Error return values can be:
  * EINVAL:	for bad pointer
  * ERANGE:	no match found for search
  * ENODEV:	if device not found in list of registered devices
@@ -294,7 +294,7 @@ EXPORT_SYMBOL_GPL(dev_pm_opp_find_freq_exact);
  * Search for the matching ceil *available* OPP from a starting freq
  * for a device.
  *
- * Returns matching *opp and refreshes *freq accordingly, else returns
+ * Return: matching *opp and refreshes *freq accordingly, else returns
  * ERR_PTR in case of error and should be handled using IS_ERR. Error return
  * values can be:
  * EINVAL:	for bad pointer
@@ -342,7 +342,7 @@ EXPORT_SYMBOL_GPL(dev_pm_opp_find_freq_ceil);
  * Search for the matching floor *available* OPP from a starting freq
  * for a device.
  *
- * Returns matching *opp and refreshes *freq accordingly, else returns
+ * Return: matching *opp and refreshes *freq accordingly, else returns
  * ERR_PTR in case of error and should be handled using IS_ERR. Error return
  * values can be:
  * EINVAL:	for bad pointer
@@ -386,6 +386,15 @@ struct dev_pm_opp *dev_pm_opp_find_freq_floor(struct device *dev,
 }
 EXPORT_SYMBOL_GPL(dev_pm_opp_find_freq_floor);
 
+/**
+ * _add_device_opp() - Allocate a new device OPP table
+ * @dev:	device for which we do this operation
+ *
+ * New device node which uses OPPs - used when multiple devices with OPP tables
+ * are maintained.
+ *
+ * Return: valid device_opp pointer if success, else NULL.
+ */
 static struct device_opp *_add_device_opp(struct device *dev)
 {
 	struct device_opp *dev_opp;
@@ -407,6 +416,33 @@ static struct device_opp *_add_device_opp(struct device *dev)
 	return dev_opp;
 }
 
+/**
+ * _opp_add_dynamic() - Allocate a dynamic OPP.
+ * @dev:	device for which we do this operation
+ * @freq:	Frequency in Hz for this OPP
+ * @u_volt:	Voltage in uVolts for this OPP
+ * @dynamic:	Dynamically added OPPs.
+ *
+ * This function adds an opp definition to the opp list and returns status.
+ * The opp is made available by default and it can be controlled using
+ * dev_pm_opp_enable/disable functions and may be removed by dev_pm_opp_remove.
+ *
+ * NOTE: "dynamic" parameter impacts OPPs added by the of_init_opp_table and
+ * freed by of_free_opp_table.
+ *
+ * Locking: The internal device_opp and opp structures are RCU protected.
+ * Hence this function internally uses RCU updater strategy with mutex locks
+ * to keep the integrity of the internal data structures. Callers should ensure
+ * that this function is *NOT* called under RCU protection or in contexts where
+ * mutex cannot be locked.
+ *
+ * Return:
+ * 0		On success OR
+ *		Duplicate OPPs (both freq and volt are same) and opp->available
+ * -EEXIST	Freq are same and volt are different OR
+ *		Duplicate OPPs (both freq and volt are same) and !opp->available
+ * -ENOMEM	Memory allocation failure
+ */
 static int _opp_add_dynamic(struct device *dev, unsigned long freq,
 			    long u_volt, bool dynamic)
 {
@@ -502,11 +538,11 @@ free_opp:
  * mutex cannot be locked.
  *
  * Return:
- * 0:		On success OR
+ * 0		On success OR
  *		Duplicate OPPs (both freq and volt are same) and opp->available
- * -EEXIST:	Freq are same and volt are different OR
+ * -EEXIST	Freq are same and volt are different OR
  *		Duplicate OPPs (both freq and volt are same) and !opp->available
- * -ENOMEM:	Memory allocation failure
+ * -ENOMEM	Memory allocation failure
  */
 int dev_pm_opp_add(struct device *dev, unsigned long freq, unsigned long u_volt)
 {
@@ -514,6 +550,10 @@ int dev_pm_opp_add(struct device *dev, unsigned long freq, unsigned long u_volt)
 }
 EXPORT_SYMBOL_GPL(dev_pm_opp_add);
 
+/**
+ * _kfree_opp_rcu() - Free OPP RCU handler
+ * @head:	RCU head
+ */
 static void _kfree_opp_rcu(struct rcu_head *head)
 {
 	struct dev_pm_opp *opp = container_of(head, struct dev_pm_opp, rcu_head);
@@ -521,6 +561,10 @@ static void _kfree_opp_rcu(struct rcu_head *head)
 	kfree_rcu(opp, rcu_head);
 }
 
+/**
+ * _kfree_device_rcu() - Free device_opp RCU handler
+ * @head:	RCU head
+ */
 static void _kfree_device_rcu(struct rcu_head *head)
 {
 	struct device_opp *device_opp = container_of(head, struct device_opp, rcu_head);
@@ -528,6 +572,17 @@ static void _kfree_device_rcu(struct rcu_head *head)
 	kfree_rcu(device_opp, rcu_head);
 }
 
+/**
+ * _opp_remove()  - Remove an OPP from a table definition
+ * @dev_opp:	points back to the device_opp struct this opp belongs to
+ * @opp:	pointer to the OPP to remove
+ *
+ * This function removes an opp definition from the opp list.
+ *
+ * Locking: The internal device_opp and opp structures are RCU protected.
+ * It is assumed that the caller holds required mutex for an RCU updater
+ * strategy.
+ */
 static void _opp_remove(struct device_opp *dev_opp,
 			struct dev_pm_opp *opp)
 {
@@ -552,6 +607,12 @@ static void _opp_remove(struct device_opp *dev_opp,
  * @freq:	OPP to remove with matching 'freq'
  *
  * This function removes an opp from the opp list.
+ *
+ * Locking: The internal device_opp and opp structures are RCU protected.
+ * Hence this function internally uses RCU updater strategy with mutex locks
+ * to keep the integrity of the internal data structures. Callers should ensure
+ * that this function is *NOT* called under RCU protection or in contexts where
+ * mutex cannot be locked.
  */
 void dev_pm_opp_remove(struct device *dev, unsigned long freq)
 {
@@ -594,7 +655,7 @@ EXPORT_SYMBOL_GPL(dev_pm_opp_remove);
  * Set the availability of an OPP with an RCU operation, opp_{enable,disable}
  * share a common logic which is isolated here.
  *
- * Returns -EINVAL for bad pointers, -ENOMEM if no memory available for the
+ * Return: -EINVAL for bad pointers, -ENOMEM if no memory available for the
  * copy operation, returns 0 if no modifcation was done OR modification was
  * successful.
  *
@@ -683,6 +744,10 @@ unlock:
  * integrity of the internal data structures. Callers should ensure that
  * this function is *NOT* called under RCU protection or in contexts where
  * mutex locking or synchronize_rcu() blocking calls cannot be used.
+ *
+ * Return: -EINVAL for bad pointers, -ENOMEM if no memory available for the
+ * copy operation, returns 0 if no modifcation was done OR modification was
+ * successful.
  */
 int dev_pm_opp_enable(struct device *dev, unsigned long freq)
 {
@@ -705,6 +770,10 @@ EXPORT_SYMBOL_GPL(dev_pm_opp_enable);
  * integrity of the internal data structures. Callers should ensure that
  * this function is *NOT* called under RCU protection or in contexts where
  * mutex locking or synchronize_rcu() blocking calls cannot be used.
+ *
+ * Return: -EINVAL for bad pointers, -ENOMEM if no memory available for the
+ * copy operation, returns 0 if no modifcation was done OR modification was
+ * successful.
  */
 int dev_pm_opp_disable(struct device *dev, unsigned long freq)
 {
@@ -715,6 +784,16 @@ EXPORT_SYMBOL_GPL(dev_pm_opp_disable);
 /**
  * dev_pm_opp_get_notifier() - find notifier_head of the device with opp
  * @dev:	device pointer used to lookup device OPPs.
+ *
+ * Return: pointer to  notifier head if found, otherwise -ENODEV or
+ * -EINVAL based on type of error casted as pointer. value must be checked
+ *  with IS_ERR to determine valid pointer or error result.
+ *
+ * Locking: This function must be called under rcu_read_lock(). dev_opp is a RCU
+ * protected pointer. The reason for the same is that the opp pointer which is
+ * returned will remain valid for use with opp_get_{voltage, freq} only while
+ * under the locked area. The pointer returned must be used prior to unlocking
+ * with rcu_read_unlock() to maintain the integrity of the pointer.
  */
 struct srcu_notifier_head *dev_pm_opp_get_notifier(struct device *dev)
 {
@@ -733,6 +812,22 @@ EXPORT_SYMBOL_GPL(dev_pm_opp_get_notifier);
  * @dev:	device pointer used to lookup device OPPs.
  *
  * Register the initial OPP table with the OPP library for given device.
+ *
+ * Locking: The internal device_opp and opp structures are RCU protected.
+ * Hence this function indirectly uses RCU updater strategy with mutex locks
+ * to keep the integrity of the internal data structures. Callers should ensure
+ * that this function is *NOT* called under RCU protection or in contexts where
+ * mutex cannot be locked.
+ *
+ * Return:
+ * 0		On success OR
+ *		Duplicate OPPs (both freq and volt are same) and opp->available
+ * -EEXIST	Freq are same and volt are different OR
+ *		Duplicate OPPs (both freq and volt are same) and !opp->available
+ * -ENOMEM	Memory allocation failure
+ * -ENODEV	when 'operating-points' property is not found or is invalid data
+ *		in device node.
+ * -ENODATA	when empty 'operating-points' property is found
  */
 int of_init_opp_table(struct device *dev)
 {
@@ -776,6 +871,12 @@ EXPORT_SYMBOL_GPL(of_init_opp_table);
  * @dev:	device pointer used to lookup device OPPs.
  *
  * Free OPPs created using static entries present in DT.
+ *
+ * Locking: The internal device_opp and opp structures are RCU protected.
+ * Hence this function indirectly uses RCU updater strategy with mutex locks
+ * to keep the integrity of the internal data structures. Callers should ensure
+ * that this function is *NOT* called under RCU protection or in contexts where
+ * mutex cannot be locked.
  */
 void of_free_opp_table(struct device *dev)
 {
-- 
1.7.9.5

