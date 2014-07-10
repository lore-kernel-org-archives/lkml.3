Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174AbaGJV4j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 17:56:39 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:65406 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754142AbaGJV4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 17:56:34 -0400
From: Oded Gabbay <oded.gabbay@gmail.com>
X-Google-Original-From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        John Bridgman <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>, Oded Gabbay <oded.gabbay@amd.com>
Subject: [PATCH 57/83] hsa/radeon: Eliminate warnings in compilation
Date: Fri, 11 Jul 2014 00:54:13 +0300
Message-Id: <1405029279-6894-29-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
References: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/hsa/radeon/kfd_chardev.c      | 6 +++---
 drivers/gpu/hsa/radeon/kfd_kernel_queue.c | 4 ++--
 drivers/gpu/hsa/radeon/kfd_queue.c        | 2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/hsa/radeon/kfd_chardev.c b/drivers/gpu/hsa/radeon/kfd_chardev.c
index 9a77332..80b702e 100644
--- a/drivers/gpu/hsa/radeon/kfd_chardev.c
+++ b/drivers/gpu/hsa/radeon/kfd_chardev.c
@@ -114,8 +114,8 @@ kfd_open(struct inode *inode, struct file *filep)
 
 	process->is_32bit_user_mode = is_compat_task();
 
-	dev_info(kfd_device, "process %d opened, compat mode (32 bit) - %d\n",
-			process->pasid, process->is_32bit_user_mode);
+	dev_dbg(kfd_device, "process %d opened, compat mode (32 bit) - %d\n",
+		process->pasid, process->is_32bit_user_mode);
 
 	kfd_init_apertures(process);
 
@@ -149,7 +149,7 @@ kfd_ioctl_create_queue(struct file *filep, struct kfd_process *p, void __user *a
 	pr_debug("%s Arguments: Queue Percentage (%d, %d)\n"
 			"Queue Priority (%d, %d)\n"
 			"Queue Address (0x%llX, 0x%llX)\n"
-			"Queue Size (%u64, %ll)\n",
+			"Queue Size (%llX, %u)\n",
 			__func__,
 			q_properties.queue_percent, args.queue_percentage,
 			q_properties.priority, args.queue_priority,
diff --git a/drivers/gpu/hsa/radeon/kfd_kernel_queue.c b/drivers/gpu/hsa/radeon/kfd_kernel_queue.c
index aa64693e..25528b3 100644
--- a/drivers/gpu/hsa/radeon/kfd_kernel_queue.c
+++ b/drivers/gpu/hsa/radeon/kfd_kernel_queue.c
@@ -89,8 +89,8 @@ static bool initialize(struct kernel_queue *kq, struct kfd_dev *dev,
 	prop.type = type;
 	prop.vmid = 0;
 	prop.queue_address = kq->pq_gpu_addr;
-	prop.read_ptr = kq->rptr_gpu_addr;
-	prop.write_ptr = kq->wptr_gpu_addr;
+	prop.read_ptr = (qptr_t *) kq->rptr_gpu_addr;
+	prop.write_ptr = (qptr_t *) kq->wptr_gpu_addr;
 
 	if (init_queue(&kq->queue, prop) != 0)
 		goto err_init_queue;
diff --git a/drivers/gpu/hsa/radeon/kfd_queue.c b/drivers/gpu/hsa/radeon/kfd_queue.c
index 2d22cc1..646b6d1 100644
--- a/drivers/gpu/hsa/radeon/kfd_queue.c
+++ b/drivers/gpu/hsa/radeon/kfd_queue.c
@@ -67,7 +67,7 @@ void print_queue(struct queue *q)
 			"Queue Doorbell Pointer: 0x%p\n"
 			"Queue Doorbell Offset: %u\n"
 			"Queue MQD Address: 0x%p\n"
-			"Queue MQD Gart: 0x%p\n"
+			"Queue MQD Gart: 0x%llX\n"
 			"Queue Process Address: 0x%p\n"
 			"Queue Device Address: 0x%p\n",
 					q->properties.type,
-- 
1.9.1

