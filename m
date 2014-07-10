Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010AbaGJVzl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 17:55:41 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:58360 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431AbaGJVze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 17:55:34 -0400
From: Oded Gabbay <oded.gabbay@gmail.com>
X-Google-Original-From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        John Bridgman <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>,
        Alexey Skidanov <Alexey.Skidanov@amd.com>,
        Oded Gabbay <oded.gabbay@amd.com>
Subject: [PATCH 43/83] hsa/radeon: NULL pointer dereference bug workaround
Date: Fri, 11 Jul 2014 00:53:59 +0300
Message-Id: <1405029279-6894-15-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
References: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Skidanov <Alexey.Skidanov@amd.com>

Signed-off-by: Alexey Skidanov <Alexey.Skidanov@amd.com>
Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/hsa/radeon/kfd_sched_cik_static.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/hsa/radeon/kfd_sched_cik_static.c b/drivers/gpu/hsa/radeon/kfd_sched_cik_static.c
index 7573d25..7ee8125 100644
--- a/drivers/gpu/hsa/radeon/kfd_sched_cik_static.c
+++ b/drivers/gpu/hsa/radeon/kfd_sched_cik_static.c
@@ -627,8 +627,10 @@ static void cik_static_deregister_process(struct kfd_scheduler *scheduler,
 	struct cik_static_private *priv = kfd_scheduler_to_private(scheduler);
 	struct cik_static_process *pp = kfd_process_to_private(scheduler_process);
 
-	release_vmid(priv, pp->vmid);
-	kfree(pp);
+	if (priv && pp) {
+		release_vmid(priv, pp->vmid);
+		kfree(pp);
+	}
 }
 
 static bool allocate_hqd(struct cik_static_private *priv, unsigned int *queue)
-- 
1.9.1

