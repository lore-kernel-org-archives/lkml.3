Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751727AbaGJV4i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 17:56:38 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:56571 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbaGJV4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 17:56:35 -0400
From: Oded Gabbay <oded.gabbay@gmail.com>
X-Google-Original-From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        John Bridgman <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>, Oded Gabbay <oded.gabbay@amd.com>
Subject: [PATCH 58/83] hsa/radeon: Various kernel styling fixes
Date: Fri, 11 Jul 2014 00:54:14 +0300
Message-Id: <1405029279-6894-30-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
References: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/hsa/radeon/kfd_device_queue_manager.h |  6 +++---
 drivers/gpu/hsa/radeon/kfd_hw_pointer_store.h     |  6 +++---
 drivers/gpu/hsa/radeon/kfd_kernel_queue.h         |  6 +++---
 drivers/gpu/hsa/radeon/kfd_module.c               |  8 ++++----
 drivers/gpu/hsa/radeon/kfd_mqd_manager.h          |  6 +++---
 drivers/gpu/hsa/radeon/kfd_pm4_headers.h          | 11 ++++++-----
 drivers/gpu/hsa/radeon/kfd_pm4_opcodes.h          |  6 +++---
 7 files changed, 25 insertions(+), 24 deletions(-)

diff --git a/drivers/gpu/hsa/radeon/kfd_device_queue_manager.h b/drivers/gpu/hsa/radeon/kfd_device_queue_manager.h
index fe9ef10..57dc636 100644
--- a/drivers/gpu/hsa/radeon/kfd_device_queue_manager.h
+++ b/drivers/gpu/hsa/radeon/kfd_device_queue_manager.h
@@ -21,8 +21,8 @@
  *
  */
 
-#ifndef DEVICE_QUEUE_MANAGER_H_
-#define DEVICE_QUEUE_MANAGER_H_
+#ifndef KFD_DEVICE_QUEUE_MANAGER_H_
+#define KFD_DEVICE_QUEUE_MANAGER_H_
 
 #include <linux/rwsem.h>
 #include <linux/list.h>
@@ -98,4 +98,4 @@ struct device_queue_manager {
 
 
 
-#endif /* DEVICE_QUEUE_MANAGER_H_ */
+#endif /* KFD_DEVICE_QUEUE_MANAGER_H_ */
diff --git a/drivers/gpu/hsa/radeon/kfd_hw_pointer_store.h b/drivers/gpu/hsa/radeon/kfd_hw_pointer_store.h
index f384b7f..642703f 100644
--- a/drivers/gpu/hsa/radeon/kfd_hw_pointer_store.h
+++ b/drivers/gpu/hsa/radeon/kfd_hw_pointer_store.h
@@ -21,8 +21,8 @@
  *
  */
 
-#ifndef HW_POINTER_STORE_H_
-#define HW_POINTER_STORE_H_
+#ifndef KFD_HW_POINTER_STORE_H_
+#define KFD_HW_POINTER_STORE_H_
 
 #include <linux/mutex.h>
 
@@ -61,4 +61,4 @@ radeon_kfd_hw_pointer_store_mmap(struct hw_pointer_store_properties *ptr,
 		struct vm_area_struct *vma);
 
 
-#endif /* HW_POINTER_STORE_H_ */
+#endif /* KFD_HW_POINTER_STORE_H_ */
diff --git a/drivers/gpu/hsa/radeon/kfd_kernel_queue.h b/drivers/gpu/hsa/radeon/kfd_kernel_queue.h
index 963e861..abfb9c8 100644
--- a/drivers/gpu/hsa/radeon/kfd_kernel_queue.h
+++ b/drivers/gpu/hsa/radeon/kfd_kernel_queue.h
@@ -21,8 +21,8 @@
  *
  */
 
-#ifndef KERNEL_QUEUE_H_
-#define KERNEL_QUEUE_H_
+#ifndef KFD_KERNEL_QUEUE_H_
+#define KFD_KERNEL_QUEUE_H_
 
 #include <linux/list.h>
 #include <linux/types.h>
@@ -63,4 +63,4 @@ struct kernel_queue {
 	struct list_head	list;
 };
 
-#endif /* KERNEL_QUEUE_H_ */
+#endif /* KFD_KERNEL_QUEUE_H_ */
diff --git a/drivers/gpu/hsa/radeon/kfd_module.c b/drivers/gpu/hsa/radeon/kfd_module.c
index e8bb67c..85069c5 100644
--- a/drivers/gpu/hsa/radeon/kfd_module.c
+++ b/drivers/gpu/hsa/radeon/kfd_module.c
@@ -24,7 +24,7 @@
 #include <linux/sched.h>
 #include <linux/notifier.h>
 #include <linux/moduleparam.h>
-
+#include <linux/device.h>
 #include "kfd_priv.h"
 
 #define DRIVER_AUTHOR		"Andrew Lewycky, Oded Gabbay, Evgeny Pinchuk, others."
@@ -46,7 +46,7 @@ static const struct kgd2kfd_calls kgd2kfd = {
 
 int sched_policy = KFD_SCHED_POLICY_HWS_NO_OVERSUBSCRIPTION;
 module_param(sched_policy, int, S_IRUSR | S_IWUSR);
-MODULE_PARM_DESC(sched_policy, "Kernel comline parameter define the kfd scheduling policy");
+MODULE_PARM_DESC(sched_policy, "Kernel cmdline parameter define the kfd scheduling policy");
 
 bool kgd2kfd_init(unsigned interface_version,
 		  const struct kfd2kgd_calls *f2g,
@@ -95,7 +95,7 @@ static int __init kfd_module_init(void)
 	if (err < 0)
 		goto err_topology;
 
-	pr_info("[hsa] Initialized kfd module");
+	dev_info(kfd_device, "Initialized module\n");
 
 	return 0;
 err_topology:
@@ -114,7 +114,7 @@ static void __exit kfd_module_exit(void)
 	mmput_unregister_notifier(&kfd_mmput_nb);
 	radeon_kfd_chardev_exit();
 	radeon_kfd_pasid_exit();
-	pr_info("[hsa] Removed kfd module");
+	dev_info(kfd_device, "Removed module\n");
 }
 
 module_init(kfd_module_init);
diff --git a/drivers/gpu/hsa/radeon/kfd_mqd_manager.h b/drivers/gpu/hsa/radeon/kfd_mqd_manager.h
index 8e7a5fd..314d490 100644
--- a/drivers/gpu/hsa/radeon/kfd_mqd_manager.h
+++ b/drivers/gpu/hsa/radeon/kfd_mqd_manager.h
@@ -21,8 +21,8 @@
  *
  */
 
-#ifndef MQD_MANAGER_H_
-#define MQD_MANAGER_H_
+#ifndef KFD_MQD_MANAGER_H_
+#define KFD_MQD_MANAGER_H_
 
 #include "kfd_priv.h"
 
@@ -44,4 +44,4 @@ struct mqd_manager {
 };
 
 
-#endif /* MQD_MANAGER_H_ */
+#endif /* KFD_MQD_MANAGER_H_ */
diff --git a/drivers/gpu/hsa/radeon/kfd_pm4_headers.h b/drivers/gpu/hsa/radeon/kfd_pm4_headers.h
index dae460f..3ffb3f4 100644
--- a/drivers/gpu/hsa/radeon/kfd_pm4_headers.h
+++ b/drivers/gpu/hsa/radeon/kfd_pm4_headers.h
@@ -21,8 +21,8 @@
  *
  */
 
-#ifndef F32_MES_PM4_PACKETS_72_H
-#define F32_MES_PM4_PACKETS_72_H
+#ifndef KFD_PM4_HEADERS_H_
+#define KFD_PM4_HEADERS_H_
 
 #ifndef PM4_HEADER_DEFINED
 #define PM4_HEADER_DEFINED
@@ -657,7 +657,7 @@ typedef struct _PM4__SET_SH_REG {
 #ifndef _PM4__SET_CONFIG_REG_DEFINED
 #define _PM4__SET_CONFIG_REG_DEFINED
 
-typedef struct _PM4__SET_CONFIG_REG {
+struct pm4__set_config_reg {
 	union {
 		PM4_TYPE_3_HEADER header;
 		unsigned int ordinal1;
@@ -676,6 +676,7 @@ typedef struct _PM4__SET_CONFIG_REG {
 
 	unsigned int reg_data[1];	/* 1..N of these fields */
 
-}  PM4_SET_CONFIG_REG, *PPM4_SET_CONFIG_REG;
-#endif
+};
 #endif
+
+#endif /* KFD_PM4_HEADERS_H_ */
diff --git a/drivers/gpu/hsa/radeon/kfd_pm4_opcodes.h b/drivers/gpu/hsa/radeon/kfd_pm4_opcodes.h
index c04060c..b72fa3b 100644
--- a/drivers/gpu/hsa/radeon/kfd_pm4_opcodes.h
+++ b/drivers/gpu/hsa/radeon/kfd_pm4_opcodes.h
@@ -22,8 +22,8 @@
  */
 
 
-#ifndef PM4_IT_OPCODES_H
-#define PM4_IT_OPCODES_H
+#ifndef KFD_PM4_OPCODES_H
+#define KFD_PM4_OPCODES_H
 
 enum it_opcode_type {
 	IT_NOP                               = 0x10,
@@ -103,5 +103,5 @@ enum it_opcode_type {
 #define PM4_TYPE_2 2
 #define PM4_TYPE_3 3
 
-#endif /* PM4_IT_OPCODES_H */
+#endif /* KFD_PM4_OPCODES_H */
 
-- 
1.9.1

