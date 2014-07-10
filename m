Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240AbaGJWA4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 18:00:56 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:55949 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754289AbaGJV5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 17:57:12 -0400
From: Oded Gabbay <oded.gabbay@gmail.com>
X-Google-Original-From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        John Bridgman <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>, Oded Gabbay <oded.gabbay@amd.com>
Subject: [PATCH 70/83] hsa/radeon: Fix compilation warnings
Date: Fri, 11 Jul 2014 00:54:26 +0300
Message-Id: <1405029279-6894-42-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
References: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/hsa/radeon/kfd_chardev.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/hsa/radeon/kfd_chardev.c b/drivers/gpu/hsa/radeon/kfd_chardev.c
index 51f790f..09c9a61 100644
--- a/drivers/gpu/hsa/radeon/kfd_chardev.c
+++ b/drivers/gpu/hsa/radeon/kfd_chardev.c
@@ -148,21 +148,22 @@ kfd_ioctl_create_queue(struct file *filep, struct kfd_process *p, void __user *a
 	q_properties.priority = args.queue_priority;
 	q_properties.queue_address = args.ring_base_address;
 	q_properties.queue_size = args.ring_size;
-	q_properties.read_ptr = args.read_pointer_address;
-	q_properties.write_ptr = args.write_pointer_address;
+	q_properties.read_ptr = (qptr_t *) args.read_pointer_address;
+	q_properties.write_ptr = (qptr_t *) args.write_pointer_address;
 
 
 	pr_debug("%s Arguments: Queue Percentage (%d, %d)\n"
 			"Queue Priority (%d, %d)\n"
 			"Queue Address (0x%llX, 0x%llX)\n"
-			"Queue Size (%llX, %u)\n",
-			"Queue r/w Pointers (%llX, %llX)\n",
+			"Queue Size (0x%llX, %u)\n"
+			"Queue r/w Pointers (0x%llX, 0x%llX)\n",
 			__func__,
 			q_properties.queue_percent, args.queue_percentage,
 			q_properties.priority, args.queue_priority,
 			q_properties.queue_address, args.ring_base_address,
 			q_properties.queue_size, args.ring_size,
-			q_properties.read_ptr, q_properties.write_ptr);
+			(uint64_t) q_properties.read_ptr,
+			(uint64_t) q_properties.write_ptr);
 
 	dev = radeon_kfd_device_by_id(args.gpu_id);
 	if (dev == NULL)
-- 
1.9.1

