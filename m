Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265AbaGJV5F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 17:57:05 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:36722 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754247AbaGJV5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 17:57:01 -0400
From: Oded Gabbay <oded.gabbay@gmail.com>
X-Google-Original-From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        John Bridgman <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>, Ben Goz <ben.goz@amd.com>,
        Oded Gabbay <oded.gabbay@amd.com>
Subject: [PATCH 66/83] hsa/radeon: Fix number of pipes per ME
Date: Fri, 11 Jul 2014 00:54:22 +0300
Message-Id: <1405029279-6894-38-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
References: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Goz <ben.goz@amd.com>

Signed-off-by: Ben Goz <ben.goz@amd.com>
Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/hsa/radeon/kfd_device_queue_manager.c | 2 +-
 drivers/gpu/hsa/radeon/kfd_device_queue_manager.h | 2 +-
 drivers/gpu/hsa/radeon/kfd_packet_manager.c       | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/hsa/radeon/kfd_device_queue_manager.c b/drivers/gpu/hsa/radeon/kfd_device_queue_manager.c
index 3e1def1..5ec8da7 100644
--- a/drivers/gpu/hsa/radeon/kfd_device_queue_manager.c
+++ b/drivers/gpu/hsa/radeon/kfd_device_queue_manager.c
@@ -55,7 +55,7 @@ static inline unsigned int get_first_pipe(struct device_queue_manager *dqm)
 
 static inline unsigned int get_pipes_num_cpsch(void)
 {
-	return PIPE_PER_ME_CP_SCHEDULING - 1;
+	return PIPE_PER_ME_CP_SCHEDULING;
 }
 
 static unsigned int get_sh_mem_bases_nybble_64(struct kfd_process *process, struct kfd_dev *dev)
diff --git a/drivers/gpu/hsa/radeon/kfd_device_queue_manager.h b/drivers/gpu/hsa/radeon/kfd_device_queue_manager.h
index 57dc636..037eaf8 100644
--- a/drivers/gpu/hsa/radeon/kfd_device_queue_manager.h
+++ b/drivers/gpu/hsa/radeon/kfd_device_queue_manager.h
@@ -31,7 +31,7 @@
 
 #define QUEUE_PREEMPT_DEFAULT_TIMEOUT_MS	(500)
 #define QUEUES_PER_PIPE				(8)
-#define PIPE_PER_ME_CP_SCHEDULING		(4)
+#define PIPE_PER_ME_CP_SCHEDULING		(3)
 #define CIK_VMID_NUM				(8)
 #define KFD_VMID_START_OFFSET			(8)
 #define VMID_PER_DEVICE				CIK_VMID_NUM
diff --git a/drivers/gpu/hsa/radeon/kfd_packet_manager.c b/drivers/gpu/hsa/radeon/kfd_packet_manager.c
index 3fc8c34..621a720 100644
--- a/drivers/gpu/hsa/radeon/kfd_packet_manager.c
+++ b/drivers/gpu/hsa/radeon/kfd_packet_manager.c
@@ -62,7 +62,7 @@ static void pm_calc_rlib_size(struct packet_manager *pm, unsigned int *rlib_size
 	/* check if there is over subscription*/
 	*over_subscription = false;
 	if ((process_count >= VMID_PER_DEVICE) ||
-			queue_count >= PIPE_PER_ME_CP_SCHEDULING * QUEUES_PER_PIPE) {
+			queue_count > PIPE_PER_ME_CP_SCHEDULING * QUEUES_PER_PIPE) {
 		*over_subscription = true;
 		pr_debug("kfd: over subscribed runlist\n");
 	}
-- 
1.9.1

